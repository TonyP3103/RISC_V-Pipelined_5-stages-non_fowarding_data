module adder_8bit (									//9 bits adder 
    input logic [8:0] a,
    input logic [8:0] b,
    input logic cin,
    output logic [8:0] sum
);
logic [1:0] G_4bit, P_4bit;

logic [1:0] cin_4bit;


adder_4_bit adder4bit_0 (	.a(a[3:0]),
									.b(b[3:0]),
									.cin(cin),
									.sum(sum[3:0]), 
									.G(G_4bit[0]),
									.P(P_4bit[0]),
									.overflow()
									);	

									
assign cin_4bit[0] = G_4bit[0] | P_4bit[0] & cin;							
									
									
adder_4_bit adder4bit_1 (	.a(a[7:4]),
									.b(b[7:4]),
									.cin(cin_4bit[0]),
									.sum(sum[7:4]), 
									.G(G_4bit[1]),
									.P(P_4bit[1]),
									.overflow()
									);	
									
assign cin_4bit[1] = G_4bit[1] | P_4bit[1] & (G_4bit[0] | P_4bit[0] & cin);		

adder_1_bit adder_1bit_instant (	.a(a[8]), 
											.b(b[8]),
											.cin(cin_4bit[1]),
											.cout(), 
											.sum(sum[8]), 
											.g(), 
											.p()
											);

endmodule