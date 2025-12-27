//----------------------------------------------------------------------//
//  Design Note
//----------------------------------------------------------------------//
//  1. Instruction Memory Depth (IMEM): At least 8  kiB to run the "isa_1b.hex" or "isa_4b.hex"
//  2. Data        Memory Depth (DMEM): At least 64 kiB (0x0000_0000 - 0x0000_FFFF)
//  3. IMEM and DMEM are separate memory blocks.


module pipelined (
    input  logic         i_clk     ,
    input  logic         i_reset   ,
    // Input peripherals
    input  logic [31:0]  i_io_sw   ,
    // Output peripherals
    output logic [31:0]  o_io_lcd  ,
    output logic [31:0]  o_io_ledr ,
    output logic [31:0]  o_io_ledg ,
    output logic [ 6:0]  o_io_hex0 ,
    output logic [ 6:0]  o_io_hex1 ,
    output logic [ 6:0]  o_io_hex2 ,
    output logic [ 6:0]  o_io_hex3 ,
    output logic [ 6:0]  o_io_hex4 ,
    output logic [ 6:0]  o_io_hex5 ,
    output logic [ 6:0]  o_io_hex6 ,
    output logic [ 6:0]  o_io_hex7 ,
    // Debug
    output logic [31:0]  o_pc_debug,
    output logic         o_insn_vld,
    output logic         o_ctrl    ,
    output logic         o_mispred
);


// Top level file of your milestone 3
// Write your code here
logic [31:0] i_pc_IF, o_pc_IF;
logic [31:0] i_pc_plus4_IF, o_pc_plus4_IF;
logic stall_IF;

logic [31:0] i_instruction_IF, o_instruction_IF;

logic o_PC_sel_EX;
logic [31:0] i_mux_out_EX;
logic o_insn_vld_ID;
logic o_insn_vld_IF;

logic [31:0] i_pc;
logic [31:0] o_pc;

assign i_pc = stall_IF ?i_pc_IF :  o_PC_sel_EX ? i_mux_out_EX : o_pc ; 

PC PC_inst
        (   .i_clk(i_clk), 
            .i_rst(i_reset), 
            .stall(stall_IF), 
            .i_pc(i_pc),
            .o_pc(o_pc)
            );


logic flush_ID;

always_ff @(posedge i_clk or negedge i_reset) begin
    if (!i_reset) begin
        i_pc_IF <=32'd0;
    end else begin
        i_pc_IF <= stall_IF ? i_pc_IF :   i_pc;
    end 
end 



IF_reg IF_reg_inst (
                .clk(i_clk),
                .reset(i_reset),
                .stall(stall_IF),                                                           //stall at IF stage
                .i_pc_IF(i_pc_IF),                              
                .flush(flush_ID),                                                           // change from flush_ID to flush IF (flush at IF stage)          
                .o_insn_vld_IF (o_insn_vld_IF),                                             // flush going into ID stage
                .PCsel(o_PC_sel_EX),
                .mux_out(i_mux_out_EX),
                .i_instruction_IF(i_instruction_IF), 
                .o_instruction_IF(o_instruction_IF),
                .i_pc_plus4_IF(i_pc_plus4_IF),
                .o_pc_plus4_IF(o_pc_plus4_IF),
                .o_pc_IF(o_pc_IF)
);

