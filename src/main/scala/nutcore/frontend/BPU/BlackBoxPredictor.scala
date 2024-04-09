package nutcore

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils
import chisel3.util.HasBlackBoxResource

import utils._
import top.Settings

class BBDummyPredictorImp extends BlackBox() with HasBlackBoxResource {
  val io = IO(new Bundle {
    val clk = Input(Clock())
    val rst = Input(Reset())
    val in_valid = Input(Bool())
    val pc = Input(UInt(64.W))
    val out_valid = Output(Bool())
  }).suggestName("io")
  addResource("/nutcore/frontend/BPU/BBDummyPredictorImp.v")
}

class BBDummyPredictor extends Predictor { // wrapper
  val imp = Module(new BBDummyPredictorImp)
  imp.io.clk := clock
  imp.io.rst := reset
  imp.io.in_valid := io.pc.valid
  imp.io.pc := io.pc.bits

  when (io.btb.entry._type === BTBtype.B) {
    io.out.valid := imp.io.out_valid
  }
}

class BB2bcImp extends BlackBox() with HasBlackBoxResource {
  val io = IO(new Bundle {
    val x = Input(UInt(2.W))
    val c = Input(Bool())
    val y = Output(UInt(2.W))
  }).suggestName("io")
  addResource("/BB2bcImp.v")
}

class BBGSharePredictorImp_BSD extends BlackBox() with HasBlackBoxResource {
  val io = IO(new Bundle {
    val pc = Input(UInt(32.W))
    val train_pc = Input(UInt(32.W))
    val train_taken = Input(Bool())
    val pht_rdata = Input(UInt(2.W))
    val ghr_rdata = Input(UInt(16.W))
    val train_ghr_rdata = Input(UInt(16.W))
    val taken = Output(Bool())
    val pht_wdata = Output(Bool())
    val pht_raddr = Output(UInt(9.W))
    val pht_waddr = Output(UInt(9.W))
    val ghr_wdata = Output(Bool())
  }).suggestName("io")
}

class BBGSharePredictorImp_BSD_sim extends BBGSharePredictorImp_BSD {
  addResource("/nutcore/frontend/BPU/BBGSharePredictorImp_BSD_sim.v")
}

class BBGSharePredictorImp_BSD_NutShell extends BBGSharePredictorImp_BSD {
  addResource("/nutcore/frontend/BPU/BBGSharePredictorImp_BSD_NutShell.v")
}

class BBGSharePredictorImp_BSD_NutShell_less extends BBGSharePredictorImp_BSD {
  addResource("/nutcore/frontend/BPU/BBGSharePredictorImp_BSD_NutShell_less.v")
}

class BBGSharePredictorImp_BSD_sim_split extends BBGSharePredictorImp_BSD {
  addResource("/nutcore/frontend/BPU/BBGSharePredictorImp_BSD_sim_split.v")
}

/* wrapper */
class BBGSharePredictor extends Predictor {
  val pht = Mem(NRSetPHT, UInt(SatLength.W))
  val ghr = RegInit(0.U(16.W))

  val imp = Module(new BBGSharePredictorImp_BSD_NutShell)
  println("Using " + imp.getClass.getName)
  imp.io.pc := io.pc.bits
  // latch 1 cycle to sync with btbread
  imp.io.pht_rdata := RegNext(pht.read(imp.io.pht_raddr))
  imp.io.ghr_rdata := ghr

  imp.io.train_pc := io.update.pc
  imp.io.train_taken := io.update.actualTaken
  imp.io.train_ghr_rdata := io.update.meta.ghr

  when (io.btb.entry._type === BTBtype.B) {
    io.out.valid := imp.io.taken
    io.out.meta.ghr := RegNext(ghr)
  }

  // PHT update
  val cnt = RegNext(pht.read(imp.io.pht_waddr))
  val updateLatch = RegNext(io.update)
  when (updateLatch.valid && ALUOpType.isBranch(updateLatch.fuOpType)) {
    val sat = Module(new BB2bcImp())
    sat.io.x := cnt
    sat.io.c := RegNext(imp.io.pht_wdata)
    pht.write(RegNext(imp.io.pht_waddr), sat.io.y)
    BPUDebug(true.B, "[%d] PHT update pc=%x, cnt=%x->%x\n", GTimer(), updateLatch.pc, cnt, sat.io.y)
  }

  // GHR update
  // recover on miss predict
  val new_ghr = WireInit(ghr)
  when (io.update.valid && ALUOpType.isBranch(io.update.fuOpType) && io.update.isMissPredict) {
    // NOTE: on a miss predict, redirect will be issued by wbu (1 cycle later than alu, and therefore, BPUUpdateReq)
    //       so, when the redirected pc is sent from ifu, ghr is already updated, that's good
    new_ghr := Cat(imp.io.train_ghr_rdata, imp.io.ghr_wdata)
    BPUDebug(true.B, "[%d] GHR update miss pc=%x ghr=%x->%x, predicted at %d\n", GTimer(), io.update.pc, ghr, new_ghr, io.update.meta.time)
  }
  // speculative update
  .elsewhen (io.btb.hit && io.btb.entry._type === BTBtype.B) {
    new_ghr := Cat(ghr, imp.io.taken)
    BPUDebug(true.B, "[%d] GHR update spec pc=%x ghr=%x->%x\n", GTimer(), RegNext(io.pc.bits), ghr, new_ghr)
  }
  ghr := new_ghr

  // trace
  // when ((io.btb.hit && io.btb.entry._type === BTBtype.B && RegNext(io.pc.valid)) || RegNext(io.update.valid)) {
  //   printf(
  //     "%b,%b,%b,%b,%b,%b,%b,%b,%b,%b,%b\n",
  //     imp.io.pc,              // pc
  //     imp.io.taken,           // taken
  //     imp.io.train_pc,        // train_pc
  //     imp.io.train_taken,     // train_taken
  //     imp.io.pht_rdata,       // pht_rdata
  //     imp.io.pht_wdata,       // pht_wdata
  //     imp.io.pht_raddr,       // pht_raddr
  //     imp.io.pht_waddr,       // pht_waddr
  //     imp.io.ghr_rdata,       // ghr_rdata
  //     imp.io.ghr_wdata,       // ghr_wdata
  //     imp.io.train_ghr_rdata  // train_ghr_rdata
  //   )
  // }
}
