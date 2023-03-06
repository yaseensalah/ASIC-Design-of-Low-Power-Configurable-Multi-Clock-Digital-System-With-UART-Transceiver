module UART_Tx_ParityCalc 
(
	input   wire [7:0] P_DATA     ,
	input   wire       Data_Valid ,
	input   wire       PAR_EN     ,  //specs modifying to reduce power consumption when no need for parity bit
	input   wire       PAR_TYP    ,  //0: Even parity bit      //1: Odd parity bit
	input   wire       CLK        ,
	input   wire       RST        ,

	output  reg        par_bit 
);

always @(posedge CLK or negedge RST) begin
    if (!RST) begin
    	par_bit <= 1'd0 ;
    end
	else if (Data_Valid && PAR_EN) begin
		if ((PAR_TYP && ~^P_DATA) || (~PAR_TYP && ^P_DATA)) begin
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