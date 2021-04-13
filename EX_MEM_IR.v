module ex_mem_ir (
   input         clk,
   input         rst,
   input         IRWr, 
   input [31:0] ext_pc_in,
   input [31:0] aluresult_in,
   input zero_in,
   input [31:0] rt_in,
   input [4:0] swdst_in,
   input branch_in,
   input memread_in,
   input memwrite_in,
   input regwrite_in,
   input [1:0] memtoreg_in,

   output reg [31:0] ext_pc,
   output reg [31:0] aluresult,
   output reg zero,
   output reg [31:0] rt,
   output reg [4:0] swdst,
   output reg branch,
   output reg memread,
   output reg memwrite,
   output reg regwrite,
   output reg [1:0] memtoreg
);
               
   always @(posedge clk) begin
      if ( rst )
      begin 
         ext_pc<=0;
         aluresult<=0;
         zero<=0;
         rt<=0;
         swdst<=0;
         branch<=0;
         memread<=0;
         memwrite<=0;
         regwrite<=0;
         memtoreg<=0;
      end
      else if (IRWr)
      begin
         ext_pc<=ext_pc_in;
         aluresult<=aluresult_in;
         zero<=zero_in;
         rt<=rt_in;
         swdst<=swdst_in;
         branch<=branch_in;
         memread<=memread_in;
         memwrite<=memwrite_in;
         regwrite<=regwrite_in;
         memtoreg<=memtoreg_in;
      end
   end // end always
      
endmodule