module Control_FSM(
				// De2 board part ***************//
				sysclk,
				reset,
				btns,
				mode,
				
				// Interface part with other ****//
				fush,
				storecmd,
				showDisplay
);

input wire 			sysclk;
input wire 			reset;
input wire [2:0]	btns;
input wire 			mode;

output reg  		fush;
output reg  		storecmd;
output reg [1:0]	showDisplay;

//************** parameter *****************//
reg [1:0] State;
reg [1:0] NextState;

parameter INIT = 2'b00,
			 CMD  = 2'b01,
			 PARA = 2'b10,
			 DONE = 2'b11;
			 
always@(posedge sysclk)
begin 	
	if(reset)
		State <= INIT;
	else
		State <= NextState;
end

always@(posedge sysclk)
begin
	case(State)
		INIT:begin
				Storecmd  <= 1'b0;
				fush 		 <= 1'b0;
				showDisplay <= 2'b00;
			  if(mode)
				NextState <= INIT;
			  else
				NextState <= CMD;
				end
		CMD:begin
				showDisplay <=2'b01;
				if(btns[2])
				begin
				NextState <= PARA;
				Storecmd  <= 1'b1;
				end
				else
				Storecmd  <= 1'b0;
				NextState <= CMD;
		PARA:begin
					showDisplay <=2'b10;
				if(btns[1])
					storecmd  <=1'b0;
					NextState <= DONE;
				else if(btns[2])
				begin
					storecmd <= 1'b1;
					NextState <= PARA;
				end
				else begin
					NextState <=PARA;
					storecmd <= 1'b0;
				end
				end
		DONE:begin
					showDisplay <= 1'b00;
					fush 			<= 1'b1;
					NextState   <= INIT;
				end
		endcase
end
				