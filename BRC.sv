module BRC (input logic [31:0] i_rs1_data, i_rs2_data,
input logic [31:0] instr_data,
input logic [3:0] ALU_sel,
input logic i_br_un,        // 0 for unsigned, 1 for signed
output logic o_pc_sel);
//output logic o_br_less,o_br_equal);

logic cout;
logic [31:0] sum;
logic singed_less, unsigned_less;
logic branch_select;
logic o_br_less,o_br_equal;


adder_32_bit adder_32_bit_BRC (	.a(i_rs1_data),
                                    .b(~i_rs2_data),
                                    .cin(1'b1),
                                    .sum(sum),
                                    .G(),
                                    .P(),
                                    .cout(cout),
                                    .overflow()
                                    );


assign  o_br_equal = sum ? 1'b0 : 1'b1;

assign signed_less = (i_rs1_data[31] ^ i_rs2_data[31]) ? i_rs1_data[31] : sum[31];
assign unsigned_less = ~cout;


localparam R_type = 7'b0110011;
localparam I_type_ALU = 7'b0010011;
localparam I_type_load = 7'b0000011;
localparam S_type = 7'b0100011;
localparam B_type = 7'b1100011;
localparam J_type = 7'b1101111; // JAL
localparam I_type_JALR = 7'b1100111;
localparam U_type_AUIPC = 7'b0010111;
localparam U_type_LUI = 7'b0110111;

always_comb begin 
    case (instr_data[6:0])
    R_type: begin
        case (ALU_sel) 
            4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b1000, 4'b1001, 4'b1010: begin         //add, sub, sltu, slt, sll, srl, sra, and, or ,xor 
                o_pc_sel = 1'b0;  
            end
            default: begin
                o_pc_sel = 1'b0; 
            end
        endcase 
end 

    I_type_ALU: begin
        case (ALU_sel) 
            4'b0000, 4'b0001, 4'b0010, 4'b0011, 4'b0100, 4'b0101, 4'b0110, 4'b1000, 4'b1001, 4'b1010: begin         //addi, sltiu, slti, slli, srli, srai, andi, ori ,xori 
                o_pc_sel = 1'b0;  
            end
            default: begin
                o_pc_sel = 1'b0; 
            end
        endcase 
    end 

 I_type_load:
        begin
            o_pc_sel = 1'b0; 
        end

    S_type:
        begin
            o_pc_sel = 1'b0; 
        end
    
    B_type:
        begin
        o_pc_sel = branch_select;
        end 

    J_type:
        begin
        o_pc_sel = 1'b1;
        end 

    I_type_JALR:
        begin
        o_pc_sel = 1'b1;
        end 

    U_type_AUIPC:
        begin
        o_pc_sel = 1'b0;
        end 

    U_type_LUI:
        begin
        o_pc_sel = 1'b0;
        end

    default: begin
        o_pc_sel = 1'b0;
    end
    endcase 
 end 

    assign o_br_less  = i_br_un ? signed_less : unsigned_less;

///////////////////////////branch encoder logic//////////////////////////////
always_comb begin
    case (instr_data[14:12])                    //funct3
        3'b000: begin
             branch_select = o_br_equal;       // BEQ
        end    

        3'b001: begin
             branch_select = ~o_br_equal;      // BNE
        end 

        3'b100: begin
             branch_select = o_br_less;        // BLT
        end

        3'b101: begin
             branch_select = ~o_br_less;       // BGE
        end

        3'b110: begin
             branch_select = o_br_less;        // BLTU
        end

        3'b111: begin
             branch_select = ~o_br_less;       // BGEU
        end

        default:begin 
		  branch_select = 1'b0;
		  end
    endcase
end 
endmodule 
