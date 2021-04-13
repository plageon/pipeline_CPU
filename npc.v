`include "ctrl_encode_def.v"
`include "instruction_def.v"

module npc(
	input [31:0] rs_data,
	input [25:0] full_add,
    input [31:0] oldPC,
	input [31:0] extPC,
	input beq_zero,    
    input [1:0] PC_sel, 
	input pc_hold,  
    output reg [31:0] newPC
    );

	 always @(oldPC or extPC or beq_zero or PC_sel or pc_hold) begin
		if (beq_zero) begin
			newPC=extPC;//beq
		end
		else if (pc_hold) begin
			newPC=oldPC;//flush
		end
		else
		begin
			case(PC_sel)
				2'b00:	newPC = oldPC + 4;
				2'b01:			
					newPC = oldPC + 4;	
				2'b10: //jr
					newPC=rs_data;
				2'b11://j & jal
					newPC={oldPC[31:28],(full_add << 2)};
						
			endcase		
		end
	 end	 

endmodule

module PCctrl (
	input [31:0] ir,
	output reg [1:0] PC_sel
);
	always @(ir) begin
		if (ir[31:26]==`INSTR_RTYPE_OP && ir[5:0]==`INSTR_JR_FUNCT) begin
			PC_sel=2'b10;
		end
		else if (ir[31:26]==`INSTR_J_OP || ir[31:26]==`INSTR_JAL_OP) begin
			PC_sel=2'b11;
		end
		else begin
			PC_sel=2'b00;
		end
	end
	
endmodule

module pcext (
   input [31:0] oldPC,
   input [15:0] beq_imm,
   output reg [31:0] extPC
);
   always @(oldPC or beq_imm) begin
      //extPC = oldPC + 4 + {{14{beq_imm[15]}},beq_imm[15:0],2'b00};
	  extPC=oldPC+4+(beq_imm<<2);
   end
   
endmodule


