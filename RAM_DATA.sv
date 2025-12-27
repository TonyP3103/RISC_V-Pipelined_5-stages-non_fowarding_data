module RAM_DATA #(parameter MEM_FILE = "/home/yellow/ctmt_cttt_11/workspace_3/00_src/mem_64KB_zeros.hex")
(
    input  logic        i_clk,
    input  logic        i_wren,
    input  logic [2:0]       funct3,
    input  logic [15:0] i_address,

    input  logic [31:0] i_data,

    output logic [31:0] o_data
);

    // 512 x 32-bit memory = 2 KiB
    logic [7:0] mem[0:65535];
   
initial begin
        // Initialize everything to zero first to avoid 'x'
        for (int i = 0; i <= 65535; i++) begin
            mem[i] = 8'h00;
        end
        // Then try to overwrite with the hex file
        $readmemh(MEM_FILE, mem);
    end
   


    always_ff @(posedge i_clk) begin
        if (i_wren) begin
        case(funct3)
        3'b000: begin                                                   //store byte                        

            mem[i_address] <= i_data[7:0];
        end
        3'b001: begin    
            mem[i_address] <= i_data[7:0];                                               //store halfword    
			mem[i_address + 1] <= i_data[15:8];

        end
        3'b010: begin
            mem[i_address] <= i_data[7:0];     
            mem[i_address + 1] <= i_data[15:8];
            mem[i_address + 2] <= i_data[23:16];
            mem[i_address + 3] <= i_data[31:24];
        end
        endcase  
    end 
end

    always_ff @(posedge i_clk) begin
            o_data <= {mem[i_address + 3], mem[i_address + 2], mem[i_address + 1], mem[i_address]};
				end 

endmodule













/*(
    input  logic        clock,
    // No hardware reset for the memory array!
    
    // Port A
    input  logic [13:0] address_a,
    input  logic [31:0] data_a,
    input  logic        wren_a,
    output logic [31:0] q_a,

    // Port B
    input  logic [13:0] address_b,
    input  logic [31:0] data_b,
    input  logic        wren_b,
    output logic [31:0] q_b
);

    // 1. Correct Size: [0:16383] matches 14-bit address (2^14)
    logic [31:0] mem [0:16383];

    // 2. Initialization for FPGA (ignored by ASIC synthesis)
    // Use $readmemh if you want to load a hex file (like instructions)
    initial begin
        $readmemh(MEM_FILE,mem);
    end

    // 3. Port A Logic
    always_ff @(posedge clock) begin
        if (wren_a) begin
            mem[address_a] <= data_a;
        end
        q_a <= mem[address_a]; // Read acts every cycle
    end

    // 4. Port B Logic
    // Note: Writing to the same 'mem' variable from two always blocks
    // is usually illegal, but Synthesis tools (Vivado/Quartus) PERMIT
    // this specific pattern to infer True Dual-Port RAM.
    always_ff @(posedge clock) begin
        if (wren_b) begin
            mem[address_b] <= data_b;
        end
        q_b <= mem[address_b];
    end

endmodule*/