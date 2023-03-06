module SYS_CTRL_Tx
(
	input   wire   [15:0]  ALU_OUT      ,
	input   wire           OUT_Valid    ,

	input   wire   [7:0]   RdData       ,
	input   wire           RdData_Valid ,

	input   wire           Busy         ,

	input   wire           CLK          ,
	input   wire           RST          ,


    output  reg    [7:0]   TX_P_DATA    ,
    output  reg            TX_D_VLD     ,

    output  reg            clk_div_en
);

//using Gray State Encoding for each successive states (Adv: Low Power / DisAdv: Complex Logic).
localparam IDLE     = 3'b 000 ;

localparam RD_DATA  = 3'b 001 ;

localparam ALU_B1   = 3'b 010 ;   
localparam ALU_WAIT = 3'b 011 ;		//Wait During Busy (Transmitting Frame 1)
localparam ALU_B2   = 3'b 111 ;		//ALU Output's width is 16 bit (2 Frames)


reg [2:0] current_state , next_state ;
reg [7:0] TX_P_DATA_reg ;


always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		current_state <= IDLE ;
		TX_P_DATA_reg <= 8'b0 ;
	end
	else begin
		current_state <= next_state ;
		TX_P_DATA_reg <= TX_P_DATA  ;	//registering P_DATA to avoid combinational loop during "Busy"
	end
end

always @(*) begin
	case(current_state)
		IDLE: begin
			TX_P_DATA  = TX_P_DATA_reg ;
			TX_D_VLD   = 1'b0          ;
			clk_div_en = 1'b1          ; 

			case({OUT_Valid , RdData_Valid})
				2'b 00: begin
					next_state = IDLE ;
				end 
				2'b 01: begin
					if (Busy) begin
						next_state = IDLE    ;
					end
					else begin
						next_state = RD_DATA ;
					end
				end
				2'b 10: begin
					if (Busy) begin
						next_state = IDLE   ;
					end
					else begin
						next_state = ALU_B1 ;
					end
				end
				default: begin
					next_state = IDLE ;
				end
			endcase				
		end
   
		RD_DATA: begin 
			TX_P_DATA  = RdData ;
			TX_D_VLD   = 1'b1   ;
			clk_div_en = 1'b1   ; 

			if (!Busy) begin
				next_state = RD_DATA ;
			end
			else begin
				next_state = IDLE    ;	
			end	
		end

		ALU_B1: begin
			TX_P_DATA  = ALU_OUT[7:0] ;
			TX_D_VLD   = 1'b1         ;
			clk_div_en = 1'b1         ; 

			if (!Busy) begin
				next_state = ALU_B1   ;
			end
			else begin
				next_state = ALU_WAIT ;	
			end					
		end

		ALU_WAIT: begin
			TX_P_DATA  = TX_P_DATA_reg;
			TX_D_VLD   = 1'b0         ;
			clk_div_en = 1'b1         ; 

			if (Busy) begin
				next_state = ALU_WAIT ;
			end
			else begin
				next_state = ALU_B2   ;	
			end					
		end

		ALU_B2: begin
			TX_P_DATA  = ALU_OUT[15:8] ;
			TX_D_VLD   = 1'b1          ;
			clk_div_en = 1'b1          ; 
			
			if (!Busy) begin
				next_state = ALU_B2 ;
			end
			else begin
				case({OUT_Valid , RdData_Valid})
					2'b 00: begin
						next_state = IDLE    ;
					end 
					2'b 01: begin
						next_state = RD_DATA ;
					end
					2'b 10: begin
						next_state = ALU_B1  ;
					end
					default: begin
						next_state = IDLE    ;
					end
				endcase
			end			
		end

		default: begin
			TX_P_DATA  = 8'b0 ;
			TX_D_VLD   = 1'b0 ;
			clk_div_en = 4'b0 ;

			next_state = IDLE ;			
		end
	endcase
end

endmodule