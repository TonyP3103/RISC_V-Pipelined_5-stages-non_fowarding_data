module shifter_32_bit_right//(i_data, i_shift_amt, A_enable, o_data);		// CURRENTLY DONT NEED
(
input logic [31:0] i_data,
input logic [4:0] i_shift_amt,
input logic A_enable,
output logic [31:0] o_data);

logic [31:0] temp;

always_comb begin
    if (i_data[31] & A_enable)
        temp = 32'hFFFFFFFF;
    else
        temp = 32'h00000000;
end

always_comb begin
    case(i_shift_amt)
    5'd0: o_data = i_data;
    5'd1: o_data = {temp[0], i_data[31:1]};
    5'd2: o_data = {temp[1:0], i_data[31:2]};
    5'd3: o_data = {temp[2:0], i_data[31:3]};
    5'd4: o_data = {temp[3:0], i_data[31:4]};
    5'd5: o_data = {temp[4:0], i_data[31:5]};
    5'd6: o_data = {temp[5:0], i_data[31:6]};
    5'd7: o_data = {temp[6:0], i_data[31:7]};
    5'd8: o_data = {temp[7:0], i_data[31:8]};
    5'd9: o_data = {temp[8:0], i_data[31:9]};
    5'd10: o_data = {temp[9:0], i_data [31:10]};
    5'd11: o_data = {temp[10:0], i_data [31:11]};
    5'd12: o_data = {temp[11:0], i_data [31:12]};
    5'd13: o_data = {temp[12:0], i_data [31:13]};
    5'd14: o_data = {temp[13:0], i_data [31:14]};
    5'd15: o_data = {temp[14:0], i_data [31:15]};
    5'd16: o_data = {temp[15:0], i_data [31:16]};
    5'd17: o_data = {temp[16:0], i_data [31:17]};
    5'd18: o_data = {temp[17:0], i_data [31:18]};
    5'd19: o_data = {temp[18:0], i_data [31:19]};
    5'd20: o_data = {temp[19:0], i_data [31:20]};
    5'd21: o_data = {temp[20:0], i_data [31:21]};
    5'd22: o_data = {temp[21:0], i_data [31:22]};
    5'd23: o_data = {temp[22:0], i_data [31:23]};
    5'd24: o_data = {temp[23:0], i_data [31:24]};
    5'd25: o_data = {temp[24:0], i_data [31:25]};
    5'd26: o_data = {temp[25:0], i_data [31:26]};
    5'd27: o_data = {temp[26:0], i_data [31:27]};
    5'd28: o_data = {temp[27:0], i_data [31:28]};
    5'd29: o_data = {temp[28:0], i_data [31:29]};
    5'd30: o_data = {temp[29:0], i_data [31:30]};
    5'd31: o_data = {temp[30:0], i_data [31]};       
    default: o_data = 32'b00000000000000000000000000000000; 
    endcase
end 



endmodule 