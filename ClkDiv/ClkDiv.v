module ClkDiv
#(parameter RARIO_SIZE = 4)
(
 	input    wire                    i_ref_clk    ,
 	input    wire                    i_rst_n      ,
 	input    wire                    i_clk_en     ,
 	input    wire  [RARIO_SIZE-1:0]  i_div_ratio  ,

	output   wire                    o_div_clk
);

reg [RARIO_SIZE-1:0] counter  ;
reg                  odd_flag ;
reg                  new_clk  ;
wire                 clk_en   ;

assign clk_en = (i_clk_en == 1'b1  &&  i_div_ratio != 1'b1  &&  i_div_ratio != 1'b0 )? 1'b1 : 1'b0 ;
assign o_div_clk = (clk_en == 1'b1)? new_clk : i_ref_clk ;

always @(posedge i_ref_clk or negedge i_rst_n)
begin
	if (! i_rst_n) begin
		new_clk <= 0 ;
		counter <= 0 ;
		odd_flag <= 0 ;
	end	
	else if (clk_en != 1) begin
		new_clk <= new_clk ;
		counter <= 0 ;
	end
	else if (i_div_ratio[0] == 0 && counter == (i_div_ratio>>1)-1) begin
		new_clk <= ~new_clk ;
		counter <= 0 ;
	end
	else if ((i_div_ratio[0] == 1 && counter == (i_div_ratio>>1)-1 && odd_flag != 1)  ||  (i_div_ratio[0] == 1 && counter == (i_div_ratio>>1) && odd_flag == 1)) begin
		new_clk <= ~new_clk ;
		counter <= 0 ;
		odd_flag <= ~odd_flag ;
	end
	else begin
		counter <= counter + 1 ;
	end
end

endmodule