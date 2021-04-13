module id_ex_ir (
               
   input         clk,
   input         rst,
   input         IRWr, 
   input [31:0] pc_in,
   input [31:0] instr_in,
   input [31:0] rs_in,
   input [31:0] rt_in,
   input [4:0] swdst_in,
   input [1:0] regdst_in,
   input [4:0] aluctrl_in,
   input alusrc_in,
   input branch_in,
   input memread_in,
   input memwrite_in,
   input regwrite_in,
   input [1:0] memtoreg_in, 
   input extop_in,

   output reg [31:0] pc,
   output reg [31:0] instr,
   output reg [31:0] rs,
   output reg [31:0] rt,
   output reg [4:0] swdst,
   output reg [1:0] regdst,
   output reg [4:0] aluctrl,
   output reg alusrc,
   output reg branch,
   output reg memread,
   output reg memwrite,
   output reg regwrite,
   output reg [1:0] memtoreg,
   output reg extop
);   
               
   always @(posedge clk ) begin
      if ( rst ) 
      begin
         pc <= 0;
         instr<=0;
         rs<=0;
         rt=0;
         swdst<=0;
         regdst<=0;
         aluctrl<=0;
         alusrc<=0;
         branch<=0;
         memread<=0;
         memwrite<=0;
         regwrite<=0;
         memtoreg<=0;
         extop<=0;
      end
      else if (IRWr)
      begin
         pc <= pc_in;
         instr<=instr_in;
         rs<=rs_in;
         rt<=rt_in;
         swdst<=swdst_in;
         regdst<=regdst_in;
         aluctrl<=aluctrl_in;
         alusrc<=alusrc_in;
         branch<=branch_in;
         memread<=memread_in;
         memwrite<=memwrite_in;
         regwrite<=regwrite_in;
         memtoreg<=memtoreg_in;
         extop<=extop_in;
      end
   end // end always
      
endmodule

