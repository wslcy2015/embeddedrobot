module EmRobot_Control(
					//******** De2-115 part **********//
					Ctrl_sysclk,
					Ctrl_reset,
					Ctrl_sw,
					Ctrl_btns,
					
					//Interfaces with other part *******//
					Ctrl_ready,
					Ctrl_command,
					Ctrl_empty,
					Ctrl_request,
					//******** Display parameter *******//
					Ctrl_instanceCmd
);

input wire 			Ctrl_sysclk;
input wire 			Ctrl_reset;
input wire 			Ctrl_request;
input wire [17:0] Ctrl_sw;
input wire [2:0]	Ctrl_btns;

output reg 			Ctrl_ready;
output reg [7:0] 	Ctrl_command;
output reg 			Ctrl_empty;
output reg [31:0] Ctrl_instanceCmd;

//************** Variables ********************//
//*********************************************//

//------------------- Commands Storage -------------------//



//-------------------  OnBoard Control -------------------//




//------------------- OnBoard Control FSM -----------------//




//------------------- Wireless Control -------------------//


FIFO commands(
				.sysclk(sysclk),
				.reset(reset),
				.Write(Cmd_Write),
				.InputData(Cmd_InputData),
				.Request(Cmd_Request),
            .FifoEmp(Cmd_FifoEmp),
				.FifoFull(Cmd_FifoFull),
				.OutputData(Cmd_OutputData)
);


Control_FSM fsm(
				sysclk,
				reset,
				btns,
				mode,
				
				fush,
				storecmd,
				showDisplay
);