package nutcore

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils

import utils._
import top.Settings

class PHTPredictor extends Predictor {
  // PHT
  def getPHTIdx(pc:UInt): UInt = {
    val padLen = (new BTBAddr).padLen
    pc(padLen + PHTIdxBits - 1, padLen)
  }

  val pht = Mem(NRSetPHT, UInt(SatLength.W))
  val phtTaken = RegEnable(pht.read(getPHTIdx(io.pc.bits))(SatLength-1), io.pc.valid)

  // predict
  when (io.btb.entry._type === BTBtype.B) {
    io.out.valid := phtTaken
  }

  // PHT update
  val cnt = RegNext(pht.read(getPHTIdx(io.update.pc)))
  val updateLatch = RegNext(io.update)
  when (updateLatch.valid && ALUOpType.isBranch(updateLatch.fuOpType)) {
    val taken = updateLatch.actualTaken
    val newCnt = Mux(taken, cnt + 1.U, cnt - 1.U)
    val wen = (taken && (cnt =/= ((1 << SatLength) - 1).U)) || (!taken && (cnt =/= 0.U))
    when (wen) {
      pht.write(getPHTIdx(updateLatch.pc), newCnt)
      BPUDebug(true.B, "[%d] PHT update pc=%x, cnt=%x->%x\n", GTimer(), updateLatch.pc, cnt, newCnt)
    }
  }
}
