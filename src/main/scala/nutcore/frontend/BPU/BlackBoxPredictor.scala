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
