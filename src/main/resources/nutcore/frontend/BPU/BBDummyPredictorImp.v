module BBDummyPredictorImp(
    input clk,
    input rst,
    input in_valid,
    input [63:0] pc,
    output out_valid
);
    assign out_valid = 0;
endmodule
