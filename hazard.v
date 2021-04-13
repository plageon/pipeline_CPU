module hazard (
    input clk,
    input id_ex_memread,
    input [4:0] id_ex_registerrt,
    input [4:0] if_id_registerrs,
    input [4:0] if_id_registerrt,
    input beq_zero,
    
    output reg if_id_rst,
    output reg id_ex_rst,
    output reg ex_mem_rst,
    output reg mem_wb_rst,
    output reg if_id_irwr,
    output reg id_ex_irwr,
    output reg ex_mem_irwr,
    output reg mem_wb_irwr,
    output reg pc_hold
);
    

    always @(posedge clk or id_ex_memread or id_ex_registerrt or if_id_registerrs or if_id_registerrt or beq_zero) begin
        $display("id_ex_memread, id_ex_registerrt, if_id_registerrs, if_id_registerrt, beq_zero=%1X, %1X, %1X, %1X, %1X",id_ex_memread, id_ex_registerrt, if_id_registerrs, if_id_registerrt, beq_zero);
        if (id_ex_memread==1) begin
            if ((id_ex_registerrt==if_id_registerrs) || (id_ex_registerrt==if_id_registerrt))begin
                $display("block!");
                if_id_rst=0;
                id_ex_rst=0;
                ex_mem_rst=0;
                mem_wb_rst=0;
                if_id_irwr=0;
                id_ex_irwr=1;
                ex_mem_irwr=1;
                mem_wb_irwr=1;
                pc_hold=1;
            end
        end
        else if (beq_zero)begin
            $display("bed/bne");
            if_id_rst=1;
            id_ex_rst=1;
            ex_mem_rst=1;
            mem_wb_rst=0;
            if_id_irwr=1;
            id_ex_irwr=1;
            ex_mem_irwr=1;
            mem_wb_irwr=1;
            pc_hold=0;
        end
        else
        begin
            if_id_rst=0;
            id_ex_rst=0;
            ex_mem_rst=0;
            mem_wb_rst=0;
            if_id_irwr=1;
            id_ex_irwr=1;
            ex_mem_irwr=1;
            mem_wb_irwr=1;
            pc_hold=0;
        end
    end
    
endmodule