module mem_wb_ir (
   input         clk,
   input         rst,
   input         IRWr,    
   input [31:0] pc_in,      
   input [31:0] aluresult_in,
   input [31:0] memdata_in,
   input [4:0] swdst_in,
   input regwrite_in,
   input [1:0] memtoreg_in,

   output reg [31:0] pc,
   output reg [31:0] aluresult,
   output reg [31:0] memdata,
   output reg [4:0] swdst,
   output reg regwrite,
   output reg [1:0] memtoreg
);
               
   always @(posedge clk or posedge rst) begin
      if ( rst )
      begin 
         pc<=0;
         aluresult<=0;
         memdata<=0;
         swdst<=0;
         regwrite<=0;
         memtoreg<=0;
      end
      else if (IRWr)
      begin
         pc<=pc_in;
         aluresult<=aluresult_in;
         memdata<=memdata_in;
         swdst<=swdst_in;
         regwrite<=regwrite_in;
         memtoreg<=memtoreg_in;
      end
   end // end always
      
endmodule