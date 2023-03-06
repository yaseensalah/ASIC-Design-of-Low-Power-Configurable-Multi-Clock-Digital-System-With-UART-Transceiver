`timescale 1ns/1ps 
module UART_Rx_tb ();

	reg        RX_IN_tb         ;
	reg [4:0]  Prescale_tb      ;
	reg        PAR_EN_tb        ;
	reg        PAR_TYP_tb       ;
	reg        CLK_tb           ;
	reg        RST_tb           ;

	wire [7:0] P_DATA_tb        ;
	wire       data_valid_tb    ;
	wire       parity_error_tb  ;
	wire       framing_error_tb ;

integer i , j ;

UART_Rx_Top DUT (
	.RX_IN         (RX_IN_tb)         ,
	.Prescale      (Prescale_tb)      ,
	.PAR_EN        (PAR_EN_tb)        ,
	.PAR_TYP       (PAR_TYP_tb)       ,
	.CLK           (CLK_tb)           ,
	.RST           (RST_tb)           ,

	.P_DATA        (P_DATA_tb)        ,
	.data_valid    (data_valid_tb)    ,
	.parity_error  (parity_error_tb)  ,
	.framing_error (framing_error_tb) 
);


initial begin
    initialization ;

    PAR_TYP_tb = 1'b1 ; //Odd Parity
    
    /*----------Multiple Frames----------*/

    //Valid data is expected
    testing_With_Parity (11'b 1_1_1010_1111_0) ;   
    checking (8'b 1010_1111) ;

    //Parity ERROR is expected
    testing_With_Parity (11'b 1_0_1010_1111_0) ; 

    //Valid data is expected
    testing_With_Parity (11'b 1_0_1010_1110_0) ;
	checking (8'b 1010_1110) ;

    //Valid data is expected (No Parity)
    testing_Without_Parity (10'b 1_1010_0101_0) ;
    checking (8'b 1010_0101) ;

    //Stop ERROR is expected (No Parity)
    testing_Without_Parity (10'b 0_1010_0101_0) ; 

    //Stop ERROR is expected
    testing_With_Parity (11'b 1_1_1010_1111_0) ;

    /*----------Single Frame----------*/
    #80
    PAR_TYP_tb = 1'b0 ; //Even Parity
    //Parity ERROR is expected
    testing_With_Parity (11'b 1_0_1010_1101_0) ; 
    RX_IN_tb = 1'b1 ; 
    #10

    //Valid data is expected
    testing_With_Parity (11'b 1_0_1010_1111_0) ;
    checking (8'b 1010_1111) ;
    RX_IN_tb = 1'b1 ;
    #10

    //Start GLITCH is expected
    testing_start_glitch (11'b 1_0_1010_1111_0) ;

    //Valid data / Parity ERROR is expected
    self_checking (0,$random,$random,1) ;
    //Valid data / Parity ERROR is expected
    self_checking (0,$random,$random,1) ;
    //Start GLITCH is expected
    self_checking (1,$random,$random,1) ;
    //Stop ERROR is expected
    self_checking (0,$random,$random,0) ;
    //Start / Stop ERROR is expected
    self_checking (1,$random,$random,0) ;

    for (j=0; j<10; j=j+1) begin
        #10
		self_checking ($random,$random,$random,$random) ;   		
    end
	#100
	$finish ;
end



/*----------------------------------TASKS & CLOCK GENERATION----------------------------------*/
always #2.5 CLK_tb = ~CLK_tb ;


task initialization ();
begin
    CLK_tb = 1'b0 ;
	RST_tb = 1'b0 ;
	RX_IN_tb = 1'b1 ;
	Prescale_tb = 5'd8 ;
	PAR_EN_tb = 1'b0 ;
	PAR_TYP_tb = 1'b0 ;
	#20
	RST_tb = 1'b1 ;
end
endtask

task testing_With_Parity (input [10:0] S_DATA_PAR);
begin
    PAR_EN_tb = 1'b1 ;
	for (i=0 ; i<11 ; i=i+1) begin
		RX_IN_tb = S_DATA_PAR[i] ;
		#40 ;
    end
end
endtask

task testing_Without_Parity (input [9:0] S_DATA);
begin
    PAR_EN_tb = 1'b0 ;
	for (i=0 ; i<10 ; i=i+1) begin
		RX_IN_tb = S_DATA[i] ;
		#40 ;
    end
end
endtask

task testing_start_glitch (input [10:0] S_DATA_PAR);
begin
    PAR_EN_tb = 1'b1 ;
    RX_IN_tb = 1'b0 ;
    #20
    RX_IN_tb = 1'b1 ;  //glitch
    #5
    RX_IN_tb = 1'b0 ;
    #15
	for (i=1 ; i<11 ; i=i+1) begin
		RX_IN_tb = S_DATA_PAR[i] ;
		#40 ;
    end
end
endtask

task checking (input [7:0] expected);
begin
	if (P_DATA_tb == expected) begin
		$display ("Received Successfully") ;
	end
	else begin
		$display ("--------ERROR--------") ;
	end
end
endtask

task self_checking (
	input       START      ,
	input [7:0] S_DATA_PAR ,
	input       PAR        ,
	input       STOP  
	) ;
begin
    PAR_EN_tb = 1'b1 ;
    PAR_TYP_tb = $random ;

    RX_IN_tb = START ;
	$display ("-------------------------------") ;
    if (START != 1'b0) begin
    	$display ("strt_err works Successfully") ;
    end
    else begin
    	$display ("START is Received Successfully") ;
    end    
    #40
	for (i=0 ; i<8 ; i=i+1) begin
		RX_IN_tb = S_DATA_PAR[i] ;
		#40 ;
    end
    RX_IN_tb = PAR ;
    if ((PAR_TYP_tb && ~^S_DATA_PAR) || (~PAR_TYP_tb && ^S_DATA_PAR)) begin
    repeat((Prescale_tb>>1) + 2) @(posedge CLK_tb);  //delay of sampling
    	if (PAR != 1'b1) begin
    		$display ("par_err works Successfully") ;
    	end
    	else begin
    		$display ("PAR is Received Successfully") ;
        end
    end
    else begin
    repeat((Prescale_tb>>1) + 2) @(posedge CLK_tb);  //delay of sampling
    	if (PAR != 1'b0) begin
    		$display ("par_err works Successfully") ;
    	end    	
    	else begin
    		$display ("PAR is Received Successfully") ;
        end  	
    end
    #15
    RX_IN_tb = STOP ;
    repeat((Prescale_tb>>1) + 2) @(posedge CLK_tb);  //delay of sampling
    if (STOP != 1'b1) begin
    	$display ("stp_err works Successfully") ;  	
    end
    else begin
    	$display ("STOP is Received Successfully") ;
    end
end
endtask

endmodule