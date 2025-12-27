module ALU_encoder //(i_funct7, i_funct3, i_opcode, o_alu_op);
(input logic [6:0] i_funct7,
input logic [2:0] i_funct3,
input logic [6:0] i_opcode,
output logic [3:0] o_alu_op);

localparam R_type = 7'b0110011;
localparam I_type_ALU = 7'b0010011;
localparam I_type_load = 7'b0000011;
localparam S_type = 7'b0100011;
localparam B_type = 7'b1100011;
localparam J_type = 7'b1101111; // JAL
localparam I_type_JALR = 7'b1100111;

always_comb begin
    o_alu_op = 4'b0000;
    case(i_opcode)

    R_type: begin
    case (i_funct3)
        3'b000: o_alu_op = (i_funct7[5]) ? 4'b0001 : 4'b0000; // SUB or ADD
        3'b001: o_alu_op = 4'b0100; // SLL
        3'b010: o_alu_op = 4'b0011; // SLT
        3'b011: o_alu_op = 4'b0010; // SLTU
        3'b100: o_alu_op = 4'b1010; // XOR
        3'b101: o_alu_op = (i_funct7[5]) ? 4'b0110 : 4'b0101; // SRA or SRL
        3'b110: o_alu_op = 4'b1001; // OR
        3'b111: o_alu_op = 4'b1000; // AND
        default: o_alu_op = 4'b0000;
    endcase
    end 

     I_type_ALU: begin
    case (i_funct3)
        3'b000: o_alu_op = 4'b0000; // only add immidiate
        3'b001: o_alu_op = 4'b0100; // SLL
        3'b010: o_alu_op = 4'b0011; // SLT
        3'b011: o_alu_op = 4'b0010; // SLTU
        3'b100: o_alu_op = 4'b1010; // XOR
        3'b101: o_alu_op = (i_funct7[5]) ? 4'b0110 : 4'b0101; // SRA or SRL
        3'b110: o_alu_op = 4'b1001; // OR
        3'b111: o_alu_op = 4'b1000; // AND
        default: o_alu_op = 4'b0000;
    endcase
    end 

    default: begin 
            o_alu_op = 4'b0000;
    end 

    endcase 
    end 
endmodule 