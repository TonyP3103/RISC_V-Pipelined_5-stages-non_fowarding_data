module  Decoder (
input logic [3:0] i_ls_address,                //load-store address                                                            
input logic store_enable,
input logic [31:0] i_data,                      //data to be stored
output logic o_data_wren,                 
output logic [31:0] o_data_mem,                   
output logic o_io_wren,              
output logic [31:0] o_data_io,
output logic data_enable,
output logic io_enable);

//i_ls_address[3:0] from the ALU[31:28]
assign io_enable   = ~|i_ls_address[3:1] & i_ls_address[0]; // 0x1000_0000 –  0x1001_0FFF
assign data_enable = ~|i_ls_address[3:0]; // 0x0000_0000 – 0x0000_07FF
    
// Write enables
assign o_data_wren = data_enable & store_enable;
assign o_io_wren   = io_enable   & store_enable;

// Always forward data, enables control actual writes
assign o_data_mem = i_data;
assign o_data_io  = i_data;

endmodule 