module dm(
    input [31:0] addr,
    input [31:0] data_in,
   
	input MemWrite,
    input MemRead,
    input clk,
	input reset,
    output reg [31:0] data_out
    );
	 
	 reg [31:0] DMem[1023:0];
	
 always@(negedge clk)
	begin
		if(MemWrite)
			DMem[addr] <= data_in;
			$display("addr=%8X",addr);//addr to DM
        	$display("din=%8X",data_in);//data to DM
        	$display("Mem[00-07]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X",DMem[0],DMem[1],DMem[2],DMem[3],DMem[4],DMem[5],DMem[6],DMem[7]);
		if(MemRead)begin
			data_out = DMem[addr];
		end
	end	
	

endmodule
