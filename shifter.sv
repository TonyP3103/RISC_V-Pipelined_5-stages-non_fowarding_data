module shifter //(i_data, i_shamt, i_type, o_result);
(input logic [31:0] i_data,
input logic [4:0] i_shamt,
input logic [1:0] i_type, //00 logical left, 01 logical right, 10,11 arithmetic right, 11 FOR ARITHMETIC FOR NOW
output logic [31:0] o_result);

logic [31:0] data_temp;
always_comb begin
if (i_data[31]) begin
    data_temp = 32'hFFFFFFFF;
end else begin
    data_temp = 32'd0;
end
end

logic [31:0] shifted_data_0,shifted_data_1,shifted_data_2,shifted_data_3,shifted_data_4;

assign shifted_data_0 = (i_shamt[0]) ? ((i_type) ? ((i_type[1]) ? ({data_temp[0],i_data[31:1]}) : {1'b0,i_data[31:1]}) : {i_data[30:0], 1'b0}) : i_data;
assign shifted_data_1 = (i_shamt[1]) ? ((i_type) ? ((i_type[1]) ? ({data_temp[1:0],shifted_data_0[31:2]}) : {2'd0,shifted_data_0[31:2]}) : {shifted_data_0[29:0], 2'd0}) : shifted_data_0;
assign shifted_data_2 = (i_shamt[2]) ? ((i_type) ? ((i_type[1]) ? ({data_temp[3:0],shifted_data_1[31:4]}) : {4'd0,shifted_data_1[31:4]}) : {shifted_data_1[27:0], 4'd0}) : shifted_data_1;
assign shifted_data_3 = (i_shamt[3]) ? ((i_type) ? ((i_type[1]) ? ({data_temp[7:0],shifted_data_2[31:8]}) : {8'd0,shifted_data_2[31:8]}) : {shifted_data_2[23:0], 8'd0}) : shifted_data_2;
assign shifted_data_4 = (i_shamt[4]) ? ((i_type) ? ((i_type[1]) ? ({data_temp[15:0],shifted_data_3[31:16]}) : {16'd0,shifted_data_3[31:16]}) : {shifted_data_3[15:0], 16'd0}) : shifted_data_3;

assign o_result = shifted_data_4;

endmodule 