module imem #(parameter MEM_FILE = "")
(	
	input logic [10:0]  address,
	input logic clock, reset,
	input logic flush,
	output logic [31:0] q
);

logic [31:0] mem [0:2048];



always_ff @(posedge clock or negedge reset) begin
	if (!reset ) begin
		q <= 32'd0;
	end  else begin
			q <=  flush ? 32'd0 :  mem[address]  ;

	end
	end 


initial begin
	$readmemh(MEM_FILE,mem);
end 


endmodule 
