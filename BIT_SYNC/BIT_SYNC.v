module BIT_SYNC #(parameter BUS_WIDTH = 1 , parameter NUM_STAGES = 2)      //Default Design is Douple-Flop Bit Synchronizer

(
	input   wire  [BUS_WIDTH-1 : 0] ASYNC  ,
	input   wire                    CLK    ,
	input   wire                    RST    ,

	output  wire  [BUS_WIDTH-1 : 0] SYNC
);


wire [BUS_WIDTH-1 : 0]   internal [NUM_STAGES-2  : 0] ;                //Each bit of Data Bus contains "internal" bus of each flop output in the stages

generate
	genvar i;
	for (i = 0 ; i < BUS_WIDTH ; i = i + 1)
	begin: Multiple_Bit_Synchronizers

		D_FF U0 (                                                      //First Stage of Flop Synchronizer
				 .D   (ASYNC[i])       , 
				 .CLK (CLK)            , 
				 .RST (RST)            , 
				 .Q   (internal[0] [i]) 
				);

		genvar j;		
		for (j = 0 ; j < NUM_STAGES-1 ; j = j + 1)
		begin: Multi_Flop_Synchronization
		    if (j < NUM_STAGES-2) begin: Multi_Flop_Synchronization
			D_FF Uj (                                                  //Middle Stages of Flop Synchronizer
				     .D   (internal[j] [i])   , 
				     .CLK (CLK)               , 
				     .RST (RST)               , 
				     .Q   (internal[j+1] [i]) 
				    );
		    end
		    else begin: Multi_Flop_Synchronization
		    D_FF UN (                                                  //Last Stage of Flop Synchronizer
				 .D   (internal[j] [i])  , 
				 .CLK (CLK)              , 
				 .RST (RST)              , 
				 .Q   (SYNC[i]) 
				);				
		    end
		end
	
	end
endgenerate

endmodule