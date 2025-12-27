module imm_flag //(opcode, flag);

(input logic [6:0] opcode,

output logic [2:0] flag);

localparam R_type = 7'b0110011;
localparam I_type_ALU = 7'b0010011;
localparam I_type_load = 7'b0000011;
localparam S_type = 7'b0100011;
localparam B_type = 7'b1100011;
localparam J_type = 7'b1101111; // JAL
localparam I_type_JALR = 7'b1100111;
localparam U_type_AUIPC = 7'b0010111;
localparam U_type_LUI = 7'b0110111;
                        // encode the opcode to 3 bits flag
                        // dont't care : R-type
                        // 000 : I-type
                        // 001 : S-type
                        // 010 : B-Type
                        // 011 : U-type
                        // 100 : J-type
                        // 110 : don't care
                        // 111 : don't care

    always_comb begin
        case (opcode)
        I_type_ALU, I_type_load, I_type_JALR : begin
            flag = 3'b000;
        end

        S_type: begin
            flag = 3'b001;
        end 

        B_type: begin
            flag = 3'b010;
        end

        U_type_AUIPC, U_type_LUI: begin
            flag = 3'b011;
        end

        J_type: begin
            flag = 3'b100;
        end

        default: begin
            flag = 3'b101;
        end 
        endcase 
    end


    endmodule