module if_id_ir (
               
   input         clk,
   input         rst,
   input         IRWr, 
   input  [31:0] pc_in,
   input  [31:0] instr_in,
   output reg [31:0] pc,
   output reg [31:0] instr
   
);
               
   always @(posedge clk) begin
      if ( rst ) 
         begin
            pc<=0;
            instr <= 0;
         end
      else if (IRWr)
         begin
            instr <= instr_in;
            pc <= pc_in;
         end
   end // end always
      
endmodule