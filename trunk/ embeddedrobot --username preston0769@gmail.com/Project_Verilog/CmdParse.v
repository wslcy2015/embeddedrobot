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
output reg 	[7:0] paraNo;

reg [7:0]OpCode_d;

CmmdsLut lut(
		.opcode(OpCode_d),
		.no(paraCount)
);
always@(posedge sysclk)
begin 
	if(reset)
		begin
			OpCode_d  <= 8'h00;
			paraNo  	 <= 8'h00;
		end
	else begin
		case(status)
		2'b00:begin
				paraNo  	 <= 8'h00;
				end
		2'b01:begin
				paraNo  	 <= 8'h00;
				if(btns[1])
				begin
				Opcode_d = Opcode;	
				end
				end
		2'b10:begin
				if(btns[1])begin
					if(paraNo>paraCount)
						paraNo = paraNo;
					else
						paraNo =paraNo +1;
				end
				end
		default:begin
				Opcode_d = 8'h00;
				paraNo = 8'h00;
				end
		endcase
	end
end
endmodule