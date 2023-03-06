module ALU 
#(parameter IN_WIDTH  = 8  ,
  parameter OUT_WIDTH = 16 ,
  parameter FUN_WIDTH = 4  )

(
  input  wire [IN_WIDTH-1 : 0]  A         ,
  input  wire [IN_WIDTH-1 : 0]  B         ,

  input  wire [FUN_WIDTH-1 : 0] ALU_FUN   ,
  input  wire                   Enable    ,

  input  wire                   CLK       ,
  input  wire                   RST       ,


  output reg  [OUT_WIDTH-1 : 0] ALU_OUT   ,
  output reg                    ALU_VALID 
);


always @(posedge CLK or negedge RST) begin
  if (!RST) begin
      ALU_OUT   <=  'b0 ;
      ALU_VALID <= 1'b0 ;
  end

  else if (Enable) begin
    case (ALU_FUN)
      4'b0000: ALU_OUT <= A + B ;
      4'b0001: ALU_OUT <= A - B ;
      4'b0010: ALU_OUT <= A * B ;
      4'b0011: ALU_OUT <= A / B ;

      4'b0100: ALU_OUT <=  (A & B) ;
      4'b0101: ALU_OUT <=  (A | B) ;
      4'b0110: ALU_OUT <= ~(A & B) ;
      4'b0111: ALU_OUT <= ~(A | B) ;
      4'b1000: ALU_OUT <=  (A ^ B) ;
      4'b1001: ALU_OUT <= ~(A ^ B) ;

      4'b1010: ALU_OUT <= (A == B)? 'd1 : 'd0 ;
      4'b1011: ALU_OUT <= (A  > B)? 'd2 : 'd0 ;
      4'b1100: ALU_OUT <= (A <  B)? 'd3 : 'd0 ;

      4'b1101: ALU_OUT <= A >> 1 ;
      4'b1110: ALU_OUT <= A << 1 ;

      default: ALU_OUT <= 'b0 ;
    endcase    
    ALU_VALID <= 1'b1 ;
  end

  else begin
      ALU_OUT   <= ALU_OUT ;
      ALU_VALID <= 1'b0    ;    
  end
end

endmodule 