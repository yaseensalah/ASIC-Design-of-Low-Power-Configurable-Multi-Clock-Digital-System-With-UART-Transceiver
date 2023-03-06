module UART_Rx_edge_bit_counter
#(parameter PRESCALE = 5'd8)
(
	input  wire      cnt_enable ,
	input  wire      PAR_EN     ,
	input  wire      CLK        ,
	input  wire      RST        ,

	output reg [4:0] edge_cnt   ,   //width of Oversampling Prescale
	output reg [3:0] bit_cnt        //maximum number of received bits is 11 (represented in 4 bits)
);

always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		edge_cnt <= 5'd0 ;
		bit_cnt  <= 4'd0 ;
	end
	else if (cnt_enable) begin
		if (edge_cnt < (PRESCALE-1)) begin
			edge_cnt <= edge_cnt + 5'd1 ;
		end
		else begin
			edge_cnt <= 5'd0 ;
			if (PAR_EN) begin
				if (bit_cnt < 4'd10) begin
                    bit_cnt <= bit_cnt + 4'd1 ;
				end
				else begin
					bit_cnt <= 4'd0 ;
				end
			end
			else begin
				if (bit_cnt < 4'd9) begin
                    bit_cnt <= bit_cnt + 4'd1 ;
				end
				else begin
					bit_cnt <= 4'd0 ;
				end						
			end	
	    end
	end 
	else begin
		edge_cnt <= 5'd0 ;
		bit_cnt  <= 4'd0 ;		
	end
end

endmodule