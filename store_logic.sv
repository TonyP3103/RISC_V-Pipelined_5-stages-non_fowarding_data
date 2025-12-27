//the store logic takes 2 continous mem and store them back at the next clk
module store_logic (
input logic [1:0] i_address,                  //last 2 bits for byte offset within word   
                                               //next 9 bits for word address within memory
input logic [8:0]  i_nxt_address,               //comes from adder_8bit(9bit adder) outside the module

input logic [2:0] funct3,

input logic [31:0] i_data,                      //data from RS2
input logic [31:0] i_data_0,                   //data from i_address 
input logic [31:0] i_data_1,                   //data from i_address + 4


output logic [31:0] o_data_0,                   //data to be stored back to i_address
output logic [31:0] o_data_1                    //data to be stored back to
);

logic [31:0] temp_data_0, temp_data_1, temp_data_2, temp_data_3;

logic [7:0] byte_0, byte_1, byte_2, byte_3, byte_4, byte_5, byte_6, byte_7;

logic [7:0] store_byte_0, store_byte_1, store_byte_2, store_byte_3;

logic [15:0] store_halfword;

logic [8:0] nxt_address;


assign byte_0 = temp_data_0[7:0];
assign byte_1 = temp_data_0[15:8];
assign byte_2 = temp_data_0[23:16];
assign byte_3 = temp_data_0[31:24];

assign byte_4 = temp_data_1[7:0];
assign byte_5 = temp_data_1[15:8];
assign byte_6 = temp_data_1[23:16];
assign byte_7 = temp_data_1[31:24];


assign store_byte_0 = i_data[7:0];
assign store_byte_1 = i_data[15:8];
assign store_byte_2 = i_data[23:16];
assign store_byte_3 = i_data[31:24];



assign store_halfword = i_data[15:0];



always_comb begin
    temp_data_0 =  i_data_0;   
    temp_data_1 = i_data_1;
end

always_comb begin
       //     temp_data_2 = temp_data_0;
       // temp_data_3 = temp_data_1;
    case(funct3)
    3'b000: begin                                                   //store byte
        case(i_address[1:0])
        2'b00: begin
            temp_data_2 = {byte_3, byte_2, byte_1, store_byte_0};
            temp_data_3 = temp_data_1;
        end 

        2'b01: begin
            temp_data_2 = {byte_3, byte_2, store_byte_0, byte_0};
            temp_data_3 = temp_data_1;
        end 

        2'b10: begin
            temp_data_2 = {byte_3, store_byte_0, byte_1, byte_0};
            temp_data_3 = temp_data_1;
        end 

        2'b11: begin
            temp_data_2 = {store_byte_0, byte_2, byte_1, byte_0};
            temp_data_3 = temp_data_1;
        end 
        endcase 
    end 

    3'b001: begin                                                      // store halfword
        case(i_address[1:0])
        2'b00: begin
            temp_data_2 = {byte_3, byte_2, store_halfword};
            temp_data_3 = temp_data_1;
        end 

        2'b01: begin
            temp_data_2 = {byte_3, store_halfword, byte_0};
            temp_data_3 = temp_data_1;
        end 

        2'b10: begin
            temp_data_2 = {store_halfword, byte_1, byte_0};
            temp_data_3 = temp_data_1;
        end 

        2'b11: begin
            temp_data_2 = {store_byte_0, byte_2, byte_1, byte_0};
            temp_data_3 = {temp_data_1[31:8],store_byte_1};
        end 
        endcase 
    end 

    3'b010: begin                                                   //store word
        case(i_address[1:0])
        2'b00: begin
            temp_data_2 = i_data;
            temp_data_3 = temp_data_1;
        end 

        2'b01: begin
            temp_data_2 = {store_byte_2, store_halfword, byte_0};
            temp_data_3 = {temp_data_1[31:8],store_byte_3};
        end 

        2'b10: begin
            temp_data_2 = {store_halfword, byte_1, byte_0};
            temp_data_3 = {temp_data_1[31:16], store_byte_3, store_byte_2};
        end 

        2'b11: begin
            temp_data_2 = {store_byte_0, byte_2, byte_1, byte_0};
            temp_data_3 = {temp_data_1[31:24],store_byte_3, store_byte_2, store_byte_1};
        end 
        endcase 

    end

    default: begin
        temp_data_2 = temp_data_0;
        temp_data_3 = temp_data_1;
    end
    endcase
end 
   
    assign o_data_0 = temp_data_2;
    assign o_data_1 = temp_data_3;

endmodule 