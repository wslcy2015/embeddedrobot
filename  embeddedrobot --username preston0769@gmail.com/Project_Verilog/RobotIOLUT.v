//=================================================================================//
//		File Name: Ctrl_RobotIOLUT
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//
module RobotIOLUT(selection,paraCount);
input		[7:0] selection;
output	[7:0]	paraCount;
reg		[7:0]	paraCount;

always @(selection)
begin
		case(selection)
		8'd128: paraCount = 8'b0000_0000;
		8'd129: paraCount = 8'b0000_0001;
		8'd130: paraCount = 8'b0000_0000;
		8'd131: paraCount = 8'b0000_0000;
		8'd132: paraCount = 8'b0000_0000;
		8'd133: paraCount = 8'b0000_0000;
		8'd134: paraCount = 8'b0000_0000;
		8'd135: paraCount = 8'b0000_0000;
		8'd136: paraCount = 8'b0000_0001;
		8'd137: paraCount = 8'b0000_0100;
		8'd138: paraCount = 8'b0000_0001;
		8'd139: paraCount = 8'b0000_0011;
		8'd140: paraCount = 8'b1111_1111;
		8'd141: paraCount = 8'b0000_0001;
		8'd142: paraCount = 8'b0000_0001;
		8'd143: paraCount = 8'b0000_0000;
		8'd144: paraCount = 8'b0000_0011;
		8'd145: paraCount = 8'b0000_0100;
		8'd146: paraCount = 8'b0000_0010;
		8'd147: paraCount = 8'b0000_0001;
		8'd148: paraCount = 8'b1111_1111;
		8'd149: paraCount = 8'b1111_1111;
		8'd150: paraCount = 8'b0000_0001;
		8'd151: paraCount = 8'b0000_0001;
		8'd152: paraCount = 8'b1111_1111;
		8'd153: paraCount = 8'b0000_0000;
		8'd154: paraCount = 8'b0000_0000;
		8'd155: paraCount = 8'b0000_0001;
		8'd156: paraCount = 8'b0000_0010;
		8'd157: paraCount = 8'b0000_0010;
		8'd158: paraCount = 8'b0000_0001;
		default: paraCount = 8'b1001_0000;
		endcase
end

endmodule
