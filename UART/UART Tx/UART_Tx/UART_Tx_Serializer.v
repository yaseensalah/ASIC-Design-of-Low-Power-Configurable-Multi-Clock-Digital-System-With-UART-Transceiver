module UART_Tx_Serializer 
(
	input   wire [7:0] P_DATA   ,
	input   wire       ser_en   ,
	input   wire       CLK      ,
	input   wire       RST      ,

	output  reg        ser_data ,
	output  reg        ser_done
);

reg [2:0] counter ;

always @(posedge CLK or negedge RST)
 begin
 	if (!RST) begin
 		counter  <= 3'd0 ;
 		ser_data <= 1'd0 ;
 		ser_done <= 1'd0 ;
 	end
 	else if (ser_en == 1'd1) begin
 		if (counter != 3'd7) begin
 			counter  <= counter + 3'd1  ;
 			ser_data <= P_DATA[counter] ;
 			ser_done <= 1'd0            ;
  		end
  		else begin
  			counter  <= 3'd0      ;
  			ser_data <= P_DATA[7] ;
  			ser_done <= 1'd1      ;
  		end
 	end
 	else begin
 		counter  <= 3'd0 ;
 		ser_data <= 1'd0 ;
 		ser_done <= 1'd0 ;
 	end
 end

endmodule