//=================================================================================//
//		File Name: EmRobot_Control
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//
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
					Ctrl_FifoFull,
					//******** Display parameter *******//
					Ctrl_instanceCmd,
					Ctrl_Mode
);

input wire 				Ctrl_sysclk;
input wire 				Ctrl_reset;
input wire 				Ctrl_request;
input wire [17:0] 	Ctrl_sw;
input wire [2:0]		Ctrl_btns;

output wire 			Ctrl_ready;
output wire [7:0] 	Ctrl_command;
output wire 			Ctrl_empty;
output wire [31:0] 	Ctrl_instanceCmd;
output wire 		 	Ctrl_Mode;
output wire 			Ctrl_FifoFull;

//************** Variables ********************//
reg mode = 1'b0;
always@(posedge Ctrl_sysclk)
	if(Ctrl_btns[0])
		mode = ~mode;
	else
		mode = mode;
//*********************************************//

//------------------- Commands Storage -------------------//
wire 		Cmd_Write;
wire [7:0] Cmd_InputData;
wire [7:0] Cmd_OutputData;
wire 		  Cmd_Request;
wire 		  Cmd_FifoEmp;
wire 		  Cmd_FifoFull;	


//-------------------  OnBoard Control -------------------//
wire [7:0]		Board_OpCode;
wire [11:0]		SegData;
wire [7:0]		paraCount;
wire [7:0]		paraNum;


//------------------- OnBoard Control FSM -----------------//
wire [1:0]	DisplayStatus;
wire [1:0]  FsmState;
//------------------- Wireless Control -------------------//

wire [7:0]	WirelessData;

//******************* Assign Part *************************//
assign Cmd_Request= Ctrl_request;
assign Ctrl_command = Cmd_OutputData;
assign Ctrl_empty   = Cmd_FifoEmp;
assign Ctrl_Mode	  = mode;
assign Ctrl_FifoFull = Cmd_FifoFull;


FIFO commands(
				.sysclk(Ctrl_sysclk),
				.reset(Ctrl_reset),
				.Write(Cmd_Write),
				.InputData(Cmd_InputData),
				.Request(Cmd_Request),
            .FifoEmp(Cmd_FifoEmp),
				.FifoFull(Cmd_FifoFull),
				.OutputData(Cmd_OutputData)
);


Control_FSM fsm(
				.sysclk(Ctrl_sysclk),
				.reset(Ctrl_reset),
				.btns(Ctrl_btns),
				.mode(mode),
				
				.fush(Ctrl_ready),
				.storecmd(Cmd_Write),
				.showDisplay(DisplayStatus),
				.FsmState(FsmState)
);

CmdParse cmdparse(
				.sysclk(Ctrl_sysclk),
				.reset(Ctrl_reset),				
				.OpCode(Board_OpCode),
				.btns(Ctrl_btns[2:1]),
				.status(FsmState),	
				.paraCount(paraCount),
				.paraNo(paraNum)
);

MUX2 mux(
			.select(mode),
			.dataOne(Board_OpCode),
			.dataTwo(WirelessData),
			.data(Cmd_InputData)
);

SW sw(
			.sw(Ctrl_sw),
			.seg(SegData),
			.binary(Board_OpCode)
);
SegDisplay seg(
				.option(DisplayStatus),
				.sw(SegData),
				.paraNo(paraCount),
				.para(paraNum),
				
				.segData(Ctrl_instanceCmd)
);
WirelessMode wireless(
					.sysclk(Ctrl_sysclk),
					.reset(Ctrl_reset),
					.WirelessData(WirelessData)
);
endmodule