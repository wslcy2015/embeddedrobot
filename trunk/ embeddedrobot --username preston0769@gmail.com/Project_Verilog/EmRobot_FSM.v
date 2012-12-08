//=================================================================================//
//		File Name: EmRobot_FSM
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//
//Function of this File:
// 	This file implement the Finite State Machine of Embedded Controlled Robot.
//It controls the Display media such as LEDs 7-SEGs and LCD and so on.
//It also control the communication media like UART and Kinect or camera and so on.
//It also acts as a controller calling the CPU to calculate the data from sensor.
//==================================================================================

module EmRobot_FSM(
			sysclk,
			rst,
			//Input 
			CommandEn,
			Cmmds,
			//Output
			OpCode,
			SegValue,
			FsmStatus,
			DisplayEn,
);
input sysclk;
input rst;
input CommandEn;
input Cmmds;

output OpCode;
output SegValue;
output FsmStatus;
output DisplayEn;


wire sysclk;
wire rst;
wire CommandEn;
wire [4:0] Cmmds;

wire FsmStatus;
reg [7:0] OpCode;
reg [11:0] SegValue;
reg	DisplayEn;

//========================== The internal variables ===================================//
parameter INIT 	= 2'b00,
			 WAIT 	= 2'b01,
			 PARSE 	= 2'b10,
			 EXEC		= 2'b11;
	
reg [1:0] State;
reg [1:0] NextState;
reg [4:0] commands;
reg Status;
//===================================================================================

assign FsmStatus=Status;
	 
always@(posedge sysclk)
begin 
		if(rst)begin
			State <= INIT;
			end
		else
			State <= NextState;
end

always@(posedge sysclk)
begin
	case(State)
	INIT:begin
			Status <=0;
			NextState <= WAIT;
			OpCode <= 8'h00;
			SegValue <= 12'h000;
			DisplayEn <=1'b0;
		  end
	WAIT:begin
			Status <=0;
			if(CommandEn)
			begin
				commands = Cmmds;
				NextState <= PARSE;
				Status<=0;
				end
			else
				begin
				//OpCode <= 8'h00;
				NextState <= WAIT;
				end
			end
	PARSE:begin
			Status <=1;
			DisplayEn<=1'b1;
			case(commands)
			5'd0:
				NextState <= WAIT;
			5'd1:begin
				OpCode <= 8'd128;
				SegValue <= 12'h280;
				NextState <= EXEC;
				 end
			5'd2:begin
				OpCode <= 8'd129;
				SegValue <= 12'h291;
				NextState <= EXEC;
				 end
			5'd3:begin
				OpCode <= 8'd130;
				SegValue <= 12'h300;
				NextState <= EXEC;
				 end
			5'd4:begin
				OpCode <= 8'd131;
				SegValue <= 12'h310;
				NextState <= EXEC;
				 end
			5'd5:begin
				OpCode <= 8'd132;
				SegValue <= 12'h320;
				NextState <= EXEC;
				 end
			5'd6:begin
				OpCode <= 8'd133;
				SegValue <= 12'h330;
				NextState <= EXEC;
				 end
			5'd7:begin
				OpCode <= 8'd134;
				SegValue <= 12'h340;
				NextState <= EXEC;
				 end
			5'd8:begin
				OpCode <= 8'd135;
				SegValue <= 12'h350;
				NextState <= EXEC;
				 end
			5'd9:begin
				OpCode <= 8'd136;
				SegValue <= 12'h361;
				NextState <= EXEC;
				 end
			5'd10:begin
				OpCode <= 8'd137;
				SegValue <= 12'h374;
				NextState <= EXEC;
				 end
			5'd11:begin
				OpCode <= 8'd138;
				SegValue <= 12'h380;
				NextState <= EXEC;
				 end
			5'd12:begin
				OpCode <= 8'd139;
				SegValue <= 12'h393;
				NextState <= EXEC;
				 end
			5'd13:begin
				OpCode <= 8'd140;
				SegValue <= 12'h40f;
				NextState <= EXEC;
				 end
			5'd14:begin
				OpCode <= 8'd141;
				SegValue <= 12'h411;
				NextState <= EXEC;
				 end
			5'd15:begin
				OpCode <= 8'd142;
				SegValue <= 12'h421;
				NextState <= EXEC;
				 end
			5'd16:begin
				OpCode <= 8'd143;
				SegValue <= 12'h430;
				NextState <= EXEC;
				 end
			5'd17:begin
				OpCode <= 8'd144;
				SegValue <= 12'h443;
				NextState <= EXEC;
				 end
			5'd18:begin
				OpCode <= 8'd145;
				SegValue <= 12'h454;
				NextState <= EXEC;
				 end
			5'd19:begin
				OpCode <= 8'd146;
				SegValue <= 12'h460;
				NextState <= EXEC;
				 end
			5'd20:begin
				OpCode <= 8'd147;
				SegValue <= 12'h471;
				NextState <= EXEC;
				 end
			5'd21:begin
				OpCode <= 8'd148;
				SegValue <= 12'h48e;
				NextState <= EXEC;
				 end
			5'd22:begin
				OpCode <= 8'd149;
				SegValue <= 12'h49e;
				NextState <= EXEC;
				 end
			5'd23:begin
				OpCode <= 8'd150;
				SegValue <= 12'h501;
				NextState <= EXEC;
				 end
			5'd24:begin
				OpCode <= 8'd151;
				SegValue <= 12'h510;
				NextState <= EXEC;
				 end
			5'd25:begin
				OpCode <= 8'd152;
				SegValue <= 12'h52e;
				NextState <= EXEC;
				 end
			5'd26:begin
				OpCode <= 8'd153;
				SegValue <= 12'h530;
				NextState <= EXEC;
				 end
			5'd27:begin
				OpCode <= 8'd154;
				SegValue <= 12'h540;
				NextState <= EXEC;
				 end
			5'd28:begin
				OpCode <= 8'd155;
				SegValue <= 12'h551;
				NextState <= EXEC;
				 end
			5'd29:begin
				OpCode <= 8'd156;
				SegValue <= 12'h562;
				NextState <= EXEC;
				 end
			5'd30:begin
				OpCode <= 8'd157;
				SegValue <= 12'h572;
				NextState <= EXEC;
				 end
			5'd31:begin
				OpCode <= 8'd158;
				SegValue <= 12'h582;
				NextState <= EXEC;
				 end
			default:NextState <= WAIT;
			endcase
		end
	EXEC:begin
		NextState = WAIT;
		end
	endcase
end
endmodule