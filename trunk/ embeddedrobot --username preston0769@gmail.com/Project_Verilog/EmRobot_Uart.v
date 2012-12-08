module EmRobot_Uart(
				clk,rst_n,
				rs232_rx,
				rs232_tx,
				rxbyte,
				txbyte,
				rxen,
				txen
				);

input clk;			// 50MHz主时钟
input rst_n;		//低电平复位信号

input rs232_rx;		// RS232接收数据信号
output rs232_tx;	//	RS232发送数据信号

input [7:0]	txbyte;
output [7:0]rxbyte;
input  rxen;
input  txen;

wire bps_start1,bps_start2;	//接收到数据后，波特率时钟启动信号置位
wire clk_bps1,clk_bps2;		// clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点 
wire[7:0] rx_data;	//接收数据寄存器，保存直至下一个数据来到
wire rx_int;		//接收数据中断信号,接收到数据期间始终为高电平

assign rxbyte = rx_data;

reg tx_Start;
wire [7:0] rx_byte;
reg [7:0] tx_byte;
wire [7:0] tx_data;
reg tx_fifo_rd,tx_fifo_wr,rx_fifo_rd,rx_fifo_wr;
wire tx_empty,tx_full,rx_empty,rx_full;



reg rx_int0,rx_int1,rx_int2;	//rx_int信号寄存器，捕捉下降沿滤波用
wire neg_rx_int;	// rx_int下降沿标志位
always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			rx_int0 <= 1'b0;
			rx_int1 <= 1'b0;
			rx_int2 <= 1'b0;
		end
	else begin
			rx_int0 <= rx_int;
			rx_int1 <= rx_int0;
			rx_int2 <= rx_int1;
		end
		
end

assign neg_rx_int =  ~rx_int1 & rx_int2;	//捕捉到下降沿后，neg_rx_int拉高保持一个主时钟周期

always @(posedge clk or negedge rst_n)
begin
		if(!rst_n) begin
			tx_Start <= 1'b0;
			tx_fifo_rd<=1'b0;
			tx_fifo_wr<=1'b0;
			rx_fifo_rd<=1'b0;
			rx_fifo_wr<=1'b0;
		end
		else begin
			if(!tx_empty)begin
				tx_fifo_rd <=1'b1;
				tx_Start <= 1'b1;
			end else begin
				tx_fifo_rd <= 1'b0;
				tx_Start <=1'b0;
				end
				
			if(neg_rx_int)
				rx_fifo_wr <=1'b1;
			else	
				rx_fifo_wr <=1'b0;
				
			if(neg_rx_int)
				begin
				rx_fifo_rd <= 1'b1;
				tx_fifo_wr <=1'b1;
				tx_byte <= rx_byte;
				end
			else
				begin
				rx_fifo_rd <= 1'b0;
				tx_fifo_wr <=1'b0;
				end
				
		end
end

//----------------------------------------------------
//下面的四个模块中，speed_rx和speed_tx是两个完全独立的硬件模块，可称之为逻辑复制
//（不是资源共享，和软件中的同一个子程序调用不能混为一谈）
////////////////////////////////////////////
speed_select		speed_rx(	
							.clk(clk),	//波特率选择模块
							.rst_n(rst_n),
							.bps_start(bps_start1),
							.clk_bps(clk_bps1)
						);

Uart_Rx		my_uart_rx(		
							.clk(clk),	//接收数据模块
							.rst_n(rst_n),
							.rs232_rx(rs232_rx),
							.rx_data(rx_data),
							.rx_int(rx_int),
							.clk_bps(clk_bps1),
							.bps_start(bps_start1)
						);

///////////////////////////////////////////						
speed_select		speed_tx(	
							.clk(clk),	//波特率选择模块
							.rst_n(rst_n),
							.bps_start(bps_start2),
							.clk_bps(clk_bps2)
						);

Uart_Tx			my_uart_tx(		
							.clk(clk),	//发送数据模块
							.rst_n(rst_n),
							.rx_data(tx_data),
							.tx_Start(tx_Start),
							.rs232_tx(rs232_tx),
							.clk_bps(clk_bps2),
							.bps_start(bps_start2)
						);
						
syn_fifo rx_fifo(
							.clk(clk)      , // Clock input
							.rst(rst_n)      , // Active high reset
							.wr_cs(1'b1)    , // Write chip select
							.rd_cs (1'b1)   , // Read chipe select
							.data_in(rx_data)  , // Data input
							.rd_en(rx_fifo_rd)    , // Read enable
							.wr_en(rx_fifo_wr)    , // Write Enable
							.data_out(rx_byte) , // Data Output
							.empty(rx_empty)    , // FIFO empty
							.full(rx_full)       // FIFO full
);
syn_fifo tx_fifo(
							.clk(clk)      , // Clock input
							.rst(rst_n)      , // Active high reset
							.wr_cs(1'b1)    , // Write chip select
							.rd_cs (1'b1)   , // Read chipe select
							.data_in(tx_byte)  , // Data input
							.rd_en(tx_fifo_rd)    , // Read enable
							.wr_en(tx_fifo_wr)    , // Write Enable
							.data_out(tx_data) , // Data Output
							.empty(tx_empty)    , // FIFO empty
							.full(tx_full)       // FIFO full
);

endmodule