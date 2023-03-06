module SYS_CTRL
(
	input   wire   [15:0]  ALU_OUT      ,
	input   wire           OUT_Valid    ,

	input   wire   [7:0]   RdData       ,
	input   wire           RdData_Valid ,

	input   wire   [7:0]   RX_P_DATA    ,
	input   wire           RX_D_VLD     ,

	input   wire           Busy         ,

	input   wire           CLK          ,
	input   wire           RST          ,

    
    output  wire           ALU_EN       ,
    output  wire   [3:0]   ALU_FUN      ,
    output  wire           CLK_EN       ,

    output  wire   [3:0]   Address      ,
    output  wire           RdEn         ,
    output  wire           WrEn         ,
    output  wire   [7:0]   WrData       ,

    output  wire   [7:0]   TX_P_DATA    ,
    output  wire           TX_D_VLD     ,

    output  wire           clk_div_en
);


SYS_CTRL_Tx TX_CTRL (
	.ALU_OUT      (ALU_OUT)      ,
	.OUT_Valid    (OUT_Valid)    ,
	.RdData       (RdData)       ,
	.RdData_Valid (RdData_Valid) ,
	.Busy         (Busy)         ,
	.CLK          (CLK)          ,
	.RST          (RST)          ,

	.TX_P_DATA    (TX_P_DATA)    ,
	.TX_D_VLD     (TX_D_VLD)     ,
	.clk_div_en   (clk_div_en)
);


SYS_CTRL_Rx RX_CTRL (
	.RX_P_DATA  (RX_P_DATA) ,
	.RX_D_VLD   (RX_D_VLD)  ,
	.CLK        (CLK)    ,
	.RST        (RST)       ,

	.ALU_EN     (ALU_EN)    ,
	.ALU_FUN    (ALU_FUN)   ,
	.CLK_EN_reg (CLK_EN)    ,
	.Address    (Address)   ,
	.RdEn       (RdEn)      ,
	.WrEn       (WrEn)      ,
	.WrData     (WrData)
);


endmodule