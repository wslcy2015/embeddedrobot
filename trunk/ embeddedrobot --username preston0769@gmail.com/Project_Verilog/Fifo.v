//=================================================================================//
//		File Name: FIFO
//   	Author 	: Yuantao Zhang
//		Version	: V0.1
//		Date Create: 7/Dec/2012
//================================================================================//

module FIFO(
				sysclk,
				reset,
				Write,
				InputData,
				Request,
            FifoEmp,
				FifoFull,
				OutputData);
parameter WIDTH=8;
parameter DEPTH=32;

input sysclk,reset,Request,Write;
input [WIDTH-1:0] InputData;
output [WIDTH-1:0] OutputData;
output FifoEmp,FifoFull;
reg [4:0] counter;

reg [WIDTH-1:0] OutputData;
reg [3:0] Request_ptr,Write_ptr;

reg [WIDTH-1:0] ram [DEPTH-1:0];

always @(negedge sysclk)
         if(reset)
                 begin
                    Request_ptr=0;
                    Write_ptr=0;
                    counter=0;
                    OutputData=0;
                end
   else // mod is same with the Request ptr,this means we need to stop;
                case({Request,Write})
                        2'b00: counter=counter;
                        2'b01: begin
                                 ram[Write_ptr]=InputData;    
                                 counter=counter+1'b1;
											Write_ptr=(Write_ptr==15)?0:Write_ptr+1'b1;
                                 end
                        2'b10: begin
                                 if(FifoEmp);
                                 else begin
                                 OutputData=ram[Request_ptr];
                                 counter=counter-1'b1;
                                 Request_ptr=(Request_ptr==15)?0:Request_ptr+1'b1;
                                 end
                                 end
                        2'b11: begin
                                if(counter==0)
											OutputData=InputData;
                                else
                                begin
                                 ram[Write_ptr]=InputData;
                                 OutputData=ram[Request_ptr];
                                 Write_ptr=(Write_ptr==15)?0:Write_ptr+1'b1;
                                 Request_ptr=(Request_ptr==15)?0:Request_ptr+1'b1;
                                end
                                end
                endcase
assign FifoEmp=(counter==0);
assign FifoFull=(counter==DEPTH);//I have changed from 15 to 16
endmodule
