module UART_Rx_strt_check
(
	input   wire   strt_chk_en  ,
	input   wire   sampled_bit  ,

	output  wire   strt_glitch
);


assign strt_glitch = (strt_chk_en && sampled_bit)? 1'd1 : 1'd0 ;    //START bit must be 0 for no glitching
endmodule