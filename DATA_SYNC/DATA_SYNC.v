module DATA_SYNC #(parameter BUS_WIDTH = 8 , parameter NUM_STAGES = 2)      //Default Design is Douple-Flop Bit Synchronizer

(
	input   wire  [BUS_WIDTH-1 : 0] Unsync_bus   ,
	input   wire                    bus_enable   ,	
	input   wire                    dest_clk     ,
	input   wire                    dest_rst     ,

	output  reg   [BUS_WIDTH-1 : 0] sync_bus     ,
	output  reg                     enable_pulse
);


wire Pulse_Gen_input  ;
wire Pulse_Gen_output ;

BIT_SYNC #(.BUS_WIDTH(1) , .NUM_STAGES(NUM_STAGES)) B1 (
	                                                     .ASYNC (bus_enable)      ,
	                                                     .CLK   (dest_clk)        ,
	                                                     .RST   (dest_rst)        ,
	                                                     .SYNC  (Pulse_Gen_input)
	                                                    );

Pulse_Gen B2 (
	          .Pulse_Gen_input  (Pulse_Gen_input)  ,
	          .CLK              (dest_clk)         ,
	          .RST              (dest_rst)         ,
	          .Pulse_Gen_output (Pulse_Gen_output)
	         );


always @(posedge dest_clk or negedge dest_rst) begin
	if (!dest_rst) begin
		sync_bus <= 0 ;		
	end
	else if (Pulse_Gen_output) begin
		sync_bus <= Unsync_bus ;
	end
	else begin
		sync_bus <= sync_bus ;
	end
end


always @(posedge dest_clk or negedge dest_rst) begin
	if (!dest_rst) begin
		enable_pulse <= 0 ;
		
	end
	else begin
		enable_pulse <= Pulse_Gen_output ;
	end
end

endmodule