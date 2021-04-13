
`include "ctrl_encode_def.v"

module alu(
	input [4:0] sa,
    input [31:0] A,//rs
    input [31:0] B,//rt or ext_out
    input [4:0] ALUOp,
    output reg [31:0] C,
	 output reg zero
    );
	

	 always @(A or B or ALUOp or sa ) begin
		case(ALUOp)
			`ALUOp_ADDU: begin 
				C = $unsigned(A) + $unsigned(B); //addu
				zero=0;
			end        
			`ALUOp_SUBU: begin 
				C = $unsigned(A) - $unsigned(B);         //subu
				zero=0;
			end
			`ALUOp_ADD: begin 
				C = A + B;
				zero=0;
			end			
			`ALUOp_SUB: begin 
				C = A - B;
				zero=0;
			end
			`ALUOp_AND: begin 
				C = A & B;
				zero=0;
			end
			`ALUOp_OR: begin 
				C = A | B;
				zero=0;
			end 
			`ALUOp_SLL: begin 
				C = B << sa;$display("sa=%1X",sa);
				zero=0;
			end
			`ALUOp_SRL: begin 
				C = B >> sa;$display("sa=%1X",sa);
				zero=0;
			end
			`ALUOp_SRA: begin 
				C = $signed(B) >>> sa;$display("sa=%1X",sa);
				zero=0;
			end
			`ALUOp_SLT: begin 
				C=($signed(A) < $signed(B))?1'b1:1'b0;
				zero=0;
			end
			`ALUOp_EQL: zero=(A==B)?1'b1:1'b0;//beq
			`ALUOp_BNE: zero=(A==B)?1'b0:1'b1;//bne
			`ALUOp_LUI: begin 
				C = B << 16;
				zero=0;
			end
			`ALUOp_DM:begin 
				C=B;
				zero=0;
			end
			default:begin
				C=0;
				zero=0;
			end
		endcase
	 end
	 


endmodule

module addrALU (
	input [31:0] rs,
	input [31:0] offset,
	output reg [31:0] addr
);
always @(rs or offset) begin
	addr=(rs+offset)>>2;
end
	
endmodule



