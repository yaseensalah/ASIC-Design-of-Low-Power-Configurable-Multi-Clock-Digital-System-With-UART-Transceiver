module SYS_CTRL_Rx
(
	input   wire   [7:0]   RX_P_DATA    ,
	input   wire           RX_D_VLD     ,

	input   wire           CLK          ,
	input   wire           RST          ,

    
    output  reg            ALU_EN       ,
    output  reg    [3:0]   ALU_FUN      ,
    output  reg            CLK_EN_reg   ,

    output  reg    [3:0]   Address      ,
    output  reg            RdEn         ,
    output  reg            WrEn         ,
    output  reg    [7:0]   WrData       
);

//using Gray State Encoding for each successive states (Adv: Low Power / DisAdv: Complex Logic).
localparam IDLE     = 4'b 0000 ;

localparam WR_ADD   = 4'b 0001 ;
localparam WR_DATA  = 4'b 0011 ;

localparam RD_ADD   = 4'b 0010 ;

localparam ALU_OP_A = 4'b 0110 ;
localparam ALU_OP_B = 4'b 0111 ;
localparam ALU_FUNC = 4'b 1111 ;

localparam ALU_NOP  = 4'b 1000 ;


reg [3:0] current_state , next_state ;
reg [3:0] Addr_reg ;                      
reg       CLK_EN   ;

always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		current_state <= IDLE ;
		Addr_reg      <= 4'b0 ;
		CLK_EN_reg    <= 1'b0 ;
	end
	else begin
		current_state <= next_state ;
		Addr_reg      <= Address    ;         //registering Address to avoid combinational loop @ WR_DATA state
		CLK_EN_reg    <= CLK_EN     ;         //registering CLK_EN to avoid Clock Gating within the ALU_VALID Signal
	end
end

always @(*) begin
	case(current_state)
		IDLE: begin
			ALU_EN  = 1'b0 ;
			ALU_FUN = 4'b0 ;
			Address = 4'h4 ;  //first 4 registers are Reserved
			RdEn    = 1'b0 ;
			WrEn    = 1'b0 ;
			WrData  = 8'b0 ;

			if (!RX_D_VLD) begin
				CLK_EN  = 1'b0 ;

				next_state = IDLE ;
			end
			else begin
				case(RX_P_DATA)
					8'h AA: begin
						CLK_EN  = 1'b0 ;

						next_state = WR_ADD ;
					end  
					8'h BB: begin
						CLK_EN  = 1'b0 ;

						next_state = RD_ADD ;
					end
					8'h CC: begin
						CLK_EN  = 1'b0 ;

						next_state = ALU_OP_A ;
					end
					8'h DD: begin
						CLK_EN  = 1'b0 ;

						next_state = ALU_NOP ;
					end
					default: begin
						CLK_EN  = 1'b0 ;

						next_state = IDLE ;
					end
				endcase
			end
		end
   
		WR_ADD: begin
			ALU_EN  = 1'b0 ;
			ALU_FUN = 4'b0 ;
			CLK_EN  = 1'b0 ;
			RdEn    = 1'b0 ;
			WrEn    = 1'b0 ;
			WrData  = 8'b0 ;	
			if (!RX_D_VLD) begin
				Address = 4'h4 ;

				next_state = WR_ADD ;
			end
			else begin
				Address = RX_P_DATA ;

				next_state = WR_DATA ;	
			end	
		end

		WR_DATA: begin
			ALU_EN  = 1'b0      ;
			ALU_FUN = 4'b0      ;
			CLK_EN  = 1'b0      ;
			Address = Addr_reg  ;
			RdEn    = 1'b0      ;
			WrData  = RX_P_DATA ;	
			if (!RX_D_VLD) begin
			    WrEn = 1'b0 ;

				next_state = WR_DATA ;
			end
			else begin
			    WrEn = 1'b1 ;

				next_state = IDLE ;	
			end					
		end

		RD_ADD: begin
			ALU_EN  = 1'b0 ;
			ALU_FUN = 4'b0 ;
			CLK_EN  = 1'b0 ;
			WrEn    = 1'b0 ;
			WrData  = 8'b0 ;
			if (!RX_D_VLD) begin
				Address = 4'h4 ;
				RdEn    = 1'b0 ;

				next_state = RD_ADD ;
			end
			else begin
				Address = RX_P_DATA ;
				RdEn    = 1'b1      ;

				next_state = IDLE ;	
			end				
		end

		ALU_OP_A: begin
			ALU_EN  = 1'b0 ;
			ALU_FUN = 4'b0 ;
			CLK_EN  = 1'b0 ;
			RdEn    = 1'b0 ;	
			if (!RX_D_VLD) begin
				Address = 4'h4 ;
				WrEn    = 1'b0 ;
				WrData  = 8'b0 ;

				next_state = ALU_OP_A ;
			end
			else begin
				Address = 4'h0      ;  //Reserved Register for Operand A
				WrEn    = 1'b1      ;
				WrData  = RX_P_DATA ;

				next_state = ALU_OP_B ;	
			end						
		end

		ALU_OP_B: begin
			ALU_EN  = 1'b0 ;
			ALU_FUN = 4'b0 ;
			CLK_EN  = 1'b0 ;
			RdEn    = 1'b0 ;	
			if (!RX_D_VLD) begin
				Address = 4'h4 ;
				WrEn    = 1'b0 ;
				WrData  = 8'b0 ;

				next_state = ALU_OP_B ;
			end
			else begin
				Address = 4'h1      ;  //Reserved Register for Operand B
				WrEn    = 1'b1      ;
				WrData  = RX_P_DATA ;

				next_state = ALU_FUNC ;	
			end				
		end

		ALU_FUNC: begin
			CLK_EN  = 1'b1 ;
			Address = 4'h4 ;
			RdEn    = 1'b0 ;
			WrEn    = 1'b0 ;
			WrData  = 8'b0 ;	
			if (!RX_D_VLD) begin
				ALU_EN  = 1'b0 ;
				ALU_FUN = 4'b0 ;

				next_state = ALU_FUNC ;
			end
			else begin
				ALU_EN  = 1'b1      ;
				ALU_FUN = RX_P_DATA ;

				next_state = IDLE ;	
			end				
		end

		ALU_NOP: begin
			CLK_EN  = 1'b1 ;
			Address = 4'h4 ;
			RdEn    = 1'b0 ;
			WrEn    = 1'b0 ;
			WrData  = 8'b0 ;	
			if (!RX_D_VLD) begin
				ALU_EN  = 1'b0 ;
				ALU_FUN = 4'b0 ;

				next_state = ALU_NOP ;
			end
			else begin
				ALU_EN  = 1'b1      ;
				ALU_FUN = RX_P_DATA ;

				next_state = IDLE ;	
			end				
		end

		default: begin
			ALU_EN  = 1'b0 ;
			ALU_FUN = 4'b0 ;
			CLK_EN  = 1'b0 ;
			Address = 4'h4 ; 
			RdEn    = 1'b0 ;
			WrEn    = 1'b0 ;
			WrData  = 8'b0 ;

			next_state = IDLE ;			
		end
	endcase
end

endmodule