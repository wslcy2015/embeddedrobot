module EmRobot_LCDCtrol(
			CLOCK_50,
			LCD_DATA,
			LCD_RW,
			LCD_RS,
			LCD_EN,
			LCD_BLON,
			LCD_ON
);
input 			CLOCK_50;
output [7:0] 	LCD_DATA;
output 			LCD_RW;
output 			LCD_RS;
output			LCD_EN;
output			LCD_BLON;
output  			LCD_ON;


reg 	[7:0] 	LCD_DATA;
reg				LCD_RW;
reg				LCD_RS;
reg				LCD_EN;
reg	clk_1k = 1'b0;

reg [20:0] 		counter = 0;
reg [10:0]		counter1 = 0;

assign LCD_BLON = 1;
assign LCD_ON = 1;

always@(posedge CLOCK_50)//divition to 1 khz
if(counter == 25000)
	begin
		clk_1k <=~clk_1k;
		counter<=0;
	end
else
	counter <= counter +1;

	
always@(posedge clk_1k) //actual control 
begin
	if(counter1<1023)
		counter1 <= counter1+1;
	//else
		//counter1 <=0;
	casex(counter1)
		400:begin
			LCD_DATA <=8'b00111000;//0x38
			LCD_RW <= 1'b0;
			LCD_RS <= 1'b0;
			end
		
		401:LCD_EN<=1'b1;
		
		410:begin			//0x0c
				LCD_DATA <= 8'h0c;
				LCD_RW 	<= 1'b0;
				LCD_RS  	<= 1'b0;
			end
		411:LCD_EN <=1'b1;
		
		420:begin			//0x01
				LCD_DATA	<=8'h01;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b0;
			end
		421:LCD_EN		<=1'b1;
		
		430:begin
				LCD_DATA	<=8'h06;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b0;
			end
		431:LCD_EN 		<=1'b1;
		
		440:begin
				LCD_DATA	<=8'hc0;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b0;
			end
		441:begin
				LCD_EN 		<=1'b1;
				//ack <=1;
			end
			
		450:begin					//P
				LCD_DATA	<=8'h50;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		451:LCD_EN 		<=1'b1;	
		460:begin					//R
				LCD_DATA	<=8'h72;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		461:LCD_EN 		<=1'b1;	
		470:begin					//E
				LCD_DATA	<=8'h65;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		471:LCD_EN 		<=1'b1;	
		480:begin					//S
				LCD_DATA	<=8'h73;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		481:LCD_EN 		<=1'b1;	
		490:begin					//T
				LCD_DATA	<=8'h74;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		491:LCD_EN 		<=1'b1;	
		500:begin					//O
				LCD_DATA	<=8'h6f;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		501:LCD_EN 		<=1'b1;	
		510:begin					//N
				LCD_DATA	<=8'h6e;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		511:LCD_EN 		<=1'b1;	
		510:begin					//Z
				LCD_DATA	<=8'h5a;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		511:LCD_EN 		<=1'b1;
		520:begin					//H
				LCD_DATA	<=8'h68;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		521:LCD_EN 		<=1'b1;
		530:begin					//A
				LCD_DATA	<=8'h61;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		531:LCD_EN 		<=1'b1;
		540:begin					//N
				LCD_DATA	<=8'h6e;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		541:LCD_EN 		<=1'b1;
		550:begin					//G
				LCD_DATA	<=8'h67;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		551:LCD_EN 		<=1'b1;
		560:begin					//!
				LCD_DATA	<=8'h21;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		561:LCD_EN 		<=1'b1;
		570:begin					//!
				LCD_DATA	<=8'h21;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		571:LCD_EN 		<=1'b1;
		
		580:begin
				LCD_DATA	<=8'h80;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b0;
			end
		581:LCD_EN 		<=1'b1;
		590:begin
				LCD_DATA	<=8'h4c;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		591:LCD_EN 		<=1'b1;
		600:begin
				LCD_DATA	<=8'h4f;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		601:LCD_EN 		<=1'b1;
		610:begin
				LCD_DATA	<=8'h56;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		611:LCD_EN 		<=1'b1;
		620:begin
				LCD_DATA	<=8'h45;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		621:LCD_EN 		<=1'b1;
		630:begin
				LCD_DATA	<=8'h21;
				LCD_RW 	<=1'b0;
				LCD_RS	<=1'b1;
			end
		631:LCD_EN 		<=1'b1;
		default:LCD_EN <=1'b0;
	endcase

end
endmodule
	