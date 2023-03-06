module Pulse_Gen
(
	input   wire  Pulse_Gen_input  ,
	input   wire  CLK              ,
	input   wire  RST              ,

	output  wire  Pulse_Gen_output 
);


wire internal ;

D_FF U0 (                         
		 .D   (Pulse_Gen_input) , 
		 .CLK (CLK)             , 
		 .RST (RST)             , 
         .Q   (internal) 
		);

assign Pulse_Gen_output = (Pulse_Gen_input & ~internal) ;

endmodule