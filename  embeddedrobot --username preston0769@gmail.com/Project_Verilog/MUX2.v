module MUX2(
			select,
			dataOne,
			dataTwo,
			data
);
input 	wire [7:0] dataOne;
input 	wire [7:0] dataTwo;
output 	wire [7:0] data;
input    wire select;

if(select)
	data = dataTwo;
else
	data = dataOne;
endmodule
