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

class BBGSharePredictorImp_BSD_sim extends BlackBox() with HasBlackBoxResource {
  val io = IO(new Bundle {
    val pc = Input(UInt(32.W))
    val train_pc = Input(UInt(32.W))
    val train_taken = Input(Bool())
    val pht_rdata = Input(UInt(2.W))
    val ghr_rdata = Input(UInt(16.W))
    val taken = Output(Bool())
    val pht_wdata = Output(Bool())
    val pht_raddr = Output(UInt(9.W))
    val pht_waddr = Output(UInt(9.W))
    val ghr_wdata = Output(Bool())
  }).suggestName("io")
  addResource("/nutcore/frontend/BPU/BBGSharePredictorImp_BSD_sim.v")
}

class BBGSharePredictor extends Predictor { // wrapper
  val pht = RegInit(VecInit(Seq.fill(512)(2.U(2.W)))) // weak taken
  val ghr = RegInit(0.U(16.W))

  val imp = Module(new BBGSharePredictorImp_BSD_sim)
  imp.io.pc := RegEnable(io.pc.bits, io.pc.valid) // latch 1 cycle to sync with btbread
  imp.io.pht_rdata := RegEnable(pht(imp.io.pht_raddr), io.pc.valid)
  imp.io.ghr_rdata := RegEnable(ghr, io.pc.valid)

  imp.io.train_pc := io.update.pc
  imp.io.train_taken := io.update.actualTaken

  when (RegNext(io.pc.valid)) {
    printf("pc=%x, pht_raddr=%x, pht_rdata=%x, ghr_rdata=%x, taken=%x\n", imp.io.pc, imp.io.pht_raddr, imp.io.pht_rdata, imp.io.ghr_rdata, imp.io.taken)
    printf("want         pht_raddr=%x,                              taken=%x\n",
      ((imp.io.ghr_rdata(15,12) ^ imp.io.ghr_rdata(11,8) ^ imp.io.ghr_rdata(7,4) ^ imp.io.ghr_rdata(3,0)) << 5) ^ imp.io.pc(10,2),
      imp.io.pht_rdata(1)
    )
  }

  when (io.btb.entry._type === BTBtype.B) {
    io.out.valid := imp.io.taken
    io.out.meta.ghr := RegEnable(ghr, io.pc.valid)
  }

  // PHT update
  val updateLatch = RegNext(io.update)
  when (io.update.valid && ALUOpType.isBranch(io.update.fuOpType)) {
    val sat = Module(new BB2bcImp())
    sat.io.x := pht(imp.io.pht_waddr)
    sat.io.c := imp.io.pht_wdata
    pht(imp.io.pht_waddr) := sat.io.y
    BPUDebug(true.B, "[%d] PHT update pc=%x, cnt=%x->%x\n", GTimer(), updateLatch.pc, pht(imp.io.pht_waddr), sat.io.y)
  }

  // GHR update
  // recover on miss predict
  val new_ghr = WireInit(ghr)
  when (io.update.valid && ALUOpType.isBranch(io.update.fuOpType) && io.update.isMissPredict) {
    // NOTE: on a miss predict, redirect will be issued by wbu (1 cycle later than alu, and therefore, BPUUpdateReq)
    //       so, when the redirected pc is sent from ifu, ghr is already updated, that's good
    new_ghr := Cat(io.update.meta.ghr, imp.io.ghr_wdata)
    BPUDebug(true.B, "[%d] GHR update miss pc=%x ghr=%x->%x, predicted at %d\n", GTimer(), io.update.pc, ghr, new_ghr, io.update.meta.time)
  }
  // speculative update
  .elsewhen (io.btb.hit && io.btb.entry._type === BTBtype.B) {
    new_ghr := Cat(ghr, imp.io.taken)
    BPUDebug(true.B, "[%d] GHR update spec pc=%x ghr=%x->%x\n", GTimer(), RegEnable(io.pc.bits, io.pc.valid), ghr, new_ghr)
  }
  ghr := new_ghr
}
