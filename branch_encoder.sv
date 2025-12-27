/*module branch_encoder //(i_funct3, o_br_less, o_br_equal, o_pc_sel,i_br_un);              
(input logic [2:0] i_funct3,
input logic o_br_less, o_br_equal,
output logic o_pc_sel);

always_comb begin
    case (i_funct3)
        3'b000: begin
             o_pc_sel = o_br_equal;       // BEQ
        end    

        3'b001: begin
             o_pc_sel = ~o_br_equal;      // BNE
        end 

        3'b100: begin
             o_pc_sel = o_br_less;        // BLT
        end

        3'b101: begin
             o_pc_sel = ~o_br_less;       // BGE
        end

        3'b110: begin
             o_pc_sel = o_br_less;        // BLTU
        end

        3'b111: begin
             o_pc_sel = ~o_br_less;       // BGEU
        end

        default:begin 
		  o_pc_sel = 1'b0;
		  end
    endcase
end 

endmodule */