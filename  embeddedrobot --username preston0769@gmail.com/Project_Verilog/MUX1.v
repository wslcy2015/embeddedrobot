//=================================================================================//
//		File Name: MUX8
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//
module MUX1(
			select,
			dataOne,
			dataTwo,
			data,
);
input 	wire dataOne;
input 	wire dataTwo;
output 	reg  data;
input    wire select;

always@(*)
	if(select)
		data = dataTwo;
	else
		data = dataOne;
endmodule
