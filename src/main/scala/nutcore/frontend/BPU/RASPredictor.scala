package nutcore

import chisel3._
import chisel3.util._
import chisel3.util.experimental.BoringUtils

import utils._
import top.Settings

class RASPredictor extends Predictor {
  // RAS
  val ras = Mem(NRRAS, UInt(VAddrBits.W))
  // val raBrIdxs = Mem(NRRAS, UInt(2.W))
  val sp = Counter(NRRAS)
  val rasTarget = RegEnable(ras.read(sp.value), io.pc.valid)
  // val rasBrIdx = RegEnable(raBrIdxs.read(sp.value), io.pc.valid)

  // predict
  when (io.btb.entry._type === BTBtype.R) {
    io.out.valid := true.B && rasTarget=/=0.U //TODO: add rasTarget=/=0.U, need fix
    io.out.target := rasTarget
  }

  // RAS update
  when (io.update.valid) {
    when (io.update.fuOpType === ALUOpType.call)  {
      ras.write(sp.value + 1.U, Mux(io.update.isRVC, io.update.pc + 2.U, io.update.pc + 4.U))
      // raBrIdxs.write(sp.value + 1.U, Mux(io.update.pc(1), 2.U, 1.U))
      sp.value := sp.value + 1.U
    }
      .elsewhen (io.update.fuOpType === ALUOpType.ret) {
        when(sp.value === 0.U) {
          //Debug("ATTTTT: sp.value is 0.U\n") //TODO: sp.value may equal to 0.U
        }
        sp.value := Mux(sp.value===0.U, 0.U, sp.value - 1.U) //TODO: sp.value may less than 0.U
      }
  }
}
