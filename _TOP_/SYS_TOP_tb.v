`timescale 1ns/1ps
module SYS_TOP_tb();

reg    RX_IN_tb    ;

reg    REF_CLK_tb  ;
reg    UART_CLK_tb ;
reg    RST_tb      ;

wire   TX_OUT_tb   ;

wire   PAR_ERR_tb  ;
wire   STP_ERR_tb  ;

parameter Wr_CMD        = 8'hAA ;
parameter Rd_CMD        = 8'hBB ;
parameter ALU_OP_CMD    = 8'hCC ;
parameter ALU_NOP_CMD   = 8'hDD ;

parameter T_REF_CLK  = 20          ;  //REF  CLK period = 20 ns
parameter T_UART_CLK = 104166.6667 ;  //UART CLK period = 52083.33333 ns


SYS_TOP DUT (
  .RX_IN    (RX_IN_tb)    ,  
  .REF_CLK  (REF_CLK_tb)  ,
  .UART_CLK (UART_CLK_tb) ,
  .RST      (RST_tb)      ,

  .TX_OUT   (TX_OUT_tb)   ,
  .PAR_ERR  (PAR_ERR_tb)  ,
  .STP_ERR  (STP_ERR_tb)
  );

initial
  begin
    initialization ;
    #(T_UART_CLK) ;

    RF_Write(8'h05 , 8'hAB);                          //Writing "AB" @x05

    RF_Read(8'h05);                                   //Reading from x05
    
    ALU_OP(8'h08 , 8'h04 , 8'h00);                    //Adding   8 + 4

    ALU_NOP(8'h01);                                   //Subtract 8 - 4

    RF_Read(8'h02);                                   //Reading from x02 (UART Configuration)

    RF_Write(8'h02 , 8'b 001000_0_1);                 //Writing New Configuration (Enabling Parity)

    RF_Read_PAR(8'h02,1'b1);                          //Reading from x02 (UART New Configuration) with including Even Parity bit

    ALU_NOP_PAR(8'h0a,1'b0);                          //Comparing 8 = 4 ? with Function' Even Parity 
    
    ALU_OP_PAR(8'h05,1'b0 , 8'h03,1'b0 , 8'h02,1'b1); //Multipling 5 * 3 with A , B , and Function Even Parities

    #(T_UART_CLK*200) $stop;

  end


/*----------------------------------INITIALIZATION & CLOCK GENERATION----------------------------------*/
always #(T_REF_CLK/2)  REF_CLK_tb  = ~REF_CLK_tb  ;

always #(T_UART_CLK/2) UART_CLK_tb = ~UART_CLK_tb ;

task initialization ();
begin
  RX_IN_tb    = 1'b1 ; 
  REF_CLK_tb  = 1'b0 ;
  UART_CLK_tb = 1'b0 ;
  RST_tb      = 1'b0 ;
  #200
  RST_tb = 1'b1 ;
end
endtask

/*----------------------------------TASKS (WITHOUT PARITY)----------------------------------*/
task RF_Write (
  input [7:0] ADDRESS ,
  input [7:0] Wr_Data 
  );
  integer i,j,k;
  begin
  ///////Frame 1: CMD///////
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(i=0 ; i<8 ; i=i+1)
      begin
        RX_IN_tb = Wr_CMD[i];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 2: ADD///////
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(j=0 ; j<8;  j=j+1)
      begin
        RX_IN_tb = ADDRESS[j];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 3: DATA///////
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(k=0 ; k<8 ; k=k+1)
      begin
        RX_IN_tb = Wr_Data[k];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);
  end
endtask

task RF_Read(
  input [7:0] ADDRESS 
  );
  integer i,j;
  begin
  ///////Frame 1: CMD///////  
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(i=0 ; i<8 ; i=i+1)
      begin
        RX_IN_tb = Rd_CMD[i];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 2: ADD///////
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(j=0 ; j<8 ; j=j+1)
      begin
        RX_IN_tb = ADDRESS[j];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);
  end
endtask

task ALU_OP(
  input [7:0] A    ,
  input [7:0] B    ,
  input [7:0] FUNC 
  );
  integer i,j,k,n;
  begin
  ///////Frame 1: CMD///////    
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(i=0 ; i<8 ; i=i+1)
      begin
        RX_IN_tb = ALU_OP_CMD[i];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 2: OPERAND A///////  
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(j=0 ; j<8 ; j=j+1)
      begin
        RX_IN_tb = A[j];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 3: OPERAND B///////  
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(k=0 ; k<8 ; k=k+1)
      begin
        RX_IN_tb = B[k];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 4: FUNC///////  
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(n=0 ; n<8 ; n=n+1)
      begin
        RX_IN_tb = FUNC[n];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);
    #(T_UART_CLK*80);  //more 10 of Tx CLK Cycles for MSB [15:8] of ALU output
  end
endtask

task ALU_NOP(
  input [7:0] FUNC 
  );
  integer i,j;
  begin
  ///////Frame 1: CMD///////    
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(i=0 ; i<8 ; i=i+1)
      begin
        RX_IN_tb = ALU_NOP_CMD[i];
       #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 2: FUNC///////  
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(j=0 ; j<8 ; j=j+1)
      begin
        RX_IN_tb = FUNC[j];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);
    #(T_UART_CLK*80);  //more 10 of Tx CLK Cycles for MSB [15:8] of ALU output
  end
endtask

/*----------------------------------TASKS (WITH PARITY)----------------------------------*/
task RF_Read_PAR(
  input [7:0] ADDRESS ,
  input       ADD_PAR 
  );
  integer i,j;
  begin
  ///////Frame 1: CMD///////  
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(i=0 ; i<8 ; i=i+1)
      begin
        RX_IN_tb = Rd_CMD[i];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b0; //Even Parity of BB
    #(T_UART_CLK*8);
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 2: ADD///////
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(j=0 ; j<8 ; j=j+1)
      begin
        RX_IN_tb = ADDRESS[j];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = ADD_PAR ;
    #(T_UART_CLK*8);
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);
  end
endtask

task ALU_OP_PAR(
  input [7:0] A        ,
  input       A_PAR    ,
  input [7:0] B        ,
  input       B_PAR    ,
  input [7:0] FUNC     ,
  input       FUNC_PAR 
  );
  integer i,j,k,n;
  begin
  ///////Frame 1: CMD///////    
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(i=0 ; i<8 ; i=i+1)
      begin
        RX_IN_tb = ALU_OP_CMD[i];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b0; //Even Parity of CC
    #(T_UART_CLK*8);
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 2: OPERAND A///////  
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(j=0 ; j<8 ; j=j+1)
      begin
        RX_IN_tb = A[j];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = A_PAR ;
    #(T_UART_CLK*8);   
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 3: OPERAND B///////  
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(k=0 ; k<8 ; k=k+1)
      begin
        RX_IN_tb = B[k];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = B_PAR ;
    #(T_UART_CLK*8);    
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 4: FUNC///////  
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(n=0 ; n<8 ; n=n+1)
      begin
        RX_IN_tb = FUNC[n];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = FUNC_PAR;
    #(T_UART_CLK*8);
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);
    #(T_UART_CLK*80);  //more 10 of Tx CLK Cycles for MSB [15:8] of ALU output
  end
endtask

task ALU_NOP_PAR(
  input [7:0] FUNC     ,
  input       FUNC_PAR 
  );
  integer i,j;
  begin
  ///////Frame 1: CMD///////    
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(i=0 ; i<8 ; i=i+1)
      begin
        RX_IN_tb = ALU_NOP_CMD[i];
       #(T_UART_CLK*8);
      end
    RX_IN_tb = 1'b0; //Even Parity of DD
    #(T_UART_CLK*8);     
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);

  ///////Frame 2: FUNC///////  
    RX_IN_tb = 1'b0;
    #(T_UART_CLK*8);
    for(j=0 ; j<8 ; j=j+1)
      begin
        RX_IN_tb = FUNC[j];
        #(T_UART_CLK*8);
      end
    RX_IN_tb = FUNC_PAR;
    #(T_UART_CLK*8);
    RX_IN_tb = 1'b1;
    #(T_UART_CLK*8);
    #(T_UART_CLK*80);  //more 10 of Tx CLK Cycles for MSB [15:8] of ALU output
  end
endtask


endmodule 