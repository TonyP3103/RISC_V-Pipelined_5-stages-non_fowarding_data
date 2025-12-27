module LSU(
input logic i_clk, i_rst, i_lsu_wren,
input logic [2:0] funct3,
 
input logic [31:0] i_lsu_data,                                   // the input data for LSU comes from output 2 of register files                                                                 
input logic [31:0] i_lsu_addr,                                  //the address for LSU comes from ALU
input logic [31:0] i_io_sw,
input logic [31:0] i_io_btn,

output logic [31:0]  o_io_ledr, o_io_ledg, o_io_lcd, o_ld_data,
output logic [6:0] o_io_hex0, o_io_hex1, o_io_hex2, o_io_hex3, o_io_hex4, o_io_hex5);


logic [31:0] data_data, io_data;

logic data_mem_enable, io_mem_enable;
logic o_data_wren, o_io_wren;
logic [31:0] o_data_mem, o_data_io;
logic data_enable, io_enable;

logic [13:0] nxt_address;
//logic [31:0] o_data_1, o_data_2;
//logic [31:0] data_1, data_2;            //data connect from output store logic store back to memory

Decoder  decoder_inst ( .i_ls_address(i_lsu_addr[31:28]),                               //take the msb nible
                        .store_enable(i_lsu_wren), 
                        .i_data(i_lsu_data), 
                        .o_data_wren(o_data_wren), 
                        .o_data_mem(o_data_mem), 
                        .o_io_wren(o_io_wren), 
                        .o_data_io(o_data_io),
                        .data_enable(data_enable), 
                        .io_enable(io_enable)
); 



/*
store_logic store_logic_inst (
.i_address(i_lsu_addr[1:0]),                  
.i_nxt_address(),               
.funct3(funct3),
.i_data(o_data_mem),                      
.i_data_0(o_data_1),                    
.i_data_1(o_data_2),                   
.o_data_0(data_1),                   
.o_data_1(data_2)                    
);

assign nxt_address = i_lsu_addr[15:2] + 16'd1 ;
*/

RAM_DATA  RAM_DATA_inst 
 (
    .i_clk(i_clk),
    .i_wren(o_data_wren),
    .funct3(funct3),
    .i_address(i_lsu_addr[15:0]),
    .i_data(o_data_mem),
    .o_data(data_data)
);

/*
RAM_DATA RAM_DATA_inst (
	                .address_a      (i_lsu_addr[15:2]),
	                .address_b      (nxt_address),
			//.reset 		(i_rst),
	                .clock          (i_clk),
	                .data_a         (data_1),
	                .data_b         (data_2),
	                .wren_a         (o_data_wren),
	                .wren_b         (o_data_wren),
	                .q_a            (o_data_1),
	                .q_b            (o_data_2)
                        );
*/
/*
load_LSU_logic load_LSU_logic_inst (
                .i_address(i_lsu_addr[1:0]),                                    
                .i_data(o_data_1),                      
                .i_nxt_data(o_data_2),                      
                .o_data(data_data)
);
*/



ram_1KB_IO   ram_1KB_IO_DUT (	.i_clk(i_clk), 
                                .i_rst(i_rst),
                                .i_wren(o_io_wren), 
				.io_enable(io_enable),
                                .i_address(i_lsu_addr[16:0]), // 17 lsb of addresses for IO                             
                                .i_data(o_data_io), 
                                .o_data(io_data), 
                                .i_io_sw(i_io_sw), 
                                .o_io_ledr(o_io_ledr), 
                                .o_io_ledg(o_io_ledg), 
                                .o_io_lcd(o_io_lcd), 
                                .o_io_hex0(o_io_hex0), 
                                .o_io_hex1(o_io_hex1), 
                                .o_io_hex2(o_io_hex2), 
                                .o_io_hex3(o_io_hex3),
                                .o_io_hex4(o_io_hex4), 
                                .o_io_hex5(o_io_hex5),
                                .funct3(funct3)                     //add function_3 to store load byte and half word
                                );

logic  [1:0] lsu_sel;

assign lsu_sel = {io_enable, data_enable};

LSU_MUX LSU_MUX_inst (  .data_data(data_data), 
                        .io_data(io_data), 
                        .lsu_sel(lsu_sel), 
                        .lsu_data_out(o_ld_data)
                );

endmodule   