//=================================================================================//
//		File Name: EmRobot_Display
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//

module EmRobot_Display(
					sysclk,
					reset,
					//**********7 Seg *************//
					SegValue,
					hex0,
					hex1,
					hex2,
					hex3,
					hex4,
					hex5,
					hex6,
					hex7,
					//********* LEDG ***************//
					LEDGValue,
					LEDG,
					//********* LEDR **************//
					LEDRValue,
					LEDR,
					//********* LCD ***************//
					LCD_DATA,
					LCD_RW,
					LCD_RS,
					LCD_EN,
					LCD_BLON,
					LCD_ON
);

input sysclk;
input reset;

input [31:0] SegValue;
output [6:0] hex0;
output [6:0] hex1;
output [6:0] hex2;
output [6:0] hex3;
output [6:0] hex4;
output [6:0] hex5;
output [6:0] hex6;
output [6:0] hex7;

input  [8:0] LEDGValue;
output [8:0] LEDG;

input  [17:0] LEDRValue;
output [17:0] LEDR;


output [7:0] 	LCD_DATA;
output 			LCD_RW;
output 			LCD_RS;
output			LCD_EN;
output			LCD_BLON;
output  			LCD_ON;


assign LEDG = LEDGValue;
assign LEDR = LEDRValue;


EmRobot_SegControl em_segcontrol(
		.CLOCK_50(sysclk),
		.KEY(reset),
		.Enable(1'b1),
		.Value(SegValue),
		.Hex0(hex0),
		.Hex1(hex1),
		.Hex2(hex2),
		.Hex3(hex3),
		.Hex4(hex4),
		.Hex5(hex5),
		.Hex6(hex6),
		.Hex7(hex7)
		);	
		
EmRobot_LCDCtrol em_lcdctrol(
		.CLOCK_50(sysclk),
		.LCD_DATA(LCD_DATA),
		.LCD_RW(LCD_RW),
		.LCD_RS(LCD_RS),
		.LCD_EN(LCD_EN),
		.LCD_BLON(LCD_BLON),
		.LCD_ON(LCD_ON)
);
endmodule