//=================================================================================//
//		File Name: Ctrl_CmdParse
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//
module CmdParse(
				sysclk,
				reset,				
				OpCode,
				btns,
				status,	
				paraCount,
				paraNo
);
input wire sysclk;
input wire reset;
input wire [7:0] OpCode;
input wire [1:0] btns;
input wire [1:0] status;

output wire [7:0] paraCount;
output wire	[7:0] paraNo;

assign paraNo = counter;
reg [7:0] 	counter ;
reg [7:0]	OpCodeReg;

RobotIOLUT robotlut(
			.selection(OpCodeReg),
			.paraCount(paraCount)
);
always@(posedge sysclk)
if(reset)
		begin
			OpCodeReg  <= 8'h00;
			counter 		<=8'h00;
		end
else begin
		case(status)
		2'b00:counter <= 8'h00;
		2'b01:begin
				if(btns[1])
				begin
						OpCodeReg <= OpCode;
						counter   <= 8'h00;
				end
				end
		2'b10:begin
				if(btns[1])
					counter <= counter +1;
				else
					counter <= counter;
				end
		default:begin
					OpCodeReg <= OpCodeReg;
					counter <= counter+1;
				end
		endcase
end
endmodule