module Even_division(clk,rst,count,clk_odd);
input        clk,rst;
output       clk_odd;
output[3:0] count;
reg          clk_odd;
reg[3:0]     count;
parameter    N = 6;
  
    always @ (posedge clk)
      if(! rst) 
        begin
          count <= 1'b0;
          clk_odd <= 1'b0;
        end
      else       
        if ( count < N/2-1) 
          begin          
            count <= count + 1'b1;            
          end
        else
          begin        
            count <= 1'b0;
            clk_odd <= ~clk_odd;      
          end
endmodule