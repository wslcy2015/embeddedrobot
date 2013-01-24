module IR_FSM(
			sysclk,
			reset,
			IRDATA,
			
			wrcmd,
			wrdata,
			fushcmd
);

input sysclk;
input reset;
input IRDATA;

output wrcmd;
output wrdata;
output fushcmd;

wire sysclk,reset;
wire [31:0] IRDATA;

reg wrcmd,fushcmd;
reg [7:0] wrdata;

wire [7:0] InputCmd;
reg  [7:0] TempCmd;

assign InputCmd = IRDATA[23:16];


//******************** CMD parameter ***********************//
reg [39:0] CmdList;
reg [39:0] CmdSend;
reg  [3:0] CmdCnt;
reg [3:0]  CntSet;
reg [1:0]   Forward;




//******************** STATE parameter *********************//
reg [2:0] state,nextstate;

parameter INIT  = 3'b000,
			 START = 3'b001,
			 PARA  = 3'b010,
			 CMD 	 = 3'b011,
			 TRANS = 3'b100,
			 SETUP = 3'b101;


//******************** Declare defined parameter *****************//
parameter UP 		= 8'h1b,
			 DOWN 	= 8'h1f,
			 LEFT 	= 8'h14,
			 RIGHT 	= 8'h18,
			 STOP  	= 8'h12,
			 A		   = 8'h0f,
			 B 		= 8'h13,
			 C 		= 8'h10;
			 
always@(posedge sysclk)
begin
	if(reset)
			state = INIT;
	else
			state = nextstate;
end


always@(posedge sysclk)
begin
	 case(state)
	 INIT:begin
			wrdata <= 8'h80;
			wrcmd  <= 1'b1;
			nextstate <= SETUP;
			CmdCnt <=4'h0;
			CmdList <=36'h0;
			TempCmd <=8'h00;
			fushcmd <= 1'b0;
			Forward <= 2'b00;
			end
	SETUP:begin
			wrdata <= 8'h80;
			wrcmd  <= 1'b1;
			nextstate <= START;
			CmdCnt <=4'h0;
			CmdList <=36'h0;
			TempCmd <=8'h00;
			fushcmd <= 1'b0;
			end
	START:begin		
			wrdata <=8'h00;
			wrcmd  <=1'b0;
			fushcmd <= 1'b0;
			if(|(TempCmd^InputCmd))
				begin
					nextstate <= PARA;
					TempCmd	 <= InputCmd;
					CmdCnt <= 4'h0;
					wrcmd <=1'b0;
				end
			else
					nextstate <=START;
			end
	PARA:begin
			wrcmd <=1'b0;
			fushcmd <=1'b0;
			case(TempCmd)
				UP:  begin
						CmdList[39:32] <= 8'h91;
						CmdList[31:0]    <= 32'h005f005f;
						nextstate	<= CMD;
						CntSet 		<= 4'h5;
						Forward 		<= 2'b01;
						end
				DOWN: begin
						CmdList[39:32] <= 8'h91;
						CmdList[31:0]    <= 32'hffa1ffa1;
						nextstate	<= CMD;
						CntSet 		<= 4'h5;
						Forward 		<= 2'b10;
						end
				LEFT: begin
						CmdList[39:32] <= 8'h91;
						if(Forward==2'b01)
							CmdList[31:0] <= 32'h00af005f;
						else if(Forward == 2'b10)
							CmdList[31:0] <= 32'hffa1ffeb;
						else
							CmdList[31:0] <= 32'hff800080;
						nextstate	<= CMD;
						CntSet 		<= 4'h5;
						end
				RIGHT:begin
						CmdList[39:32] <= 8'h91;
						if(Forward==2'b01)
							CmdList[31:0] <= 32'h005f00af;
						else if(Forward == 2'b10)
							CmdList[31:0] <= 32'hffbbffa1;
						else
							CmdList[31:0] <= 32'h0080ff80;
						nextstate	<= CMD;
						CntSet 		<= 4'h5;
						TempCmd		<= 8'h00;
						end
				STOP: begin
						CmdList[39:32] <= 8'h91;
						CmdList[31:0] 		<= 32'h0;
						nextstate	<= CMD;
						CntSet 		<= 4'h5;
						end
				A: begin
						CmdList[39:24] <= 16'h8080;
						CntSet 		<= 4'h2;
						nextstate 	<= CMD;
						end
				B: begin
						CmdList[39:24] <= 16'h8083;
						CntSet 		<= 4'h2;
						nextstate 	<= CMD;
						end
				C: begin
						CmdList[39:24] <= 16'h8084;
						CntSet 		<= 4'h2;
						nextstate 	<= CMD;
						end
				default:begin
						CmdList <= CmdList;
						nextstate	<= START;
						CntSet 		<= 4'h0;
						end
		endcase
		end
	CMD:begin
		wrcmd <=1'b0;
		CmdSend <= CmdList;
		CmdCnt <=4'h0;
		nextstate <= TRANS;
		end
	TRANS:
	  begin
		if(CmdCnt >= CntSet)
				begin
				nextstate <= START;
				fushcmd <=1'b1;
				wrcmd <=1'b0;
				end
		else begin
				CmdCnt <= CmdCnt + 1'b1;
				nextstate <= TRANS;
				wrdata <= CmdSend[39:32];
				CmdSend <= (CmdSend<<8);
				wrcmd  <= 1'b1;				
				end
	  end
	endcase
end
endmodule