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
		input		       UART_RTS		
		);
//******************** FSM net Variables *************************************//
wire 			FSM_EN;
wire 	[7:0]	OpCode;
wire 	[4:0]	Commands;
wire 	[11:0] Value;


//******************** Output relative Display variables **********************//
wire 	DisplayEn;
assign 		LEDR[16:5] 	= Value;
assign 		LEDG			= OpCode;
assign		Commands 	= SW[4:0];

//***********************Uart relative net variables**************************//
reg 	[7:0] txByte;
wire	[7:0] rxByte;

wire received;
reg  transmit;
wire is_transmitting;
wire is_receiving;
wire uart_error;

reg 	try_to_send;
reg  	toSend;
reg 	ReadFlag;
//**************************FIFO net variables*********************************//
wire TXFIFO_WRITE;
wire rxFifoEmp;
wire rxFifoFull;
reg 	[7:0]rxInputData;
wire [7:0]rxOutputData;
reg rxWrite=0;
reg rxRequest=0;

wire txFifoEmp;
wire txFifoFull;
reg [7:0]txInputData;
wire [7:0]txOutputData;
reg txWrite=0;
reg txRequest=0;

//******************* inter modules control **************************//

always @(posedge sysclk)
begin
	if(TXFIFO_WRITE)
		begin
		txWrite 		<= 1'b1;
		txInputData <= OpCode;
		end
	else
		txWrite 		<= 1'b0;
end
always @(posedge sysclk) 
begin
	if(reset) begin
		txByte 		<= 8'h00;
		transmit 	<= 0;
		try_to_send <= 0;
		toSend 		<= 0;
		ReadFlag 	<= 1;
	end else begin 
		if(received) 
		begin	
			try_to_send <= 1;
		end
		if(!txFifoEmp&&ReadFlag)begin
			txRequest 	<=1;
			txByte 		<= txOutputData;
			toSend		<=1;
		end else begin
			txRequest	<= 0;
		end
		if(!is_transmitting && toSend)begin
			ReadFlag		<=0;
			transmit 	<=1;
			toSend 		<=0;
		end else begin
			ReadFlag 	<=1;
			transmit 	<=0;
			end
	end
end 
SwDebounce sd(
		.clk(sysclk),
		.X(resetKey),
		.Z(reset)		
);
SwDebounce sd1(
		.clk(sysclk),
		.X(btns[1]),
		.Z(TXFIFO_WRITE)		
);
SwDebounce sd2(
		.clk(sysclk),
		.X(btns[2]),
		.Z(FSM_EN)		
);




EmRobot_FSM fsm(
			.sysclk(sysclk),
			.rst(reset),
			.CommandEn(FSM_EN),
			.Cmmds(Commands),
			
			.OpCode(OpCode),
			.SegValue(Value),
			.FsmStatus(LEDR[17]),
			.DisplayEn(DisplayEn)
);
EmRobot_SegControl em_segcontrol(
		.CLOCK_50(sysclk),
		.KEY(reset),
		.Enable(DisplayEn),
		.Value(Value),
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
/*EmRobot_Uart(
				.clk(sysclk),
				.rst_n(reset),
				.rs232_rx(UART_RXD),
				.rs232_tx(UART_TXD),
				.rxbyte(rxbyte),
				.txbyte(rxbyte),
				.rxen(readEn),
				.txen(writeEn)
				);*/
FIFO rx_fifo(
				.sysclk(sysclk),
				.reset(reset),
				.Write(rxWrite),
				.InputData(rxInputData),
				.Request(rxRequest),
            .FifoEmp(rxFifoEmp),
				.FifoFull(rxFifoFull),
				.OutputData(rxOutputData)
);
FIFO tx_fifo(
				.sysclk(sysclk),
				.reset(reset),
				.Write(txWrite),
				.InputData(txInputData),
				.Request(txRequest),
            .FifoEmp(txFifoEmp),
				.FifoFull(txFifoFull),
				.OutputData(txOutputData)
);
				
UART uart(
    .clk(sysclk), // The master clock for this module
    .rst(reset), // Synchronous reset.
    .rx(UART_RXD), // Incoming serial line
    .tx(UART_TXD), // Outgoing serial line
    .transmit(transmit), // Signal to transmit
    .tx_byte(txByte), // Byte to transmit
    .received(received), // Indicated that a byte has been received.
    .rx_byte(rxByte), // Byte received
    .is_receiving(is_receiving), // Low when receive line is idle.
    .is_transmitting(is_transmitting), // Low when transmit line is idle.
    .recv_error(uart_error) // Indicates error in receiving packet.
    );
endmodule