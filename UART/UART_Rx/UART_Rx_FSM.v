module UART_Rx_FSM 
(
	input   wire       RX_IN       ,
	input   wire       PAR_EN      ,
	input   wire [4:0] edge_cnt    ,   //width of Oversampling Prescale
	input   wire [3:0] bit_cnt     ,   //maximum number of received bits is 11 (represented in 4 bits)
	input   wire       strt_glitch ,
	input   wire       par_err     ,
	input   wire       stp_err     ,
	input   wire [4:0] Prescale    ,
	input   wire       CLK         ,
	input   wire       RST         ,

	output  reg        dat_samp_en ,
	output  reg        cnt_enable  ,
	output  reg        strt_chk_en ,	
	output  reg        par_chk_en  ,
	output  reg        stp_chk_en  ,
	output  reg        data_valid  ,
	output  reg        deser_en    
);

//using Gray State Encoding because of the sequential transitions between states.
localparam IDLE   = 3'b000 ;
localparam START  = 3'b001 ;
localparam DATA   = 3'b011 ; 
localparam PAR    = 3'b010 ;
localparam STOP   = 3'b110 ;


reg [2:0] current_state , next_state ;
reg data_valid_comp ;

/*------------------- State Transition and Registering Logic-------------------*/
always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		current_state <= IDLE ;
		data_valid    <= 1'd0 ;
	end
	else begin
		current_state <= next_state      ;
		data_valid    <= data_valid_comp ;		
	end
end

/*-------------------------Next State and Output Logic-------------------------*/
always @(*) begin
	case(current_state)
	    IDLE: begin
	    	dat_samp_en     = 1'd0 ;
	    	cnt_enable      = 1'd0 ;
	    	strt_chk_en     = 1'd0 ;
	    	par_chk_en      = 1'd0 ;
	    	stp_chk_en      = 1'd0 ;
	    	data_valid_comp = 1'd0 ;
	    	deser_en        = 1'd0 ;

	    	if (RX_IN == 1'd1) begin      //receiving START bit
	    		next_state = IDLE  ;
	    	end
	    	else begin
	    		next_state = START ;
	    	end
	    end


	    START: begin
	    	dat_samp_en     = 1'd1 ;
	    	cnt_enable      = 1'd1 ;
	    	if (edge_cnt == (Prescale>>1)) begin
	    	    strt_chk_en = 1'd1 ;	    		
	    	end
	    	else begin
	    	    strt_chk_en = 1'd0 ;
	    	end
	    	par_chk_en      = 1'd0 ;
	    	stp_chk_en      = 1'd0 ;
	    	data_valid_comp = 1'd0 ;
	    	deser_en        = 1'd0 ;

	    	if (bit_cnt == 4'd0) begin     
	    		next_state = START ;
	    	end
	    	else begin
	    	    if (strt_glitch == 1'd1) begin
	    	    	next_state = IDLE ;
	    	    end
	    	    else begin
	    	    	next_state = DATA  ;
	    	    end
	    	end
	    end


	    DATA: begin
	    	dat_samp_en     = 1'd1 ;
	    	cnt_enable      = 1'd1 ;
	    	strt_chk_en     = 1'd0 ;
	    	if (PAR_EN == 1'd1) begin
	    	    par_chk_en  = 1'd1 ;
	    	end
	    	else begin
	    	    par_chk_en  = 1'd0 ;
	    	end
	    	stp_chk_en      = 1'd0 ;
	    	data_valid_comp = 1'd0 ;
	    	deser_en        = 1'd1 ;

	    	if (bit_cnt != 4'd9) begin     
	    		next_state = DATA ;
	    	end
	    	else begin
	    	    if (PAR_EN == 1'd1) begin
	    	    	next_state = PAR  ;
	    	    end
	    	    else begin
	    	    	next_state = STOP ;
	    	    end
	    	end
	    end


	    PAR: begin
	    	dat_samp_en     = 1'd1 ;
	    	cnt_enable      = 1'd1 ;
	    	strt_chk_en     = 1'd0 ;
	    	par_chk_en      = 1'd1 ;
	    	stp_chk_en      = 1'd0 ;
	    	data_valid_comp = 1'd0 ;
	    	deser_en        = 1'd0 ;

	    	if (bit_cnt != 4'd10) begin     
	    		next_state = PAR ;
	    	end
	    	else begin
	    	    if (par_err == 1'd1) begin
	    	    	next_state = IDLE ;
	    	    end
	    	    else begin
	    	    	next_state = STOP ;
	    	    end
	    	end
	    end


	    STOP: begin
	    	dat_samp_en     = 1'd1 ;
	    	cnt_enable      = 1'd1 ;
	    	strt_chk_en     = 1'd0 ;
	    	par_chk_en      = 1'd0 ;
	    	if (edge_cnt == (Prescale>>1)) begin    //deserializing data after each sampling done
	    	    stp_chk_en  = 1'd1 ;	    		
	    	end
	    	else begin
	    	    stp_chk_en  = 1'd0 ;
	    	end
	    	deser_en        = 1'd0 ;	
            if (edge_cnt != 5'd7) begin
	    	    data_valid_comp = 1'd0 ;
	    	    next_state = STOP ;
	    	end
	    	else if (stp_err == 1'd1) begin
	    	    data_valid_comp = 1'd0 ;
	    	    next_state = IDLE ;	    	        	
	    	end
	    	else if (RX_IN == 1'd1) begin
	    	    data_valid_comp = 1'd1 ;
	    	    next_state = IDLE ;
	    	end
	    	else begin                           //receiving START bit
	    	    data_valid_comp = 1'd1 ;
	    	    next_state = START ;
	    	end            	
        end

        default: begin
	    	dat_samp_en     = 1'd0 ;
	    	cnt_enable      = 1'd0 ;
	    	strt_chk_en     = 1'd0 ;
	    	par_chk_en      = 1'd0 ;
	    	stp_chk_en      = 1'd0 ;
	    	data_valid_comp = 1'd0 ;
	    	deser_en        = 1'd0 ;

	    	next_state      = IDLE ;     	
        end
	endcase
end

endmodule