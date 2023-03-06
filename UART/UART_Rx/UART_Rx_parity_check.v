module UART_Rx_parity_check
(
	input   wire  	   PAR_TYP     ,
	input   wire       par_chk_en  ,
	input   wire       sampled_bit ,
	input   wire [3:0] bit_cnt     ,
	input   wire [4:0] edge_cnt    ,
	input   wire [4:0] Prescale    ,
	input   wire       CLK         ,
	input   wire   	   RST         ,

	output  reg        par_err
);

reg [7:0] data ;
reg       par_bit ;

always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		data    <= 8'd0 ;
		par_err <= 1'd0 ;
	end
	else if (par_chk_en) begin
		if (bit_cnt < 5'd9) begin
		    data[bit_cnt-1] <= sampled_bit ;
		    par_err <= 1'd0 ;
		end
		else if (edge_cnt == (Prescale>>1) + 1) begin
	        data <= data ;
			if (par_bit == sampled_bit) begin
				par_err <= 1'd0 ;
			end
			else begin
				par_err <= 1'd1 ;
			end
		end	
		else begin
		        data    <= data    ;
				par_err <= par_err ;
			end	
	end
	else begin
		data    <= data    ;
		par_err <= par_err ;
	end
end

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
    	par_bit <= 1'd0 ;
    end
	else if (bit_cnt == 4'd8) begin
		if ((PAR_TYP && ~^data) || (~PAR_TYP && ^data)) begin
			par_bit <= 1'd1 ;
		end
		else begin
			par_bit <= 1'd0 ;
		end
	end
	else begin
		par_bit <= par_bit ;
	end
end

endmodule