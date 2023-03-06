module UART_Rx_deserializer
(
	input   wire       deser_en    ,
	input   wire       sampled_bit ,
	input   wire [3:0] bit_cnt     ,
	input   wire       CLK         ,
	input   wire       RST         ,
    
	output  reg  [7:0] P_DATA 
);


always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		P_DATA  <= 8'd0 ;
	end
	else if (deser_en) begin
		P_DATA[bit_cnt-1] <= sampled_bit ;
	end
	else begin
		P_DATA  <= P_DATA  ;
	end
end

endmodule