module UART
(
	input   wire [7:0] UART_Config   ,	

	input   wire       RX_IN         ,	

	input   wire [7:0] TX_P_DATA     ,
	input   wire       TX_DATA_VALID ,

	input   wire       RX_CLK        ,
	input   wire       TX_CLK        ,
	input   wire       RST           ,


	output  wire       TX_OUT        ,
	output  wire       Busy          ,

	output  wire [7:0] RX_P_DATA     ,
	output  wire       RX_DATA_VALID ,

	output  wire       parity_error  ,
	output  wire       framing_error 
);

UART_Tx_Top TX (
	.P_DATA     (TX_P_DATA)      ,
	.DATA_VALID (TX_DATA_VALID)  ,
	.PAR_EN     (UART_Config[0]) ,
	.PAR_TYP    (UART_Config[1]) ,
	.CLK        (TX_CLK)         ,
	.RST        (RST)            ,

	.TX_OUT     (TX_OUT)         ,
	.Busy       (Busy)
);
UART_Rx_Top RX (
	.RX_IN         (RX_IN)            ,
	.Prescale      (UART_Config[6:2]) ,
	.PAR_EN        (UART_Config[0])   ,
	.PAR_TYP       (UART_Config[1])   ,
	.CLK           (RX_CLK)           ,
	.RST           (RST)              ,

	.P_DATA        (RX_P_DATA)        ,
	.data_valid    (RX_DATA_VALID)    ,
	.parity_error  (parity_error)     ,
	.framing_error (framing_error) 
);

endmodule