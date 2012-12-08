module SegDrive(
  input         i_clk,
  input         i_rst_n,
  input  [31:0] i_data,                 // The data to be display 8 character ,each of them represented by hex  
   
  output wire[6:0]  o_seg,                  // The 7-seg's bit
  output wire[2:0]  o_dig                   // The 7-seg selector
);

reg [3:0]  Dig;
SEG7_LUT sl(
		.iDIG(Dig),
		.oSEG(o_seg)
); 
//++++++++++++++++++++++++++++++++++++++
// Divition of the Clock
//++++++++++++++++++++++++++++++++++++++
reg [16:0] cnt;                         // counter
 
always @ (posedge i_clk)
  if (i_rst_n)
    cnt <= 0;
  else
    cnt <= cnt + 1'b1;
 
wire seg7_clk = cnt[16];                // (2^17/50M = 2.6114)ms
//--------------------------------------
// Divition of the clock
//--------------------------------------
 
 
//++++++++++++++++++++++++++++++++++++++
// dynamic scan the 7-SEGs
//++++++++++++++++++++++++++++++++++++++
reg [2:0]  seg7_addr;                   // 7-seg address

 
always @ (posedge seg7_clk)
  if (i_rst_n)
    seg7_addr <= 0;
  else
    seg7_addr <= seg7_addr + 1'b1;     
//--------------------------------------
// address is created by above code
//--------------------------------------

assign o_dig = seg7_addr; 
//++++++++++++++++++++++++++++++++++++++
always@(*)
	begin
		case (seg7_addr)
		3'd0 : Dig= i_data[3:0];
		3'd1 : Dig= i_data[7:4];
		3'd2 : Dig= i_data[11:8];
		3'd3 : Dig= i_data[15:12];
		3'd4 : Dig= i_data[19:16];
		3'd5 : Dig= i_data[23:20];
		3'd6 : Dig= i_data[27:24];
		3'd7 : Dig= i_data[31:28];
		endcase
   end   // case code to use look-up table
 
endmodule