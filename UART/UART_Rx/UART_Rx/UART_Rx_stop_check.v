module UART_Rx_stop_check
(
	input   wire   stp_chk_en  ,
	input   wire   sampled_bit ,
	input   wire   CLK         ,
	input   wire   RST         ,

	output  reg   stp_err
);

always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		stp_err <= 1'd0 ;
	end
	else if (stp_chk_en) begin   //STOP bit must be 1 for no errors
	    if (~sampled_bit) begin
			stp_err <= 1'd1 ;	    	
	    end
	    else begin
	    	stp_err <= 1'd0 ;
	    end
	end
	else begin
		stp_err <= stp_err ;
	end
end

 
endmodule