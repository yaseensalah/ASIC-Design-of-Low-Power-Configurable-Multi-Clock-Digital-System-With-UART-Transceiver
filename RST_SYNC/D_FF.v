module D_FF 
(
	input   wire   D   ,
	input   wire   CLK ,
	input   wire   RST ,
	output  reg    Q 
);

always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		Q <= 0 ;
		
	end
	else begin
		Q <= D ;
	end
end

endmodule
