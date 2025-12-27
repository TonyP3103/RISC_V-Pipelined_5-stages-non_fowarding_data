module shifter_32_bit_left //(i_data, i_shift_amt, o_data);		// CURRENTLY DONT NEED

(input logic [31:0] i_data,
input logic [4:0] i_shift_amt,
output logic [31:0] o_data);

always_comb begin
case(i_shift_amt)
    5'd0: o_data = i_data;
    5'd1: o_data = {i_data[30:0], 1'b0};
    5'd2: o_data = {i_data[29:0], 2'b00};
    5'd3: o_data = {i_data[28:0], 3'b000};
    5'd4: o_data = {i_data[27:0], 4'b0000};
    5'd5: o_data = {i_data[26:0], 5'b00000};
    5'd6: o_data = {i_data[25:0], 6'b000000};
    5'd7: o_data = {i_data[24:0], 7'b0000000};
    5'd8: o_data = {i_data[23:0], 8'b00000000};
    5'd9: o_data = {i_data[22:0], 9'b000000000};
    5'd10: o_data = {i_data[21:0], 10'b0000000000};
    5'd11: o_data = {i_data[20:0], 11'b00000000000};
    5'd12: o_data = {i_data[19:0], 12'b000000000000};
    5'd13: o_data = {i_data[18:0], 13'b0000000000000};
    5'd14: o_data = {i_data[17:0], 14'b00000000000000};
    5'd15: o_data = {i_data[16:0], 15'b000000000000000};
    5'd16: o_data = {i_data[15:0], 16'b0000000000000000};
    5'd17: o_data = {i_data[14:0], 17'b00000000000000000};
    5'd18: o_data = {i_data[13:0], 18'b000000000000000000};
    5'd19: o_data = {i_data[12:0], 19'b0000000000000000000};
    5'd20: o_data = {i_data[11:0], 20'b00000000000000000000};
    5'd21: o_data = {i_data[10:0], 21'b000000000000000000000};
    5'd22: o_data = {i_data[9:0], 22'b0000000000000000000000};
    5'd23: o_data = {i_data[8:0], 23'b00000000000000000000000};
    5'd24: o_data = {i_data[7:0], 24'b000000000000000000000000};
    5'd25: o_data = {i_data[6:0], 25'b0000000000000000000000000};
    5'd26: o_data = {i_data[5:0], 26'b00000000000000000000000000};
    5'd27: o_data = {i_data[4:0], 27'b000000000000000000000000000};
    5'd28: o_data = {i_data[3:0], 28'b0000000000000000000000000000};
    5'd29: o_data = {i_data[2:0], 29'b00000000000000000000000000000};
    5'd30: o_data = {i_data[1:0], 30'b000000000000000000000000000000};
    5'd31: o_data = {i_data[0], 31'b00000000000000000000000000000};
    default: o_data = 32'b00000000000000000000000000000000;
endcase
end


endmodule 