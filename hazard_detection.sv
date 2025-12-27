module hazard_detection (
    input logic clk, reset_n,

    input logic [6:0]  instruction_EX,

    input logic [4:0]  rs1_addr_ID,
    input logic [4:0]  rs2_addr_ID,

    input logic        pc_sel_EX,

    input logic [4:0]  i_rd_addr_EX,
    input logic [4:0]  i_rd_addr_MEM,
    input logic [4:0]  i_rd_addr_WB, 

    input logic        i_RegWen_EX,
    input logic        i_RegWen_MEM,
    input logic        i_RegWen_WB,

    output logic       o_stall_IF,
    output logic       o_flush_IF,
    output logic       o_flush_ID,
    output logic       o_stall_ID,
    output logic       o_flush_EX,
    output logic       o_stall_EX,
    output logic       o_flush_MEM,
    output logic       o_stall_MEM
);

    /* -------------------------------------------------- */
    /* Jump decode (opcode only, EX stage) */
    /* -------------------------------------------------- */
    logic jmp_opcode;

    assign jmp_opcode =
        (instruction_EX == 7'b1101111) ||   // JAL
        (instruction_EX == 7'b1100111);     // JALR

    /* -------------------------------------------------- */
    /* Register != x0 checks */
    /* -------------------------------------------------- */
    logic ex_valid, mem_valid, wb_valid;

    assign ex_valid  = (i_rd_addr_EX  != 5'd0) && i_RegWen_EX;
    assign mem_valid = (i_rd_addr_MEM != 5'd0) && i_RegWen_MEM;
    assign wb_valid  = (i_rd_addr_WB  != 5'd0) && i_RegWen_WB;

    /* -------------------------------------------------- */
    /* Data hazard detection (NO forwarding) */
    /* Consumer is ALWAYS ID stage */
    /* -------------------------------------------------- */
    logic hazard_EX, hazard_MEM, hazard_WB;

    assign hazard_EX =
        ex_valid &&
        ((rs1_addr_ID == i_rd_addr_EX) ||
         (rs2_addr_ID == i_rd_addr_EX));

    assign hazard_MEM =
        mem_valid &&
        ((rs1_addr_ID == i_rd_addr_MEM) ||
         (rs2_addr_ID == i_rd_addr_MEM));

    assign hazard_WB =
        wb_valid &&
        ((rs1_addr_ID == i_rd_addr_WB) ||
         (rs2_addr_ID == i_rd_addr_WB));

    logic stall;
    assign stall = hazard_EX | hazard_MEM | hazard_WB;

    /* -------------------------------------------------- */
    /* Control logic */
    /* FIXED stall boundary:
       - stall IF + ID
       - bubble EX
       - MEM / WB always flow
    */
    /* -------------------------------------------------- */
    always_comb begin
        /* defaults */
        o_stall_IF  = 1'b0;
        o_flush_IF  = 1'b0;
        o_flush_ID  = 1'b0;
        o_stall_ID  = 1'b0;
        o_flush_EX  = 1'b0;
        o_stall_EX  = 1'b0;
        o_flush_MEM = 1'b0;
        o_stall_MEM = 1'b0;

        /* control hazard has priority */
        if (pc_sel_EX || jmp_opcode) begin
            o_flush_ID = 1'b1;
            o_flush_EX = 1'b1;
        end
        /* data hazard */
        else if (stall) begin
            o_stall_IF = 1'b1;
            o_stall_ID = 1'b1;
            o_flush_EX = 1'b1;
        end
    end

endmodule


/*
module hazard_detection (
    input logic clk, reset_n,
    input logic [6:0]  instruction_EX,                                 // check the instruction in MEM stage is load | if load then hazard
    //input logic [6:0]  instruction_MEM,
    //input logic [6:0]  instruction_WB,
    input logic [4:0]  rs1_addr_ID,
    input logic [4:0]  rs2_addr_ID,
    input logic        pc_sel_EX,
    input logic [4:0]  i_rd_addr_EX,
    //input logic [4:0]  i_rd_addr_WB_2,
    input logic [4:0]  i_rd_addr_MEM,
    input logic [4:0]  i_rd_addr_WB, 
    input logic         i_RegWen_EX,
    input logic        i_RegWen_MEM,
    input logic        i_RegWen_WB,
    //input logic        i_RegWen_WB_2,
    output logic       o_stall_IF   ,
    output logic       o_flush_IF   ,
    output logic       o_flush_ID   , 
    output logic       o_stall_ID   ,
    output logic       o_flush_EX   ,
    output logic       o_stall_EX   ,
    output logic       o_flush_MEM  ,
    output logic       o_stall_MEM 

    //output logic [1:0] o_foward_A, 
    //output logic [1:0] o_foward_B
);
//handle the foward branch || flush when branch



logic WB_check;
logic MEM_check;
logic EX_check;
assign WB_check = i_rd_addr_WB[4] | i_rd_addr_WB[3] | i_rd_addr_WB[2] | i_rd_addr_WB[1] | i_rd_addr_WB[0];      // make sure not write back to x0
assign MEM_check =i_rd_addr_MEM[4]| i_rd_addr_MEM[3]| i_rd_addr_MEM[2]| i_rd_addr_MEM[1]| i_rd_addr_MEM[0];// make sure not write back to x0
assign EX_check = i_rd_addr_EX[4] | i_rd_addr_EX[3] | i_rd_addr_EX[2] | i_rd_addr_EX[1] | i_rd_addr_EX[0];

////////////////////////////////////////////////////////stall logic at EXECUTE//////////////////////////////////////////////
logic compare_rs1_EX, compare_rs2_EX;


assign compare_rs1_EX = rs1_addr_ID[4] ^ i_rd_addr_EX[4] | rs1_addr_ID[3] ^ i_rd_addr_EX[3] | rs1_addr_ID[2] ^ i_rd_addr_EX[2] | rs1_addr_ID[1] ^ i_rd_addr_EX[1] | rs1_addr_ID[0] ^ i_rd_addr_EX[0] ;
assign compare_rs2_EX = rs2_addr_ID[4] ^ i_rd_addr_EX[4] | rs2_addr_ID[3] ^ i_rd_addr_EX[3] | rs2_addr_ID[2] ^ i_rd_addr_EX[2] | rs2_addr_ID[1] ^ i_rd_addr_EX[1] | rs2_addr_ID[0] ^ i_rd_addr_EX[0] ; 

logic stall_signal_EX;             //stall flag when got a match rs

assign stall_signal_EX = (!compare_rs1_EX | !compare_rs2_EX) & i_RegWen_EX & EX_check;

logic [2:0] stall_pipe_EX;

always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        stall_pipe_EX <= 3'b000;
    else
        stall_pipe_EX <= {stall_pipe_EX[1:0], stall_signal_EX};
end

logic stall_EX = |stall_pipe_EX;  // OR of all bits



////////////////////////////////////////////////////////stall logic at MEM//////////////////////////////////////////////
logic compare_rs1_MEM, compare_rs2_MEM;


assign compare_rs1_MEM = rs1_addr_ID[4] ^ i_rd_addr_MEM[4] | rs1_addr_ID[3] ^ i_rd_addr_MEM[3] | rs1_addr_ID[2] ^ i_rd_addr_MEM[2] | rs1_addr_ID[1] ^ i_rd_addr_MEM[1] | rs1_addr_ID[0] ^ i_rd_addr_MEM[0] ;
assign compare_rs2_MEM = rs2_addr_ID[4] ^ i_rd_addr_MEM[4] | rs2_addr_ID[3] ^ i_rd_addr_MEM[3] | rs2_addr_ID[2] ^ i_rd_addr_MEM[2] | rs2_addr_ID[1] ^ i_rd_addr_MEM[1] | rs2_addr_ID[0] ^ i_rd_addr_MEM[0] ; 

logic stall_signal_MEM;             //stall flag when got a match rs

assign stall_signal_MEM = (!compare_rs1_MEM | !compare_rs2_MEM) & i_RegWen_MEM & MEM_check;

logic [1:0] stall_pipe_MEM;

always_ff @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        stall_pipe_MEM <= 2'b00;
    else
        stall_pipe_MEM <= {stall_pipe_MEM[0], stall_signal_MEM};
end

logic stall_MEM = |stall_pipe_MEM;  // OR of all bits


////////////////////////////////////////////////////////stall logic at WB//////////////////////////////////////////////
logic compare_rs1_WB, compare_rs2_WB;


assign compare_rs1_WB = rs1_addr_ID[4] ^ i_rd_addr_WB[4] | rs1_addr_ID[3] ^ i_rd_addr_WB[3] | rs1_addr_ID[2] ^ i_rd_addr_WB[2] | rs1_addr_ID[1] ^ i_rd_addr_WB[1] | rs1_addr_ID[0] ^ i_rd_addr_WB[0] ;
assign compare_rs2_WB = rs2_addr_ID[4] ^ i_rd_addr_WB[4] | rs2_addr_ID[3] ^ i_rd_addr_WB[3] | rs2_addr_ID[2] ^ i_rd_addr_WB[2] | rs2_addr_ID[1] ^ i_rd_addr_WB[1] | rs2_addr_ID[0] ^ i_rd_addr_WB[0] ; 

logic stall_signal_WB;             //stall flag when got a match rs

assign stall_signal_WB = (!compare_rs1_WB | !compare_rs2_WB) & i_RegWen_WB & WB_check;


////////////////////////////////////////////////////////flush logic when branch or jmp taken
logic jmp_opcode;
assign jmp_opcode = instruction_EX[6] & instruction_EX[5] & !instruction_EX[4]  & instruction_EX[2] & instruction_EX[1] & instruction_EX[0];


always_comb begin
if (stall_EX) begin
            o_stall_IF  = 1'b1;                 ////////////////////////////////////////////
            o_flush_IF  = 1'b0;
            o_flush_ID  = 1'b0;
            o_stall_ID  = 1'b1;                 ////////////////////////////////////////////
            o_flush_EX  = 1'b1;                 ////////////////////////////////////////////
            o_stall_EX  = 1'b0;
            o_flush_MEM = 1'b0;
            o_stall_MEM = 1'b0;
        end else
if (stall_MEM) begin
            o_stall_IF  = 1'b1;                 ////////////////////////////////////////////
            o_flush_IF  = 1'b0;
            o_flush_ID  = 1'b0;
            o_stall_ID  = 1'b1;                 ////////////////////////////////////////////
            o_flush_EX  = 1'b0;                 
            o_stall_EX  = 1'b1;                 ////////////////////////////////////////////
            o_flush_MEM = 1'b1;                 ////////////////////////////////////////////
            o_stall_MEM = 1'b0;
        end else
if (stall_signal_WB) begin
            o_stall_IF  = 1'b1;                 ////////////////////////////////////////////
            o_flush_IF  = 1'b0;
            o_flush_ID  = 1'b0;
            o_stall_ID  = 1'b1;                 ////////////////////////////////////////////
            o_flush_EX  = 1'b0;                             
            o_stall_EX  = 1'b1;                /////////////////////////////////////////////
            o_flush_MEM = 1'b0;                 
            o_stall_MEM = 1'b1;                ///////////////////////////////////////////////
            end else 
if (pc_sel_EX |jmp_opcode ) begin
            o_stall_IF  = 1'b0;                
            o_flush_IF  = 1'b0;                                     //////////////////////////////////////////
            o_flush_ID  = 1'b1;
            o_stall_ID  = 1'b0;                
            o_flush_EX  = 1'b1;                                     ////////////////////////////////////////                             
            o_stall_EX  = 1'b0;                
            o_flush_MEM = 1'b0;                 
            o_stall_MEM = 1'b0;                
        end else begin
            o_stall_IF  = 1'b0;
            o_flush_IF  = 1'b0;
            o_flush_ID  = 1'b0;
            o_stall_ID  = 1'b0;
            o_flush_EX  = 1'b0;
            o_stall_EX  = 1'b0;
            o_flush_MEM = 1'b0;
            o_stall_MEM = 1'b0;
    end
end 

endmodule

*/






