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
			CmdEmpty,
			FuncBtn,
			//Output
			Trans
);
input wire sysclk;
input wire rst;
input wire CmdEmpty;
input wire FuncBtn;

output wire Trans;


//========================== The internal variables ===================================//
parameter INIT 	= 2'b00,
			 WAIT 	= 2'b01,
			 PARSE 	= 2'b10,
			 EXEC		= 2'b11;
	
reg [1:0] State;
reg [1:0] NextState;

reg TransState;
//===================================================================================
assign Trans = TransState;

always@(posedge sysclk)
begin
	if(rst)
		TransState <= 0;
	else
		begin
			if(!CmdEmpty&&FuncBtn)
				TransState <=1'b1;
			else if(CmdEmpty)
				TransState <=1'b0;
			else
				TransState <= TransState;
		end
end



endmodule