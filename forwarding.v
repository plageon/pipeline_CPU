module forwarding(
    input mem_wb_memwrite,
    input mem_wb_memread,
    input id_ex_memwrite,
    input ex_mem_regwrite,
    input [4:0] ex_mem_registerrd,
    input [4:0] id_ex_registerrs,
    input [4:0] id_ex_registerrt,

    input mem_wb_regwrite,
    input [4:0] mem_wb_registerrd,

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
    );

    always @(ex_mem_registerrd or mem_wb_registerrd or id_ex_registerrs or id_ex_registerrt or ex_mem_regwrite or mem_wb_regwrite or id_ex_memwrite or mem_wb_memread or mem_wb_memwrite) begin
        $display("ex_mem_registerrd mem_wb_registerrd id_ex_registerrs id_ex_registerrt ex_mem_regwrite,mem_wb_regwrite=%1X, %1X, %1X, %1X,%1X,%1X",ex_mem_registerrd, mem_wb_registerrd , id_ex_registerrs , id_ex_registerrt , ex_mem_regwrite,mem_wb_regwrite );
        if ((ex_mem_regwrite == 1) && (ex_mem_registerrd != 0) &&(ex_mem_registerrd==id_ex_registerrs)) begin
            forwardA = 2'b10;
        end
        else if ((mem_wb_regwrite == 1) && (mem_wb_registerrd != 0) && (mem_wb_registerrd==id_ex_registerrs)) begin
            forwardA = 2'b01;
        end
        else forwardA=2'b00;

        if ((ex_mem_regwrite == 1) && (ex_mem_registerrd != 0)&&(ex_mem_registerrd==id_ex_registerrt)) begin
            forwardB = 2'b10;
        end
        else if ((mem_wb_regwrite == 1) && (mem_wb_registerrd != 0) && (mem_wb_registerrd==id_ex_registerrt)) begin
            if (mem_wb_memwrite==1 && mem_wb_memread==0 && id_ex_memwrite==1 ) begin
                forwardB=2'b11;
            end
            else forwardB = 2'b01;
        end
        else begin
            forwardB = 2'b00;
        end
        $display("forwardA forwardB=%1X,%1X",forwardA,forwardB);
    end

endmodule