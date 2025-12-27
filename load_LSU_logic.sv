module load_LSU_logic (
input logic [1:0] i_address,                  //last 2 bits for byte offset within word   
                                                //next 9 bits for word address within memory
input logic [31:0] i_data,                      //data from i_address
input logic [31:0] i_nxt_data,                      //data from i_nxt_address
output logic [31:0] o_data
);

logic [31:0] temp_data_0, temp_data_1;

always_comb begin
    temp_data_0 = i_data;   
    temp_data_1 = i_nxt_data;
end

always_comb begin
case (i_address)
    2'b00: begin
        o_data = temp_data_0;
    end 

    2'b01: begin
        o_data = {temp_data_1[7:0],temp_data_0[31:8]};
    end 

    2'b10: begin
        o_data = {temp_data_1[15:0], temp_data_0[31:16]};
    end 

    2'b11: begin
        o_data = {temp_data_1[23:0], temp_data_0[31:24]};
    end

endcase
end 

endmodule 