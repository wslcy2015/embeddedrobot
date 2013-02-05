//=================================================================================//
//		File Name: Ctrl_IRMode
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//

module IRMode(
			sysclk,
			reset,
			
			IRDA_RXD,
			IRData,
			FifoData,
			StoreCode,
			FushCode
);

input sysclk;
input reset;
input IRDA_RXD;

output wire [31:0] IRData;
output wire StoreCode;
output wire FushCode;
output wire [7:0] FifoData;	


wire clk50;
wire data_ready;


//++++++++++++++++++ IR_FSM Output ++++++++++++++++++++++++++++//



IR_FSM wfsm(
			.sysclk(sysclk),
			.reset(reset),
			.IRDATA(IRData),
			
			.wrcmd(StoreCode),
			.wrdata(FifoData),
			.fushcmd(FushCode)
);
pll1 u0(
		.inclk0(sysclk),
		//irda clock 50M 
		.c0(clk50),          
		.c1());

IR_RECEIVE u1(
					///clk 50MHz////
					.iCLK(clk50), 
					//reset          
					.iRST_n(!reset),        
					//IRDA code input
					.iIRDA(IRDA_RXD), 
					//read command      
					//.iREAD(data_read),
					//data ready      					
					.oDATA_READY(data_ready),
					//decoded data 32bit
					.oDATA(IRData)        
					);
					
endmodule
