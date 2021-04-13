module RegDst_mux(
		input [1:0] RegDst,
		input [20:16] Instrl_rs,
		input [15:11] Instrl_rt,
		output reg [4:0] Reg_rd
    );
	 
	always@(RegDst or Instrl_rs or Instrl_rt)begin
		case(RegDst)
			2'b00: Reg_rd = Instrl_rs[20:16];
			2'b01: Reg_rd = Instrl_rt[15:11];	
			2'b10: Reg_rd = 5'b11111;	
		endcase
	end
endmodule

module ALUSrc_muxA (
	input [31:0] grf_out,
	input [31:0] aluresult,
	input [31:0] memalu,
	input [1:0] forwardA,
	output reg [31:0] ALUSrc_mux_out 
);
	always @(grf_out or aluresult or memalu or forwardA) begin
		$display("A grf_out,aluresult, memalu,forwardA=%8X,%8X,%8X,%1X",grf_out,aluresult,memalu,forwardA);
		case (forwardA)
			2'b01:ALUSrc_mux_out=memalu;
			2'b10:ALUSrc_mux_out=aluresult; 
			2'b00: ALUSrc_mux_out=grf_out;
			
		endcase
		$display("Aout=%8X",ALUSrc_mux_out);
	end
	
endmodule

module ALUSrc_muxB(
	input [31:0] grf_out,
	input [31:0] extend_out,
	input [31:0] aluresult,
	input [31:0] memdata,
	input ALUSrc,
	input [1:0] forwardB,
	output reg [31:0] ALUSrc_mux_out
	);	
	
	always@(grf_out or extend_out or ALUSrc or aluresult or memdata or forwardB)begin
		if(ALUSrc == 1) ALUSrc_mux_out = extend_out;
		else begin
			$display("B grf_out,extend_out,aluresult, memdata,ALUSrc,forwardB=%8X,%8X,%8X,%8X,%1X,%1X",grf_out,extend_out,aluresult,memdata,ALUSrc,forwardB);
			if (forwardB==2'b01) begin
				ALUSrc_mux_out=memdata;
			end
			else if (forwardB==2'b10) begin
				ALUSrc_mux_out=aluresult;
			end
			else if (forwardB==2'b11) begin
				ALUSrc_mux_out=memdata;
			end
			else ALUSrc_mux_out = grf_out;
		end
	end
endmodule


module DatatoReg_mux(
	input [31:0] ALU_data,
	input [31:0] Mem_data,
	input [31:0] PC_address,
	input [1:0]  DatatoReg,
	output reg [31:0] DatatoReg_out
	);
	
	always@(ALU_data or Mem_data or DatatoReg)begin
		case(DatatoReg)
			2'b00: DatatoReg_out = ALU_data;
			2'b01: DatatoReg_out = Mem_data;	
			2'b10: DatatoReg_out = PC_address+4;		
		endcase
	end
	
	
endmodule 

module DatatoDM_mux (
	input [31:0] grf_out,
	input [31:0] wb_data,
	input [4:0] wb_rd,
	input [4:0] mem_rt,
	input regwrite,
	output reg [31:0] datatodm
);
	always @(grf_out or wb_data or wb_rd or mem_rt) begin
		if ((wb_rd==mem_rt && regwrite))begin
			datatodm=wb_data;
		end
		else datatodm=grf_out;
	end
	
endmodule
