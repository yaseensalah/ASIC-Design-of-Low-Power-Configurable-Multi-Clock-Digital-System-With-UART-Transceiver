module CLK_GATE    
(
    input   wire   CLK_EN    ,
    input   wire   CLK       ,
    output  wire   GATED_CLK
);


/*-------Latch-based Clock Gating-------*/

reg     Latch_Out ;    //internal connection

//latch (Level Sensitive Device)
always @(CLK or CLK_EN) begin
  if(!CLK)      // active low
   begin
    Latch_Out <= CLK_EN ;
   end
 end
 
//ANDING
assign  GATED_CLK = CLK && Latch_Out ;


/*--------@ Logic Synthesis Step--------/
TLATNCAX12M U0_TLATNCAX12M (
.E(CLK_EN),
.CK(CLK),
.ECK(GATED_CLK)
);

/*-------------@ DFT Step-------------/
TLATNCAX12M U0_TLATNCAX12M (
.E(CLK_EN|test_en),
.CK(CLK),
.ECK(GATED_CLK)
);
*/

endmodule