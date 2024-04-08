package nutcore

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils

import utils._
import top.Settings

class GSharePredictor extends Predictor {
  val pcLatch = RegEnable(io.pc.bits, io.pc.valid)
  // GHR
  def fold(x: UInt, from: Int, to: Int): UInt = {
    if (from <= to) {
      x
    } else {
      fold(x(from-1, to), from-to, to) ^ x(to-1, 0)
    }
  }
  val ghr = RegInit(0.U(GHRLength.W))
  val ghrLatch = RegEnable(ghr, io.pc.valid)

  // PHT
  def getPHTIdx(pc:UInt, ghr:UInt): UInt = {
    val padLen = (new BTBAddr).padLen
    pc(padLen + PHTIdxBits - 1, padLen) ^ (fold(ghr, GHRLength, GHRFoldLength) << (PHTIdxBits - GHRFoldLength))
  }

  val pht = Mem(NRSetPHT, UInt(SatLength.W))
  val phtTaken = RegEnable(pht.read(getPHTIdx(io.pc.bits, ghr))(SatLength-1), io.pc.valid)

  // predict
  when (io.btb.entry._type === BTBtype.B) {
    io.out.valid := phtTaken
    io.out.meta.ghr := ghrLatch // latch 1 cycle to sync with phtTaken
  }

  // PHT update
  val cnt = RegNext(pht.read(getPHTIdx(io.update.pc, io.update.meta.ghr)))
  val updateLatch = RegNext(io.update)
  when (updateLatch.valid && ALUOpType.isBranch(updateLatch.fuOpType)) {
    val taken = updateLatch.actualTaken
    val newCnt = Mux(taken, cnt + 1.U, cnt - 1.U)
    val wen = (taken && (cnt =/= ((1 << SatLength) - 1).U)) || (!taken && (cnt =/= 0.U))
    when (wen) {
      pht.write(getPHTIdx(updateLatch.pc, updateLatch.meta.ghr), newCnt)
      BPUDebug(true.B, "[%d] PHT update pc=%x, cnt=%x->%x\n", GTimer(), updateLatch.pc, cnt, newCnt)
    }
  }

  // GHR update
  // recover on miss predict
  val new_ghr = WireInit(ghr)
  when (io.update.valid && ALUOpType.isBranch(io.update.fuOpType) && io.update.isMissPredict) {
    // NOTE: on a miss predict, redirect will be issued by wbu (1 cycle later than alu, and therefore, BPUUpdateReq)
    //       so, when the redirected pc is sent from ifu, ghr is already updated, that's good
    new_ghr := Cat(io.update.meta.ghr, io.update.actualTaken)
    BPUDebug(true.B, "[%d] GHR update miss pc=%x ghr=%x->%x, predicted at %d\n", GTimer(), io.update.pc, ghr, new_ghr, io.update.meta.time)
  }
  // speculative update
  .elsewhen (io.btb.hit && io.btb.entry._type === BTBtype.B) {
    new_ghr := Cat(ghr, phtTaken)
    BPUDebug(true.B, "[%d] GHR update spec pc=%x ghr=%x->%x\n", GTimer(), pcLatch, ghr, new_ghr)
  }
  ghr := new_ghr

  // trace
  // when ((io.btb.hit && io.btb.entry._type === BTBtype.B && RegNext(io.pc.valid)) || io.update.valid) {
  //   printf(
  //     "%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b\n",
  //     RegNext(io.pc.bits(31,0)),                                     // pc
  //     RegNext(pht.read(getPHTIdx(io.pc.bits, ghr))(SatLength-1)),    // taken
  //     io.update.pc(31,0),                                            // train_pc
  //     io.update.actualTaken,                                         // train_taken
  //     RegNext(pht.read(getPHTIdx(io.pc.bits, ghr))),                 // pht_rdata
  //     io.update.actualTaken,                                         // pht_wdata
  //     RegNext(getPHTIdx(io.pc.bits, ghr)),                           // pht_raddr
  //     getPHTIdx(io.update.pc, io.update.meta.ghr),                   // pht_waddr
  //     RegNext(ghr),                                                  // ghr_rdata
  //     io.update.actualTaken,                                         // ghr_wdata
  //     io.update.meta.ghr                                             // train_ghr_rdata
  //   )
  // }
}
