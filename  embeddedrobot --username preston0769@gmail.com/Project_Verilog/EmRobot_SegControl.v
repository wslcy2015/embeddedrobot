//=================================================================================//
//		File Name: EmRobot_SegControl
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//

module EmRobot_SegControl(
  input  wire     CLOCK_50,         	//System Clock 50MHZ       
  input  wire		KEY,						// Reset Key
  input  wire     Enable,					// Key to change the data
  input  wire[31:0] Value,					// Display Data
  output reg[6:0] Hex0,						//7-SEGs
  output reg[6:0] Hex1,
  output reg[6:0] Hex2,
  output reg[6:0] Hex3,
  output reg[6:0] Hex4,
  output reg[6:0] Hex5,
  output reg[6:0] Hex6,
  output reg[6:0] Hex7
);
 
wire [2:0] SEG7_DIG;
wire [6:0] SEG7_SEG;
reg [31:0] DisplayData;

always@(posedge CLOCK_50)
begin
	if(KEY)
		DisplayData <=32'h0000_0000;
		//DisplayData <=DisplayData;
	else if(Enable)
		DisplayData	<=Value;
	else
		DisplayData <=DisplayData;
end


always@(posedge CLOCK_50)
	begin	
		case(SEG7_DIG)
		3'b000:Hex0 <= SEG7_SEG;
		3'b001:Hex1 <= SEG7_SEG;
		3'b010:Hex2 <= SEG7_SEG;
		3'b011:Hex3 <= SEG7_SEG;
		3'b100:Hex4 <= SEG7_SEG;
		3'b101:Hex5 <= SEG7_SEG;
		3'b110:Hex6 <= SEG7_SEG;
		3'b111:Hex7 <= SEG7_SEG;
		endcase
	end

SegDrive u0(
  .i_clk            (CLOCK_50),
  .i_rst_n          (KEY),
  .i_data           (DisplayData),  
  .o_seg            (SEG7_SEG),
  .o_dig				  (SEG7_DIG)
);
 

endmodule