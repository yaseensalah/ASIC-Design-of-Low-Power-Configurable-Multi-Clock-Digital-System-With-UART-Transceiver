module UART_Tx_MUX 
(
	input   wire  [1:0]  mux_sel  ,
	input   wire         ser_data ,
	input   wire         par_bit  ,
    input   wire         CLK      ,
    
	output  reg          TX_OUT
);

always @(posedge CLK) begin
	case (mux_sel)
	2'b00: TX_OUT <= 1'd0     ;    //START bit
	2'b01: TX_OUT <= 1'd1     ;    //STOP  bit
	2'b10: TX_OUT <= ser_data ;
	2'b11: TX_OUT <= par_bit  ;

	default: TX_OUT <= 1'd1 ;      //IDLE case
	endcase
end
endmodule