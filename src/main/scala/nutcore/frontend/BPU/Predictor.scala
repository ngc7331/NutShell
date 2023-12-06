package nutcore

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils

import utils._
import top.Settings

class PredictorIO extends NutCoreBundle {
  // predict
  val pc = Flipped(Valid(UInt(VAddrBits.W)))
  val btb = Input(new Bundle{
    val hit = Bool()
    val entry = new BTBEntry
  })
  val in = Flipped(new RedirectIO)
  val out = new RedirectIO
  // update
  val update = Input(new BPUUpdateReq)
}

class Predictor extends NutCoreModule with HasBPUConst {
  val io = IO(new PredictorIO)
  io.out := io.in
}
