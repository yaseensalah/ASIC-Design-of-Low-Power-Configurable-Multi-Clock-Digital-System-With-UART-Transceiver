module UART_Tx_FSM 
(
	input   wire        Data_Valid ,
	input   wire        PAR_EN     ,
	input   wire        ser_done   ,
	input   wire        CLK        ,
	input   wire        RST        ,

	output  reg         ser_en     ,
	output  reg   [1:0] mux_sel    ,
	output  reg         busy      
);

//using Gray State Encoding because of the sequential transitions between states.
localparam IDLE  = 3'b000 ;
localparam START = 3'b001 ;
localparam DATA  = 3'b011 ; 
localparam PAR   = 3'b010 ;
localparam STOP  = 3'b110 ;

reg [2:0] current_state , next_state ;
reg busy_comp ;

/*------------------- State Transition and Registering Logic-------------------*/
always @(posedge CLK or negedge RST)
 begin
 	if (!RST) begin
 		current_state <= IDLE ; 
 		busy          <= 1'd0 ;		
 	end
 	else begin
 		current_state <= next_state ; 	
 		busy          <= busy_comp  ;	 	//registering the busy signal as it is the output of UART_Tx_Top
 	end
 end

/*-------------------------Next State and Output Logic-------------------------*/
always @(*) begin 		
    case (current_state)
 		IDLE : begin
 			ser_en  = 1'd0 ;
 			mux_sel = 2'd1 ;          //selecting Stop_bit (Tx_OUT = High)
 			busy_comp    = 1'd0 ;
 			if (Data_Valid) begin
 				next_state = START ;
 			end
 			else begin
 				next_state = IDLE  ;
 			end
 		end
 		START: begin
 			ser_en     = 1'd1 ;     //initializing the Serializer for the next state (next clock cycle)
 			mux_sel    = 2'd0 ;
 			busy_comp  = 1'd1 ;
 			next_state = DATA ;		
 		end
 		DATA : begin 			 
 			mux_sel   = 2'd2 ;
 			busy_comp = 1'd1 ;
 			if (ser_done) begin
 			    ser_en  = 1'd0 ;        //stopping the counter in Serializer whenever the serializing is done
 			    if (PAR_EN) begin
 			    	next_state = PAR  ;
 			    end
 			    else begin
 			    	next_state = STOP ;
 			    end
 			end
 			else begin
 			    ser_en     = 1'd1 ;
 				next_state = DATA  ;
 			end
 		end
 		PAR  : begin
 			ser_en     = 1'd0 ;   
 			mux_sel    = 2'd3 ;
 			busy_comp  = 1'd1 ;
 			next_state = STOP ;	
 		end
 		STOP : begin
 			ser_en    = 1'd0 ;  
 			mux_sel   = 2'd1 ;
 			busy_comp = 1'd1 ;
 			if (Data_Valid) begin
 				next_state = START   ;
 			end
 			else begin
 				next_state = IDLE  ;
 			end
 		end

 		default : begin
 		ser_en     = 1'd0 ;
 		mux_sel    = 2'd1 ;
 		busy_comp  = 1'd0 ;
 		next_state = IDLE ; 	
 		end

 	endcase

end
 endmodule