module BBGSharePredictorImp_BSD_c_sim_split(
    input [31:0] pc,
    input [1:0] pht_rdata,
    input [15:0] ghr_rdata,
    output  taken,
    output [8:0] pht_raddr,
    input [31:0] train_pc,
    input  train_taken,
    input [15:0] train_ghr_rdata,
    output  pht_wdata,
    output [8:0] pht_waddr,
    output  ghr_wdata
);

BBGSharePredictorImp_BSD_sim_pred _pred(
    .pc        (pc),
    .pht_rdata (pht_rdata),
    .ghr_rdata (ghr_rdata),
    .taken     (taken),
    .pht_raddr (pht_raddr)
);

BBGSharePredictorImp_BSD_sim_train _train(
    .train_pc        (train_pc),
    .train_taken     (train_taken),
    .train_ghr_rdata (train_ghr_rdata),
    .pht_wdata       (pht_wdata),
    .pht_waddr       (pht_waddr),
    .ghr_wdata       (ghr_wdata)
);
endmodule
module BBGSharePredictorImp_BSD_sim_pred(
    input [31:0] pc,
    input [1:0] pht_rdata,
    input [15:0] ghr_rdata,
    output  taken,
    output [8:0] pht_raddr
);
wire [49:0] io_x;
wire [9:0] io_y;
assign io_x = { pc, pht_rdata, ghr_rdata };
assign { taken, pht_raddr } = io_y;
wire  _GEN0 = 1'b0;
wire  _GEN1 = 1'b1;
wire  _GEN2 = io_x[17] ? _GEN1 : _GEN0;
assign io_y[9] = _GEN2;
wire  _GEN3 = 1'b0;
wire  _GEN4 = 1'b1;
wire  _GEN5 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN6 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN7 = io_x[7] ? _GEN6 : _GEN5;
wire  _GEN8 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN9 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN10 = io_x[7] ? _GEN9 : _GEN8;
wire  _GEN11 = io_x[3] ? _GEN10 : _GEN7;
wire  _GEN12 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN13 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN14 = io_x[7] ? _GEN13 : _GEN12;
wire  _GEN15 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN16 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN17 = io_x[7] ? _GEN16 : _GEN15;
wire  _GEN18 = io_x[3] ? _GEN17 : _GEN14;
wire  _GEN19 = io_x[15] ? _GEN18 : _GEN11;
wire  _GEN20 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN21 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN22 = io_x[7] ? _GEN21 : _GEN20;
wire  _GEN23 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN24 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN25 = io_x[7] ? _GEN24 : _GEN23;
wire  _GEN26 = io_x[3] ? _GEN25 : _GEN22;
wire  _GEN27 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN28 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN29 = io_x[7] ? _GEN28 : _GEN27;
wire  _GEN30 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN31 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN32 = io_x[7] ? _GEN31 : _GEN30;
wire  _GEN33 = io_x[3] ? _GEN32 : _GEN29;
wire  _GEN34 = io_x[15] ? _GEN33 : _GEN26;
wire  _GEN35 = io_x[28] ? _GEN34 : _GEN19;
assign io_y[8] = _GEN35;
wire  _GEN36 = 1'b0;
wire  _GEN37 = 1'b1;
wire  _GEN38 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN39 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN40 = io_x[2] ? _GEN39 : _GEN38;
wire  _GEN41 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN42 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN43 = io_x[2] ? _GEN42 : _GEN41;
wire  _GEN44 = io_x[14] ? _GEN43 : _GEN40;
wire  _GEN45 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN46 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN47 = io_x[2] ? _GEN46 : _GEN45;
wire  _GEN48 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN49 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN50 = io_x[2] ? _GEN49 : _GEN48;
wire  _GEN51 = io_x[14] ? _GEN50 : _GEN47;
wire  _GEN52 = io_x[10] ? _GEN51 : _GEN44;
wire  _GEN53 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN54 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN55 = io_x[2] ? _GEN54 : _GEN53;
wire  _GEN56 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN57 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN58 = io_x[2] ? _GEN57 : _GEN56;
wire  _GEN59 = io_x[14] ? _GEN58 : _GEN55;
wire  _GEN60 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN61 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN62 = io_x[2] ? _GEN61 : _GEN60;
wire  _GEN63 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN64 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN65 = io_x[2] ? _GEN64 : _GEN63;
wire  _GEN66 = io_x[14] ? _GEN65 : _GEN62;
wire  _GEN67 = io_x[10] ? _GEN66 : _GEN59;
wire  _GEN68 = io_x[27] ? _GEN67 : _GEN52;
assign io_y[7] = _GEN68;
wire  _GEN69 = 1'b0;
wire  _GEN70 = 1'b1;
wire  _GEN71 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN72 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN73 = io_x[13] ? _GEN72 : _GEN71;
wire  _GEN74 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN75 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN76 = io_x[13] ? _GEN75 : _GEN74;
wire  _GEN77 = io_x[1] ? _GEN76 : _GEN73;
wire  _GEN78 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN79 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN80 = io_x[13] ? _GEN79 : _GEN78;
wire  _GEN81 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN82 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN83 = io_x[13] ? _GEN82 : _GEN81;
wire  _GEN84 = io_x[1] ? _GEN83 : _GEN80;
wire  _GEN85 = io_x[5] ? _GEN84 : _GEN77;
wire  _GEN86 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN87 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN88 = io_x[13] ? _GEN87 : _GEN86;
wire  _GEN89 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN90 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN91 = io_x[13] ? _GEN90 : _GEN89;
wire  _GEN92 = io_x[1] ? _GEN91 : _GEN88;
wire  _GEN93 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN94 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN95 = io_x[13] ? _GEN94 : _GEN93;
wire  _GEN96 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN97 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN98 = io_x[13] ? _GEN97 : _GEN96;
wire  _GEN99 = io_x[1] ? _GEN98 : _GEN95;
wire  _GEN100 = io_x[5] ? _GEN99 : _GEN92;
wire  _GEN101 = io_x[26] ? _GEN100 : _GEN85;
assign io_y[6] = _GEN101;
wire  _GEN102 = 1'b0;
wire  _GEN103 = 1'b1;
wire  _GEN104 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN105 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN106 = io_x[12] ? _GEN105 : _GEN104;
wire  _GEN107 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN108 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN109 = io_x[12] ? _GEN108 : _GEN107;
wire  _GEN110 = io_x[0] ? _GEN109 : _GEN106;
wire  _GEN111 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN112 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN113 = io_x[12] ? _GEN112 : _GEN111;
wire  _GEN114 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN115 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN116 = io_x[12] ? _GEN115 : _GEN114;
wire  _GEN117 = io_x[0] ? _GEN116 : _GEN113;
wire  _GEN118 = io_x[4] ? _GEN117 : _GEN110;
wire  _GEN119 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN120 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN121 = io_x[12] ? _GEN120 : _GEN119;
wire  _GEN122 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN123 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN124 = io_x[12] ? _GEN123 : _GEN122;
wire  _GEN125 = io_x[0] ? _GEN124 : _GEN121;
wire  _GEN126 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN127 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN128 = io_x[12] ? _GEN127 : _GEN126;
wire  _GEN129 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN130 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN131 = io_x[12] ? _GEN130 : _GEN129;
wire  _GEN132 = io_x[0] ? _GEN131 : _GEN128;
wire  _GEN133 = io_x[4] ? _GEN132 : _GEN125;
wire  _GEN134 = io_x[25] ? _GEN133 : _GEN118;
assign io_y[5] = _GEN134;
wire  _GEN135 = 1'b0;
wire  _GEN136 = 1'b1;
wire  _GEN137 = io_x[24] ? _GEN136 : _GEN135;
assign io_y[4] = _GEN137;
wire  _GEN138 = 1'b0;
wire  _GEN139 = 1'b1;
wire  _GEN140 = io_x[23] ? _GEN139 : _GEN138;
assign io_y[3] = _GEN140;
wire  _GEN141 = 1'b0;
wire  _GEN142 = 1'b1;
wire  _GEN143 = io_x[22] ? _GEN142 : _GEN141;
assign io_y[2] = _GEN143;
wire  _GEN144 = 1'b0;
wire  _GEN145 = 1'b1;
wire  _GEN146 = io_x[21] ? _GEN145 : _GEN144;
assign io_y[1] = _GEN146;
wire  _GEN147 = 1'b0;
wire  _GEN148 = 1'b1;
wire  _GEN149 = io_x[20] ? _GEN148 : _GEN147;
assign io_y[0] = _GEN149;
endmodule
module BBGSharePredictorImp_BSD_sim_train(
    input [31:0] train_pc,
    input  train_taken,
    input [15:0] train_ghr_rdata,
    output  pht_wdata,
    output [8:0] pht_waddr,
    output  ghr_wdata
);
wire [48:0] io_x;
wire [10:0] io_y;
assign io_x = { train_pc, train_taken, train_ghr_rdata };
assign { pht_wdata, pht_waddr, ghr_wdata } = io_y;
wire  _GEN0 = 1'b0;
wire  _GEN1 = 1'b1;
wire  _GEN2 = io_x[16] ? _GEN1 : _GEN0;
assign io_y[10] = _GEN2;
wire  _GEN3 = 1'b0;
wire  _GEN4 = 1'b1;
wire  _GEN5 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN6 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN7 = io_x[7] ? _GEN6 : _GEN5;
wire  _GEN8 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN9 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN10 = io_x[7] ? _GEN9 : _GEN8;
wire  _GEN11 = io_x[3] ? _GEN10 : _GEN7;
wire  _GEN12 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN13 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN14 = io_x[7] ? _GEN13 : _GEN12;
wire  _GEN15 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN16 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN17 = io_x[7] ? _GEN16 : _GEN15;
wire  _GEN18 = io_x[3] ? _GEN17 : _GEN14;
wire  _GEN19 = io_x[15] ? _GEN18 : _GEN11;
wire  _GEN20 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN21 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN22 = io_x[7] ? _GEN21 : _GEN20;
wire  _GEN23 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN24 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN25 = io_x[7] ? _GEN24 : _GEN23;
wire  _GEN26 = io_x[3] ? _GEN25 : _GEN22;
wire  _GEN27 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN28 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN29 = io_x[7] ? _GEN28 : _GEN27;
wire  _GEN30 = io_x[11] ? _GEN3 : _GEN4;
wire  _GEN31 = io_x[11] ? _GEN4 : _GEN3;
wire  _GEN32 = io_x[7] ? _GEN31 : _GEN30;
wire  _GEN33 = io_x[3] ? _GEN32 : _GEN29;
wire  _GEN34 = io_x[15] ? _GEN33 : _GEN26;
wire  _GEN35 = io_x[27] ? _GEN34 : _GEN19;
assign io_y[9] = _GEN35;
wire  _GEN36 = 1'b0;
wire  _GEN37 = 1'b1;
wire  _GEN38 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN39 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN40 = io_x[2] ? _GEN39 : _GEN38;
wire  _GEN41 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN42 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN43 = io_x[2] ? _GEN42 : _GEN41;
wire  _GEN44 = io_x[14] ? _GEN43 : _GEN40;
wire  _GEN45 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN46 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN47 = io_x[2] ? _GEN46 : _GEN45;
wire  _GEN48 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN49 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN50 = io_x[2] ? _GEN49 : _GEN48;
wire  _GEN51 = io_x[14] ? _GEN50 : _GEN47;
wire  _GEN52 = io_x[10] ? _GEN51 : _GEN44;
wire  _GEN53 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN54 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN55 = io_x[2] ? _GEN54 : _GEN53;
wire  _GEN56 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN57 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN58 = io_x[2] ? _GEN57 : _GEN56;
wire  _GEN59 = io_x[14] ? _GEN58 : _GEN55;
wire  _GEN60 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN61 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN62 = io_x[2] ? _GEN61 : _GEN60;
wire  _GEN63 = io_x[6] ? _GEN36 : _GEN37;
wire  _GEN64 = io_x[6] ? _GEN37 : _GEN36;
wire  _GEN65 = io_x[2] ? _GEN64 : _GEN63;
wire  _GEN66 = io_x[14] ? _GEN65 : _GEN62;
wire  _GEN67 = io_x[10] ? _GEN66 : _GEN59;
wire  _GEN68 = io_x[26] ? _GEN67 : _GEN52;
assign io_y[8] = _GEN68;
wire  _GEN69 = 1'b0;
wire  _GEN70 = 1'b1;
wire  _GEN71 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN72 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN73 = io_x[13] ? _GEN72 : _GEN71;
wire  _GEN74 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN75 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN76 = io_x[13] ? _GEN75 : _GEN74;
wire  _GEN77 = io_x[1] ? _GEN76 : _GEN73;
wire  _GEN78 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN79 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN80 = io_x[13] ? _GEN79 : _GEN78;
wire  _GEN81 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN82 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN83 = io_x[13] ? _GEN82 : _GEN81;
wire  _GEN84 = io_x[1] ? _GEN83 : _GEN80;
wire  _GEN85 = io_x[5] ? _GEN84 : _GEN77;
wire  _GEN86 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN87 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN88 = io_x[13] ? _GEN87 : _GEN86;
wire  _GEN89 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN90 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN91 = io_x[13] ? _GEN90 : _GEN89;
wire  _GEN92 = io_x[1] ? _GEN91 : _GEN88;
wire  _GEN93 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN94 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN95 = io_x[13] ? _GEN94 : _GEN93;
wire  _GEN96 = io_x[9] ? _GEN69 : _GEN70;
wire  _GEN97 = io_x[9] ? _GEN70 : _GEN69;
wire  _GEN98 = io_x[13] ? _GEN97 : _GEN96;
wire  _GEN99 = io_x[1] ? _GEN98 : _GEN95;
wire  _GEN100 = io_x[5] ? _GEN99 : _GEN92;
wire  _GEN101 = io_x[25] ? _GEN100 : _GEN85;
assign io_y[7] = _GEN101;
wire  _GEN102 = 1'b0;
wire  _GEN103 = 1'b1;
wire  _GEN104 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN105 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN106 = io_x[12] ? _GEN105 : _GEN104;
wire  _GEN107 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN108 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN109 = io_x[12] ? _GEN108 : _GEN107;
wire  _GEN110 = io_x[0] ? _GEN109 : _GEN106;
wire  _GEN111 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN112 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN113 = io_x[12] ? _GEN112 : _GEN111;
wire  _GEN114 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN115 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN116 = io_x[12] ? _GEN115 : _GEN114;
wire  _GEN117 = io_x[0] ? _GEN116 : _GEN113;
wire  _GEN118 = io_x[4] ? _GEN117 : _GEN110;
wire  _GEN119 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN120 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN121 = io_x[12] ? _GEN120 : _GEN119;
wire  _GEN122 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN123 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN124 = io_x[12] ? _GEN123 : _GEN122;
wire  _GEN125 = io_x[0] ? _GEN124 : _GEN121;
wire  _GEN126 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN127 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN128 = io_x[12] ? _GEN127 : _GEN126;
wire  _GEN129 = io_x[8] ? _GEN102 : _GEN103;
wire  _GEN130 = io_x[8] ? _GEN103 : _GEN102;
wire  _GEN131 = io_x[12] ? _GEN130 : _GEN129;
wire  _GEN132 = io_x[0] ? _GEN131 : _GEN128;
wire  _GEN133 = io_x[4] ? _GEN132 : _GEN125;
wire  _GEN134 = io_x[24] ? _GEN133 : _GEN118;
assign io_y[6] = _GEN134;
wire  _GEN135 = 1'b0;
wire  _GEN136 = 1'b1;
wire  _GEN137 = io_x[23] ? _GEN136 : _GEN135;
assign io_y[5] = _GEN137;
wire  _GEN138 = 1'b0;
wire  _GEN139 = 1'b1;
wire  _GEN140 = io_x[22] ? _GEN139 : _GEN138;
assign io_y[4] = _GEN140;
wire  _GEN141 = 1'b0;
wire  _GEN142 = 1'b1;
wire  _GEN143 = io_x[21] ? _GEN142 : _GEN141;
assign io_y[3] = _GEN143;
wire  _GEN144 = 1'b0;
wire  _GEN145 = 1'b1;
wire  _GEN146 = io_x[20] ? _GEN145 : _GEN144;
assign io_y[2] = _GEN146;
wire  _GEN147 = 1'b0;
wire  _GEN148 = 1'b1;
wire  _GEN149 = io_x[19] ? _GEN148 : _GEN147;
assign io_y[1] = _GEN149;
wire  _GEN150 = 1'b0;
wire  _GEN151 = 1'b1;
wire  _GEN152 = io_x[16] ? _GEN151 : _GEN150;
assign io_y[0] = _GEN152;
endmodule
