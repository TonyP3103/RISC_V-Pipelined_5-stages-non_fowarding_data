module ram_1KB_IO #(  parameter MEM_FILE   = "") 
(
input logic i_clk,
input logic i_rst,
input logic i_wren,
input logic io_enable,
input logic  [16:0]  i_address,                 // first nible to seperate the input and output 
input logic [2:0] funct3,
 

input logic [31:0] i_data,
input logic [31:0] i_io_sw,


output logic [31:0] o_data,
output logic [31:0]  o_io_ledr, o_io_ledg, o_io_lcd,
output logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5);


logic [31:0] mem_output_buffer [0:4];                //5 32 bits register with each register hold 4 bytes of IO value

  

logic [31:0] mem_input_buffer;                  // take switches as only inputs                                 

logic [7:0] byte_0, byte_1;

logic [31:0] store_data;

assign byte_0 = i_data[7:0];
assign byte_1 = i_data[15:8];



always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
         mem_output_buffer[0] <= 32'b0;
         mem_output_buffer[1] <= 32'b0;
         mem_output_buffer[2] <= 32'b0;
         mem_output_buffer[3] <= 32'b0;
         mem_output_buffer[4] <= 32'b0;
    end else if (i_wren) begin                              //write to the corresponding io
        mem_output_buffer[i_address[15:12]] <= store_data;  //i_data;                                        //add a register to select what kind of store byte
    end
end

always_ff @(posedge i_clk or negedge i_rst) begin
    if (!i_rst) begin
         o_io_ledr <= 32'b0;
         o_io_ledg <= 32'b0;
         o_io_hex0 <= 7'b0;
         o_io_hex1 <= 7'b0;
         o_io_hex2 <= 7'b0;
         o_io_hex3 <= 7'b0;
         o_io_hex4 <= 7'b0;
         o_io_hex5 <= 7'b0;
         o_io_lcd <= 32'b0;
         o_data <= 32'b0;
    end else begin
         o_io_ledr <=  mem_output_buffer[0];               //0x1000_0000 to 0x1000_0FFF
         o_io_ledg <=  mem_output_buffer[1];               //0x1000_1000 to 0x1000_1FFF
         o_io_hex0 <=  mem_output_buffer[2][6:0];          // 0x1000_2000 to 0x1000_2FFF
         o_io_hex1 <=  mem_output_buffer[2][14:8];         
         o_io_hex2 <=  mem_output_buffer[2][22:16];        
         o_io_hex3 <=  mem_output_buffer[2][30:24];
         o_io_hex4 <=  mem_output_buffer[3][6:0];          //0x1000_3000 to 0x1000_3FFF
         o_io_hex5 <=  mem_output_buffer[3][14:8];
         o_io_lcd  <=  mem_output_buffer[4];               //0x1000_4000 to 0x1000_4FFF
         o_data    <= (i_address[16] & io_enable) ? mem_input_buffer : mem_output_buffer[i_address[15:12]];
    end
end

always_comb begin
    case (funct3)
    3'b000: begin                                                   //store byte
        store_data = {24'd0, byte_0};
    end 
    3'b001: begin                                                   //store halfword
        store_data = {16'd0, byte_1, byte_0};
    end
    3'b010: begin                                                   //store word
        store_data = i_data;
    end
    default: begin
        store_data = i_data;
        end 
    endcase 
end 

assign mem_input_buffer = i_io_sw;       




endmodule
