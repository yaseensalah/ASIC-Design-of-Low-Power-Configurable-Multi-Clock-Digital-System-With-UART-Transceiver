module RegFile                       //16x8 Register File
#(parameter WIDTH     = 8  ,          
  parameter DEPTH     = 16 ,
  parameter ADDR_SIZE = 4  )         //Address Size = log2(DEPTH)

 (
	input   wire  [WIDTH-1:0]     WrData       ,

	input   wire  [ADDR_SIZE-1:0] Address      ,

	input   wire                  WrEn         ,
	input   wire                  RdEn         ,

	input   wire                  CLK          ,
	input   wire                  RST          ,


	output  reg   [WIDTH-1:0]     RdData       ,
	output  reg                   RdData_Valid ,

	output  wire  [WIDTH-1:0]     REG0         ,     //ALU Operand A
	output  wire  [WIDTH-1:0]     REG1         ,     //ALU Operand B
	output  wire  [WIDTH-1:0]     REG2         ,     //UART Configuration
	output  wire  [WIDTH-1:0]     REG3               //ClkDiv Ratio
 );

reg [WIDTH-1:0] mem [DEPTH-1:0] ;

integer i ;


always @(posedge CLK or negedge RST) begin
	if (!RST) begin
		RdData       <=  'b0 ;
		RdData_Valid <= 1'b0 ;
		for (i=0 ; i<DEPTH ; i=i+1) begin
			if ((i == 'd0) || (i == 'd1)) begin
				mem[i] <= 'b 0000_0000 ;    //ALU Operands A , B  = 0
			end
			else if (i == 'd2) begin
				mem[i] <= 'b 1000_0_0  ;    //{Prescale=8 , PAR_TYP=Even , PAR_EN=0}
			end
			else if (i == 'd3) begin
				mem[i] <= 'b 0000_1000 ;    //Div_Ratio = 8
			end
			else begin
				mem[i] <= 'b 0000_0000 ;
			end
		end
	end

	else if (WrEn && !RdEn) begin   //Write Operation
		mem[Address] <= WrData ;	
		
		RdData       <= RdData ;
		RdData_Valid <= 1'b0   ;
	end

	else if (RdEn && !WrEn) begin   //Read Operation
		RdData       <= mem[Address] ;
		RdData_Valid <= 1'b1         ;
	end

	else begin
		RdData       <= RdData ;
		RdData_Valid <= 1'b0   ;		
	end
end

assign REG0 = mem[0] ;
assign REG1 = mem[1] ;
assign REG2 = mem[2] ;
assign REG3 = mem[3] ;

endmodule