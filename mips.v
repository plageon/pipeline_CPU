module mips( );
  reg clk, reset;
    	 
	 initial begin
	 $readmemh( "Test_Instr.txt", IM.IMem ) ; 
   $monitor("PC = 0x%8X, IR = 0x%8X", PC.oldpc, IM.Out );   

     	clk = 1 ;
      reset = 0 ;
      #5 reset = 1 ;
      #20 reset = 0 ;
 	
	end
	
   always #50 clk = ~clk;  

	wire if_id_rst;
	wire id_ex_rst;
	wire ex_mem_rst;
	wire mem_wb_rst;
	wire if_id_irwr;
	wire id_ex_irwr;
	wire ex_mem_irwr;
	wire mem_wb_irwr;
	 
	wire [31:0] old_PC;
	wire [31:0] new_PC;
	wire [31:0] jraddr;
	wire [31:0] if_ir,id_ir,ex_ir;
	wire [31:0] id_pc,ex_pc,mem_pc,wb_pc,ext_pc;
	wire [31:0] id_rs,ex_rs,id_rt,ex_rt;
	wire [31:0] ex_aluresult,mem_aluresult,wb_aluresult;
	wire [31:0] mem_memdata,wb_memdata;
	wire [4:0] id_swdst,ex_swdst,mem_swdst,wb_swdst;
	wire [4:0] id_aluctrl,ex_aluctrl;
	wire [1:0] id_regdst,ex_regdst;
	wire id_branch,ex_branch,mem_branch,id_memread,ex_memread,mem_memread,id_regwrite,
	ex_regwrite,mem_regwrite,wb_regwrite;
	wire [1:0] id_memtoreg,ex_memtoreg,mem_memtoreg,wb_memtoreg;

	wire beq_zero;
	wire [1:0]  PC_sel,PC_sel0;
	wire [1:0] forwardA,forwardB;
	wire [31:0] ALUSrc_outA,ALUSrc_outB;
	wire id_extop;
	wire [31:0] Data_to_Reg;
	wire [31:0] ext_out;
	wire [31:0] ex_addr,mem_addr;
	
	
	

	 




	im  IM(old_PC[11:2],if_ir);
	npc NPC(jraddr,if_ir[25:0],old_PC,ext_pc,ex_zero,PC_sel,pc_hold,new_PC);
	pc  PC(new_PC,clk,reset,old_PC);

	if_id_ir IF_ID_IR(clk,if_id_rst,if_id_irwr,old_PC,if_ir,id_pc,id_ir);
	id_ex_ir ID_EX_IR(clk,id_ex_rst,id_ex_irwr,
	id_pc,id_ir,id_rs,id_rt,id_swdst,id_regdst,id_aluctrl,id_alusrc,id_branch,id_memread,id_memwrite,id_regwrite,id_memtoreg,id_extop,
	ex_pc,ex_ir,ex_rs,ex_rt,ex_swdst,ex_regdst,ex_aluctrl,ex_alusrc,ex_branch,ex_memread,ex_memwrite,ex_regwrite,ex_memtoreg,ex_extop);
	ex_mem_ir EX_MEM_IR(clk,ex_mem_rst,ex_mem_irwr,ex_pc,ex_aluresult,ex_zero,ex_addr,ex_swdst,
	ex_branch,ex_memread,ex_memwrite,ex_regwrite,ex_memtoreg,mem_pc,mem_aluresult,mem_zero,mem_addr,mem_swdst,
	mem_branch,mem_memread,mem_memwrite,mem_regwrite,mem_memtoreg);
	mem_wb_ir MEM_WB_IR(clk,mem_wb_rst,mem_wb_irwr,mem_pc,mem_aluresult,mem_memdata,mem_swdst,
	mem_regwrite,mem_memtoreg,wb_pc,wb_aluresult,wb_memdata,wb_swdst,wb_regwrite,wb_memtoreg);

	forwarding FORWARDING(mem_memwrite,ex_memwrite,mem_memread,mem_regwrite,mem_swdst,ex_ir[25:21],ex_ir[20:16],wb_regwrite,
	wb_swdst,forwardA,forwardB);

	hazard HAZARD(clk,ex_memread,ex_ir[20:16],id_ir[25:21],id_ir[20:16],ex_zero,if_id_rst,id_ex_rst,ex_mem_rst,
	mem_wb_rst,if_id_irwr,id_ex_irwr,ex_mem_irwr,mem_wb_irwr,pc_hold);
	pcext PCEXT(ex_pc,ex_ir[15:0],ext_pc);
	 
	RegDst_mux REGDST(id_regdst,id_ir[20:16],id_ir[15:11],id_swdst);
	DatatoReg_mux DATATOREG(wb_aluresult,wb_memdata,wb_pc,wb_memtoreg,Data_to_Reg);
	gpr GRF(clk,reset,id_ir[25:21],id_ir[20:16],wb_swdst,Data_to_Reg,wb_regwrite,id_rs,
	id_rt,jraddr);

	PCctrl PCCTRL(if_ir,PC_sel);
    
	extend EXTEND(ex_ir[15:0],ex_extop,ext_out);
	ALUSrc_muxA ALUSRCA(ex_rs,mem_aluresult,wb_aluresult,forwardA,ALUSrc_outA);
	ALUSrc_muxB ALUSRCB(ex_rt,ext_out,mem_aluresult,wb_memdata,ex_alusrc,forwardB,ALUSrc_outB);
	alu ALU(ex_ir[10:6],ALUSrc_outA,ALUSrc_outB,ex_aluctrl,ex_aluresult,ex_zero);
	addrALU ADDRALU(ALUSrc_outA,ext_out,ex_addr);
	ctrl CTRL(id_ir[31:26],id_ir[5:0],id_regdst,id_alusrc,id_memread,id_regwrite,
	id_memwrite,id_memtoreg,PC_sel0,id_extop,id_aluctrl,id_branch);

	dm DM(mem_addr,mem_aluresult,mem_memwrite,mem_memread,clk,reset,mem_memdata);

endmodule

