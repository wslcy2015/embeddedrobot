//=================================================================================//
//		File Name: Ctrl_SW
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//
module SW(
			sw,
			seg,
			binary
);

input [17:0] sw;

output [11:0] seg;
output [7:0] 	binary;

wire [3:0] Hundreds;
wire [3:0] Tens;
wire [3:0] Ones;

assign binary = sw[7:0];
assign seg = {Hundreds,Tens,Ones};

//assign seg=sw[11:0];
//SWLUT swlut(
//		.SW(sw[11:0]),
//		.BIN(binary)
//);
BIN2BCD bin2bcd(
		.binary(sw[7:0]),
		.Hundreds(Hundreds),
		.Tens(Tens),
		.Ones(Ones)
);

endmodule