imem #(.MEM_FILE("/home/yellow/ctmt_cttt_11/workspace_3/02_test/isa_4b.hex"))
imem_inst  
            (.address    (i_pc[12:2]),
            .clock      (i_clk), 
            .flush      (1'b0),
            .reset      (i_reset),
            .q(i_instruction_IF)
);
///////////////////////////////////DECODE///////////////////////////
logic [31:0]                   o_instruction_ID;
logic       i_RegWen_ID      , o_RegWen_ID     ; 
logic       i_Asel_ID        , o_Asel_ID       ; 
logic       i_Bsel_ID        , o_Bsel_ID       ; 
logic       i_MemRW_ID       , o_MemRW_ID      ;
logic [3:0] i_ALU_sel_ID     , o_ALU_sel_ID    ;
logic       i_br_un_ID       , o_br_un_ID      ;                   //select signed/unsigned for branch
logic [1:0] i_wb_select_ID   , o_wb_select_ID  ;
controller_unit controller_unit_inst(   
                                    .instr_data (o_instruction_IF),
                                    .RegWen     (i_RegWen_ID), 
                                    .Asel       (i_Asel_ID), 
                                    .Bsel       (i_Bsel_ID), 
                                    .MemRW      (i_MemRW_ID),
                                    .ALU_sel    (i_ALU_sel_ID),
                                    .br_un      (i_br_un_ID),               //select signed/unsigned for branch
                                    .wb_select  (i_wb_select_ID)
                                    ); // write back select

logic [31:0] i_rs1_data_ID , o_rs1_data_ID;
logic [31:0] i_rs2_data_ID , o_rs2_data_ID;
logic [31:0] mem_foward_EX, wb_foward_EX;
logic [31:0] o_instruction_MEM  ;
logic        o_RegWen_MEM       ;
regfile reg_file_inst (
                                    .i_clk     (i_clk)                   , 
                                    .i_rst     (i_reset)                 ,
                                    .i_rs1_addr(o_instruction_IF[19:15]) , 
                                    .i_rs2_addr(o_instruction_IF[24:20]) , 
                                    .i_rd_addr (o_instruction_MEM[11:7]) ,             //this must comes from the wb stage    
                                    .i_rd_data (wb_foward_EX)            ,             //this must comes from the wb stage         
                                    .i_rd_wren (o_RegWen_MEM)            ,             //this must comes from the wb stage              
                                    .o_rs1_data(i_rs1_data_ID)           , 
                                    .o_rs2_data(i_rs2_data_ID)
                                    );

logic [31:0] i_imm_ID;      
imm_gen imm_gen_inst(
                    .i_imm(o_instruction_IF[31:7]),
                    .i_sel(o_instruction_IF[6:0]),            // opcode
                    .o_imm(i_imm_ID)
                    );


logic stall_ID;
logic [4:0] i_rs1_addr_ID;
logic [4:0] i_rs2_addr_ID;
logic        o_ctrl_ID          ;
logic [31:0] o_imm_ID           ;
logic [31:0] o_pc_plus4_ID      ;          
logic [31:0] o_pc_ID            ;
logic [31:0] o_instruction      ;

logic [4:0]  o_rs1_addr_ID      ;
logic [4:0]  o_rs2_addr_ID      ;

logic flush_EX;
ID_reg ID_reg_inst(
                .clk             (i_clk),
                .reset           (i_reset),      
                .flush           (flush_EX),                        //flush into EX stage
                .stall           (stall_ID),                        //stall at ID stage
                .i_pc_ID         (o_pc_IF),
                .i_insn_vld_ID   (o_insn_vld_IF),
                .i_instruction_ID(o_instruction_IF),
                .i_pc_plus4_ID   (o_pc_plus4_IF),
                .i_RegWen_ID     (i_RegWen_ID),
                .i_Asel_ID       (i_Asel_ID        ),
                .i_Bsel_ID       (i_Bsel_ID        ),
                .i_MemRW_ID      (i_MemRW_ID       ),
                .i_ALU_sel_ID    (i_ALU_sel_ID     ),
                .i_wb_select_ID  (i_wb_select_ID   ),
                .i_o_br_un_ID    (i_br_un_ID     ),
                .i_rs1_data_ID   (i_rs1_data_ID    ),
                .i_rs2_data_ID   (i_rs2_data_ID    ),
                .i_rs1_addr_ID   (i_rs1_addr_ID    ),
                .i_rs2_addr_ID   (i_rs2_addr_ID    ),
                .i_imm_ID        (i_imm_ID         ),
                .i_ctrl_ID       (o_PC_sel_EX      ),       //i_ctrl_ID),                           //PC_sel from Execute
                .o_ctrl_ID       (o_ctrl_ID        ),
                .o_imm_ID        (o_imm_ID         ),
                .o_pc_plus4_ID   (o_pc_plus4_ID    ),
                .o_pc_ID         (o_pc_ID          ),
                .o_instruction_ID(o_instruction_ID ),
                .o_insn_vld_ID   (o_insn_vld_ID    ),
                .o_rs1_data_ID   (o_rs1_data_ID    ),
                .o_rs2_data_ID   (o_rs2_data_ID    ),
                .o_rs1_addr_ID   (o_rs1_addr_ID    ),
                .o_rs2_addr_ID   (o_rs2_addr_ID    ),
                .o_RegWen_ID     (o_RegWen_ID      ),
                .o_Asel_ID       (o_Asel_ID        ),
                .o_Bsel_ID       (o_Bsel_ID        ),
                .o_MemRW_ID      (o_MemRW_ID       ),
                .o_ALU_sel_ID    (o_ALU_sel_ID     ),
                .o_wb_select_ID  (o_wb_select_ID   ),
                .o_br_un_ID      (o_br_un_ID       )
);
/////////////////////////////////////////////EXECUTE//////////////////////////////////////////

logic [1:0] fw_a, fw_b;
logic [31:0] i_operand_a_EX, i_operand_b_EX;
logic [31:0] wb_foward_EX_2;

always_comb begin 
    case (fw_a)
    2'b00: i_operand_a_EX = o_rs1_data_ID;
    2'b01: i_operand_a_EX = mem_foward_EX;
    2'b10: i_operand_a_EX = wb_foward_EX;
    2'b11: i_operand_a_EX = wb_foward_EX_2;
    endcase 
end

always_comb begin 
    case (fw_b)
    2'b00: i_operand_b_EX = o_rs2_data_ID;
    2'b01: i_operand_b_EX = mem_foward_EX;
    2'b10: i_operand_b_EX = wb_foward_EX;
    2'b11: i_operand_b_EX = wb_foward_EX_2;
    endcase 
end 


BRC BRC_inst(   .i_rs1_data (o_rs1_data_ID), 
                .i_rs2_data (o_rs2_data_ID),
                .instr_data (o_instruction_ID),
                .ALU_sel    (o_ALU_sel_ID),
                .i_br_un    (o_br_un_ID),        // 0 for unsigned, 1 for signed
                .o_pc_sel   (o_PC_sel_EX));

logic [31:0] ALU_A, ALU_B;
logic [31:0] o_pc_EX         ;
logic [31:0] o_pc_MEM;
assign ALU_A = o_Asel_ID ? o_pc_ID  : o_rs1_data_ID;
assign ALU_B = o_Bsel_ID ? o_imm_ID : o_rs2_data_ID;


ALU ALU_inst(
                .i_operand_a    (ALU_A), 
                .i_operand_b    (ALU_B),
                .i_alu_op       (o_ALU_sel_ID),
                .mux_out        (i_mux_out_EX)
                );


logic stall_EX;

logic        o_MemRW_EX      ;
logic        o_mispred_EX    ;           // misprediction counter
logic        o_ctrl_EX       ;
logic [31:0] o_pc_plus4_EX   ;
logic [31:0] o_mux_out_EX    ;
logic [31:0] o_rs2_data_EX   ;
logic        o_insn_vld_EX   ;
logic [31:0] o_instruction_EX;
logic        o_RegWen_EX     ;
logic [1:0]  o_wb_select_EX  ;
logic [31:0] o_imm_EX        ;


logic flush_MEM;
EX_reg EX_reg_inst(
            .clk                (i_clk),
            .reset              (i_reset),              // async active-low reset
            .flush              (flush_MEM),                       // flush down to mem stage
            .stall              (stall_EX),              // stall: hold current outputs
            .i_pc_plus4_EX      (o_pc_plus4_ID),
            .i_mux_out_EX       (i_mux_out_EX),
            .i_rs2_data_EX      (o_rs2_data_ID),
            .i_ctrl_EX          (o_ctrl_ID),
            .i_insn_vld_EX      (o_insn_vld_ID),
            .i_instruction_EX   (o_instruction_ID),  
            .i_RegWen_EX        (o_RegWen_ID),
            .i_MemRW_EX         (o_MemRW_ID),
            .i_wb_select_EX     (o_wb_select_ID),
            .i_imm_EX           (o_imm_ID),
            .i_pc_EX            (o_pc_ID),
            .o_pc_EX            (o_pc_EX),
            .o_imm_EX           (o_imm_EX),
            .o_wb_select_EX     (o_wb_select_EX),
            .o_MemRW_EX         (o_MemRW_EX      ),
            .o_mispred_EX       (o_mispred_EX    ),           // misprediction counter
            .o_ctrl_EX          (o_ctrl_EX       ),
            .o_pc_plus4_EX      (o_pc_plus4_EX   ),
            .o_mux_out_EX       (o_mux_out_EX    ),
            .o_rs2_data_EX      (o_rs2_data_EX   ),
            .o_insn_vld_EX      (o_insn_vld_EX   ),
            .o_instruction_EX   (o_instruction_EX),
            .o_RegWen_EX        (o_RegWen_EX     )
);
/////////////////////////////////////////////////MEM///////////////////////////////////////////////////
logic [31:0] o_ld_data_EX;

logic load_opcode_EX;
assign load_opcode_EX = (o_instruction_EX[6:0] == 7'b0000011) ? 1'b1 : 1'b0 ;
logic [31:0] i_lsu_addr;
always_comb begin
    if (load_opcode_EX) begin
        i_lsu_addr = o_mux_out_EX ;
    end else begin
        i_lsu_addr = i_mux_out_EX ;
    end
end

LSU LSU_inst(
            .i_clk      (i_clk), 
            .i_rst      (i_reset), 
            .i_lsu_wren (o_MemRW_ID),
            .funct3     (o_instruction_ID[14:12]),                                  //CONSIDER CHANGE TO ID
            .i_lsu_data (o_rs2_data_ID),                                   // the input data for LSU comes from output 2 of register files                                                                 
            .i_lsu_addr (i_mux_out_EX),                                  //the address for LSU comes from ALU
            .i_io_sw    (i_io_sw),
            .i_io_btn   (),
            .o_io_ledr  (o_io_ledr),  
            .o_io_ledg  (o_io_ledg), 
            .o_io_lcd   (o_io_lcd ), 
            .o_ld_data  (o_ld_data_EX),
            .o_io_hex0  (o_io_hex0), 
            .o_io_hex1  (o_io_hex1), 
            .o_io_hex2  (o_io_hex2),
            .o_io_hex3  (o_io_hex3),
            .o_io_hex4  (o_io_hex4),
            .o_io_hex5  (o_io_hex5)
            );

logic [31:0] mem_foward_select_EX;
logic [31:0]    o_pc_WB;
always_comb begin
    case (o_wb_select_EX)
    2'b01: mem_foward_select_EX = o_mux_out_EX;
    2'b10: mem_foward_select_EX = o_pc_EX + 4;                                                     //
    2'b11: mem_foward_select_EX = o_imm_EX;
    default: mem_foward_select_EX = o_mux_out_EX;
    endcase
end 


logic [31:0] o_mem_foward_MEM   ;
logic        o_mispred_MEM      ;

logic        o_ctrl_MEM         ;
logic        o_insn_vld_MEM     ;

load_logic loadlogic_MEM_inst (
                .funct3(o_instruction_EX[14:12]), 
                .opcode(o_instruction_EX[6:0]),                                    
				.i_wback_data(mem_foward_select_EX), 
				.o_wback_data(mem_foward_EX)
				);

logic [31:0] o_ld_data_MEM;
//logic [31:0] o_pc_MEM;
logic [1:0]  o_wb_select_MEM;
MEM_reg MEM_reg_inst(
                    .clk              (i_clk)  ,
                    .reset            (i_reset)  ,
                    .flush            (1'b0)  ,
                    .stall            (stall_MEM)  ,
                    .i_ctrl_MEM       (o_ctrl_EX)  ,
                    .i_insn_vld_MEM   (o_insn_vld_EX)  ,
                    .i_instruction_MEM(o_instruction_EX)  , 
                    .i_RegWen_MEM     (o_RegWen_EX)  ,
                    .i_mispred_MEM    (o_mispred_EX)  ,
                    .i_mem_foward_MEM (mem_foward_EX)  ,
                    .i_wb_select_MEM  (o_wb_select_EX),
                    .i_ld_data_MEM    (o_ld_data_EX),
                    .i_pc_MEM         (o_pc_EX),
                    .o_pc_MEM         (o_pc_MEM),
                    .o_ld_data_MEM    (o_ld_data_MEM),
                    .o_wb_select_MEM  (o_wb_select_MEM),
                    .o_mem_foward_MEM (o_mem_foward_MEM )  , 
                    .o_mispred_MEM    (o_mispred_MEM    )  ,
                    .o_RegWen_MEM     (o_RegWen_MEM     )  ,
                    .o_ctrl_MEM       (o_ctrl_MEM       )  ,
                    .o_insn_vld_MEM   (o_insn_vld_MEM   )  ,
                    .o_instruction_MEM(o_instruction_MEM)
);
/////////////////////////////////////////WRITEBACK///////////////////////////////////////////////////////
logic [31:0] o_ld_data_select_MEM;
always_comb begin
    case (o_wb_select_MEM)
    2'b00: wb_foward_EX = o_ld_data_select_MEM;
    default: wb_foward_EX = o_mem_foward_MEM;
    endcase
end


load_logic loadlogic_WB_inst (
                .funct3(o_instruction_MEM[14:12]), 
                .opcode(o_instruction_MEM[6:0]),                                    
				.i_wback_data(o_ld_data_MEM), 
				.o_wback_data(o_ld_data_select_MEM)
				);

logic o_insn_vld_WB;
logic [31:0]    o_instruction_WB;
WB_reg WB_reg_inst(
            .i_clk(i_clk),
            .i_rst(i_reset),
            .i_pc_WB(o_pc_MEM),
            .i_RegWen_WB    (o_RegWen_MEM),
            .o_RegWen_WB    (o_RegWen_WB),
            .i_wb_foward_WB(wb_foward_EX),
            //.flush(flush_ID),
            .o_wb_foward_WB(wb_foward_EX_2),
            .i_insn_vld_WB(o_insn_vld_MEM),
            .o_insn_vld_WB(o_insn_vld_WB),
            .o_pc_WB (o_pc_WB),
            .i_instruction_WB(o_instruction_MEM),
            .o_instruction_WB(o_instruction_WB)
    );


assign o_pc_debug = o_pc_WB;
assign o_insn_vld = o_insn_vld_WB;
assign o_ctrl     = o_PC_sel_EX;
assign o_mispred  = 1'b0;


hazard_detection  hazard_detection_inst(
                                        .clk            (i_clk),
                                        .reset_n        (i_reset),
                                        .instruction_EX(o_instruction_ID[6:0]), 
                                        //.instruction_MEM(o_instruction_EX[6:0]),
                                        //.instruction_WB(o_instruction_MEM[6:0]),
                                        .rs1_addr_ID    (o_instruction_IF[19:15]),
                                        .rs2_addr_ID    (o_instruction_IF[24:20]),
                                        .pc_sel_EX      (o_PC_sel_EX),
                                        .i_rd_addr_EX   (o_instruction_ID[11:7]),
                                        //.i_rd_addr_WB_2 (o_instruction_WB[11:7]),
                                        .i_rd_addr_MEM  (o_instruction_EX[11:7]),
                                        .i_rd_addr_WB   (o_instruction_MEM[11:7]), 
                                        .i_RegWen_EX    (o_RegWen_ID),
                                        .i_RegWen_MEM   (o_RegWen_EX),
                                        .i_RegWen_WB    (o_RegWen_MEM),
                                        //.i_RegWen_WB_2  (o_RegWen_WB),
                                        .o_stall_IF     (stall_IF ),
                                        .o_flush_IF     (flush_IF),
                                        .o_flush_ID     (flush_ID ), 
                                        .o_stall_ID     (stall_ID ),
                                        .o_flush_EX     (flush_EX ),
                                        .o_stall_EX     (stall_EX ),
                                        .o_flush_MEM    (flush_MEM),
                                        .o_stall_MEM     (stall_MEM)
                                        //.o_foward_A     (fw_a), 
                                        //.o_foward_B     (fw_b)
);

endmodule 
