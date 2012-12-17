//=================================================================================//
//		File Name: EmRobot_Communicate
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//


module EmRobot_Communicate(
								sysclk,
								reset,
								//************ FIFO Status ******************//
								rxFifoEmp,
								rxFifoFull,
								InputByte,
								txFifoEmp,
								txFifoFull,
								OutputByte,
								
								RXFIFO_REQUEST,
								TXFIFO_WRITE,	
								OutputRequest,
								//*********** Uart  			******************//
								UART_RXD,
								UART_TXD,
								//**************  Test Signal *******************//
								Com_Test
);

input wire sysclk;
input wire reset;
input wire 	[7:0] InputByte;
output reg	[7:0] OutputByte;
input wire TXFIFO_WRITE;
input wire RXFIFO_REQUEST;

output wire rxFifoEmp;
output wire rxFifoFull;
output wire txFifoEmp;
output wire txFifoFull;
output wire OutputRequest;

input wire UART_RXD;
output wire UART_TXD;
output wire [3:0] Com_Test;


//*********************** Test Section *************************************//
//assign Com_Test = {try_to_send,is_receiving,UART_RXD,1'b0};


//***********************Uart relative net variables**************************//
wire [7:0] rxByte;
reg [7:0] txByte;
wire received;
reg  transmit;
wire is_transmitting;
wire is_receiving;
wire uart_error;

reg 	try_to_send = 0;
reg  	toSend = 0;
reg 	toReceive = 0;
reg [2:0] StopCount = 3'b000;
reg 	ReadFlag = 1;
//**************************FIFO net variables*********************************//
reg 	[7:0]rxInputData;
wire 	[7:0]rxOutputData;
reg 	rxWrite=0;
reg   rxRequest=0;

reg 	OutRequest = 0;



reg [7:0]txInputData;
wire [7:0]txOutputData;
reg txWrite=0;
reg txRequest=0;


assign OutputRequest = OutRequest;

always @(posedge sysclk)
	if(RXFIFO_REQUEST)
		begin
		rxRequest 		<= 1'b1;
		OutputByte		<= rxOutputData;
		end
	else
		rxRequest 		<= 1'b0;

always @(posedge sysclk)
	if(received)
		begin
		rxWrite 			<= 1'b1;
		rxInputData		<= rxByte;
		try_to_send 	<= 1'b1;
		end
	else
		rxWrite		<= 1'b0;


always @(posedge sysclk)
	if(TXFIFO_WRITE&&!toReceive)
		begin
		OutRequest  =1'b1;
		toReceive = 1;
		txWrite 	 = 0;
		end else if (toReceive)begin
		txInputData = InputByte;
		txWrite 		= 1'b1;
		toReceive   = 0;
		OutRequest  =1'b0;
		end
	else
		begin
		txWrite 		= 1'b0;
		OutRequest  = 1'b0;
		end

		
always@(posedge sysclk)		
		if(!txFifoEmp&&!is_transmitting&&!toSend)begin
			txRequest 	=1;
			toSend 		=1;
			StopCount   =0;
		end else if(toSend) begin
			txByte 		= txOutputData;
			transmit 	=1;
			txRequest   =0;
			StopCount   = StopCount +1'b1;
			if(StopCount == 3'b101)
			toSend  		=0;
		end else begin
			txRequest	= 0;
			transmit 	=0;
		end
		

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