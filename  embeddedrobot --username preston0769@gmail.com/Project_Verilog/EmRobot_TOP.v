//=================================================================================//
//		File Name: EmRobot_TOP
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//
module EmRobot_TOP(
		input sysclk,
		input resetKey,
		//+++++++++++ Bottons +++++++++++++++++
		input [2:0] btns,
		//++++++++++  SWs  +++++++++++++++++++
		input  [17:0]SW,
		//+++++++++++ 7-SEGs ++++++++++++++++++
		output [6:0]hex0,
		output [6:0]hex1,
		output [6:0]hex2,
		output [6:0]hex3,
		output [6:0]hex4,
		output [6:0]hex5,
		output [6:0]hex6,
		output [6:0]hex7,
		//++++++++++ LEDR +++++++++++++++++++++
		output [17:0]LEDR,
		//++++++++++ LEDG +++++++++++++++++++++
		output [8:0] LEDG,
		//++++++++++ LCD 1602 +++++++++++++++++
		output [7:0] 	LCD_DATA,
		output 			LCD_RW,
		output 			LCD_RS,
		output			LCD_EN,
		output			LCD_BLON,
		output 			LCD_ON,
		//+++++++++ RS232 +++++++++++++++++++++
		input		       UART_RXD,
		output		    UART_TXD,
		output		    UART_CTS,
		input		       UART_RTS,
	   //++++++++++++ IR +++++++++++++++++++++++
		input 			IRDA_RXD
		);
//******************** FSM net Variables *************************************//
wire FSM_Trans;
wire FSM_FUSH;


//******************* Communicate Variables *******************************//
wire Com_rxFifoEmp;
wire Com_rxFifoFull;
wire Com_txFifoEmp;
wire Com_txFifoFull;
wire Com_OutputByte;
wire Com_OutputRequest;
wire [3:0] Com_Test;

//******************* Control Variables 	********************************//
wire Ctrl_CmdReady;
wire [7:0] Ctrl_Cmd;
wire Ctrl_CmdEmpty;
wire [31:0] Ctrl_SegValue;
wire Ctrl_Mode;
wire Ctrl_FifoFull;
wire CtrlWirelessFush;


//******************* inter modules control **************************//

SwDebounce sd(.clk(sysclk),.X(resetKey),.Z(reset)			);
SwDebounce sd1(.clk(sysclk),.X(btns[1]),.Z(BTN_FUSH));
SwDebounce sd2(.clk(sysclk),.X(btns[2]),.Z(BTN_STORE)			);
SwDebounce sd3(.clk(sysclk),.X(btns[0]),.Z(BTN_MODE)			);


//***************** Modules interfaces *******************************//
EmRobot_FSM fsm(
			.sysclk(sysclk),
			.rst(reset),
			//Input 
			.CmdEmpty(Ctrl_CmdEmpty),
			.FuncBtn(FSM_FUSH),
			//Output
			.Trans(FSM_Trans)
);

MUX1 mux3(
			.select(Ctrl_Mode),
			.dataOne(BTN_FUSH),
			.dataTwo(CtrlWirelessFush),
			.data(FSM_FUSH)
);

EmRobot_Control control(
					//******** De2-115 part **********//
					.Ctrl_sysclk(sysclk),
					.Ctrl_reset(reset),
					.Ctrl_sw(SW),
					.Ctrl_btns({BTN_STORE,BTN_FUSH,BTN_MODE}),
					.Ctrl_ird(IRDA_RXD),
					
					//Interfaces with other part *******//
					.Ctrl_ready(Ctrl_CmdReady),
					.Ctrl_command(Ctrl_Cmd),
					.Ctrl_empty(Ctrl_CmdEmpty),
					.Ctrl_request(Com_OutputRequest),
					.Ctrl_WirelessFush(CtrlWirelessFush),
					//******** Display parameter *******//
					.Ctrl_instanceCmd(Ctrl_SegValue),
					.Ctrl_Mode(Ctrl_Mode),
					.Ctrl_FifoFull(Ctrl_FifoFull)
);

EmRobot_Display display(
					.sysclk(sysclk),
					.reset(reset),
					//**********7 Seg *************//
					.SegValue(Ctrl_SegValue),
					.hex0(hex0),
					.hex1(hex1),
					.hex2(hex2),
					.hex3(hex3),
					.hex4(hex4),
					.hex5(hex5),
					.hex6(hex6),
					.hex7(hex7),
					//********* LEDG ***************//
					.LEDGValue({Ctrl_Mode,Com_Test,2'h00,Com_rxFifoEmp,Ctrl_FifoFull}),
					.LEDG(LEDG),
					//********* LEDR **************//
					.LEDRValue(18'h0),
					.LEDR(LEDR),
					//********* LCD ***************//
					.LCD_DATA(LCD_DATA),
					.LCD_RW(LCD_RW),
					.LCD_RS(LCD_RS),
					.LCD_EN(LCD_EN),
					.LCD_BLON(LCD_BLON),
					.LCD_ON(LCD_ON)
);

EmRobot_Communicate communicate(
								.sysclk(sysclk),
								.reset(reset),
								//************ FIFO Status ******************//
								.rxFifoEmp(Com_rxFifoEmp),
								.rxFifoFull(Com_rxFifoFull),
								.InputByte(Ctrl_Cmd),
								.txFifoEmp(Com_txFifoEmp),
								.txFifoFull(Com_txFifoFull),
								.OutputByte(Com_OutputByte),
								.OutputRequest(Com_OutputRequest),
								
								.RXFIFO_REQUEST(1'b0),
								.TXFIFO_WRITE(FSM_Trans),	
								//*********** Uart  			******************//
								.UART_RXD(UART_RXD),
								.UART_TXD(UART_TXD),
								.Com_Test(Com_Test)
);

endmodule