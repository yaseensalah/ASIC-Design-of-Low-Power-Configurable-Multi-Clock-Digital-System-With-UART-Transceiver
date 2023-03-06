`timescale 1ns/1ps 
module UART_Tx_tb ();

	reg [7:0] P_DATA_tb     ;
	reg       DATA_VALID_tb ;
	reg       PAR_EN_tb     ;
	reg       PAR_TYP_tb    ;
	reg       CLK_tb        ;
	reg       RST_tb        ;

	wire      TX_OUT_tb     ;
	wire      Busy_tb       ;

integer i , j , k ;

UART_Tx_Top DUT (
	.P_DATA     (P_DATA_tb)      ,
	.DATA_VALID (DATA_VALID_tb)  ,
	.PAR_EN     (PAR_EN_tb)      ,
	.PAR_TYP    (PAR_TYP_tb)     ,
	.CLK        (CLK_tb)         ,
	.RST        (RST_tb)         ,
	.TX_OUT     (TX_OUT_tb)      ,
	.Busy       (Busy_tb)
);


initial begin
    initialization ;
	for(i=0 ; i<10 ; i=i+1)begin
        testing_Data_Valid_With_Parity    ;
        #60 ;
    end
    for (i=0 ; i<10 ; i=i+1)begin
        testing_Data_Valid_Without_Parity ;
        #60 ;   	
    end
    for (i=0 ; i<10 ; i=i+1)begin
        testing_NO_Data_Valid ;
        #50 ;   	
    end
	#100
	$finish ;
end

initial begin
	for(j=0 ; j<10 ; j=j+1)begin
	$display("//////////-----DATA VALID WITH PARITY TEST %2d-----//////////" , j+1) ;
	    checking ;
	end
	for(j=0 ; j<10 ; j=j+1)begin
	$display("//////////-----DATA VALID WITHOUT PARITY TEST %2d-----//////////" , j+1) ;
	    checking ;
	end
	for(j=0 ; j<10 ; j=j+1)begin
	$display("//////////-----NO DATA TEST-----//////////") ;
	    checking ;
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
	P_DATA_tb = 8'b0000_0000 ;
	DATA_VALID_tb = 1'b0 ;
	PAR_EN_tb = 1'b0 ;
	PAR_TYP_tb = 1'b0 ;
	#20
	RST_tb = 1'b1 ;
end
endtask


task testing_Data_Valid_With_Parity ();
begin
	P_DATA_tb     = $random ;
	DATA_VALID_tb = 1'b1    ;
	PAR_EN_tb     = 1'b1    ;
	PAR_TYP_tb    = $random ;	
	#5
	DATA_VALID_tb = 1'b0 ; 
end
endtask

task testing_Data_Valid_Without_Parity ();
begin
	P_DATA_tb     = $random ;
	DATA_VALID_tb = 1'b1    ;
	PAR_EN_tb     = 1'b0    ;
	PAR_TYP_tb    = $random ;	
	#5
	DATA_VALID_tb = 1'b0 ; 
end
endtask

task testing_NO_Data_Valid ();
begin
	P_DATA_tb     = $random ;
	DATA_VALID_tb = 1'b0    ;
	PAR_EN_tb     = $random ;
	PAR_TYP_tb    = $random ;	
	#5
	DATA_VALID_tb = 1'b0 ; 
end
endtask


task checking ();
begin
    wait (DATA_VALID_tb)
	repeat(2) @(negedge CLK_tb);  //delay of registered output

	if (TX_OUT_tb == 1'b0) begin
		$display ("START bit is sent Successfully") ;
	end
	else begin
		$display ("------------ERROR!------------") ;
	end
	
    for (k=0 ; k<8 ; k=k+1) begin
        #5
	    if (TX_OUT_tb == P_DATA_tb[k]) begin
		    $display ("Bit(%1d) of Test no. %2d is sent Successfully", k , j+1) ;
	    end
	    else begin
		    $display ("--------------------ERROR!-------------------") ;
	    end   	
    end

    #5
    if (PAR_EN_tb && ( TX_OUT_tb  ==  ((PAR_TYP_tb && ~^P_DATA_tb) || (~PAR_TYP_tb && ^P_DATA_tb)) )) begin
    	$display ("PARITY bit is sent Successfully") ;
    end
    else if (PAR_EN_tb)begin
    	$display ("-------------ERROR!------------") ;
    end
    else begin
    	$display ("NO PARITY") ;
    end
    #5

	if (TX_OUT_tb == 1'b1) begin
		$display ("STOP bit is sent Successfully") ;
	end
	else begin
		$display ("------------ERROR!-----------") ;
	end
end
endtask


endmodule