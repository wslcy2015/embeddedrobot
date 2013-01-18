//=================================================================================//
//		File Name: Ctrl_SegDisplay
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//
module SegDisplay(
				option,
				sw,
				paraNo,
				para,
				mode,
				WLData,
				
				segData
);
input wire [1:0] option;
input wire [11:0] sw;
input wire [7:0] paraNo;
input wire [7:0] para;

input wire mode;
input wire[31:0] WLData;

output reg [31:0] segData;
always@(*)
if(!mode)begin
	case(option)
		2'b00:segData=32'h00ff_ff00;
		2'b11:segData={16'hccdd,sw,4'hd};
		2'b01:segData={paraNo,para,sw,4'hd};
		default:segData=32'h0000_0000;
	endcase
end else begin
	segData = {8'h00,WLData[23:16],16'h0000};
end
endmodule
				
			