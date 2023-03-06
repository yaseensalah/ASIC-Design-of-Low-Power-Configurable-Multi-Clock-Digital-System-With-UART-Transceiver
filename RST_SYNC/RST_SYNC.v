module RST_SYNC #(parameter NUM_STAGES = 2)         //Default Design is Douple-Flop Reset Synchronizer

(
	input   wire  CLK      ,
	input   wire  RST      ,

	output  wire  SYNC_RST
);


wire [NUM_STAGES-2  : 0] internal  ;                //"internal" bus of each flop output in the stages

generate
	D_FF U0 (                                       //First Stage of Flop Synchronizer
			 .D   (1'b1)        , 
			 .CLK (CLK)         , 
			 .RST (RST)         , 
			 .Q   (internal[0]) 
			);

	genvar j;		
	for (j = 0 ; j < NUM_STAGES-1 ; j = j + 1)
	begin: Multi_Flop_Synchronization
		if (j < NUM_STAGES-2) begin: Multi_Flop_Synchronization
		D_FF Uj (                                   //Middle Stages of Flop Synchronizer
				 .D   (internal[j])   , 
				 .CLK (CLK)           , 
				 .RST (RST)           , 
				 .Q   (internal[j+1]) 
				);
		end
		else begin: Multi_Flop_Synchronization
		D_FF UN (                                   //Last Stage of Flop Synchronizer
				 .D   (internal[j])  , 
				 .CLK (CLK)          , 
				 .RST (RST)          , 
				 .Q   (SYNC_RST) 
				);				
		end
	end
	
endgenerate

endmodule
