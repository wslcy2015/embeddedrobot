//=================================================================================//
//		File Name: Ctrl_WirelessMode
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//

module WirelessMode(
			sysclk,
			reset,
			WirelessData
);

input sysclk;
input reset;

output reg [7:0] WirelessData = 8'h00;

endmodule
