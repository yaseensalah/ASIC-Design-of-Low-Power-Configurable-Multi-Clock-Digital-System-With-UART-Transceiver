module UART_Tx_Top 
(
	input   wire [7:0] P_DATA     ,
	input   wire       DATA_VALID ,
	input   wire       PAR_EN     ,
	input   wire       PAR_TYP    ,
	input   wire       CLK        ,
	input   wire       RST        ,

	output  wire       TX_OUT     ,
	output  wire       Busy
);

wire       ser_done ;
wire       ser_en   ;
wire [1:0] mux_sel  ;
wire       ser_data ;
wire       par_bit  ;

UART_Tx_FSM U0 (
	.Data_Valid (DATA_VALID) ,
	.PAR_EN     (PAR_EN)     ,
	.ser_done   (ser_done)   ,
	.CLK        (CLK)        ,
	.RST        (RST)        ,

	.ser_en     (ser_en)     ,
	.mux_sel    (mux_sel)    ,
	.busy       (Busy)    
);

UART_Tx_Serializer U1 (
	.P_DATA   (P_DATA)   ,
	.ser_en   (ser_en)   ,
	.CLK      (CLK)      ,
	.RST      (RST)      ,

	.ser_data (ser_data) ,
	.ser_done (ser_done)
);

UART_Tx_ParityCalc U2 (
	.P_DATA     (P_DATA)     ,
	.Data_Valid (DATA_VALID) ,
	.PAR_EN     (PAR_EN)     ,
	.PAR_TYP    (PAR_TYP)    ,
	.CLK        (CLK)        ,
	.RST        (RST)        ,

	.par_bit    (par_bit)
);

UART_Tx_MUX U3 (
	.mux_sel  (mux_sel)  ,
	.ser_data (ser_data) ,
	.par_bit  (par_bit)  , 
	.CLK      (CLK)      ,
	.TX_OUT   (TX_OUT)
);

endmodule