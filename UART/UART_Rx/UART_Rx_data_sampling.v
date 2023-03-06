module UART_Rx_data_sampling 
(
	input   wire       RX_IN       ,
	input   wire [4:0] Prescale    ,
	input   wire       dat_samp_en ,
	input   wire [4:0] edge_cnt    ,
	input   wire       CLK         ,
	input   wire       RST         ,

	output  wire       sampled_bit
);

reg first_sample  ;
reg second_sample ;
reg third_sample  ;

wire [2:0] samples ;
assign samples = {first_sample , second_sample , third_sample} ;

assign sampled_bit = ((~^samples & |samples)  |  &samples) ;       //an algorithm extracted from functionality truth table



always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		first_sample  <= 1'd0 ;
		second_sample <= 1'd0 ;
		third_sample  <= 1'd0 ;
	end
	else if (dat_samp_en) begin
		if (edge_cnt == (Prescale>>1) - 2) begin
			first_sample  <= RX_IN ;
			second_sample <= second_sample ;
			third_sample  <= third_sample  ;
		end
		else if (edge_cnt == (Prescale>>1) - 1) begin
		    first_sample  <= first_sample ;
			second_sample <= RX_IN ;
			third_sample  <= third_sample ;
		end
		else if (edge_cnt == (Prescale>>1)) begin
		    first_sample  <= first_sample  ;
		    second_sample <= second_sample ;
			third_sample  <= RX_IN ;
		end
		else begin
			first_sample  <= first_sample  ;
		    second_sample <= second_sample ;
			third_sample  <= third_sample  ;
		end
	end
	else begin
		first_sample  <= first_sample  ;
		second_sample <= second_sample ;
		third_sample  <= third_sample  ;		
	end
end
endmodule