module adder_16_bit //(  a, b, cin, sum, G, P, cout,overflow);

(input logic [15:0] a, b,
input logic cin,
output logic  [15:0] sum,
output logic G, P, cout,
output logic overflow);

logic [3:0] G_4bit, P_4bit;

logic [2:0] cin_4bit;


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

adder_4_bit adder4bit_2 (	.a(a[11:8]),
									.b(b[11:8]),
									.cin(cin_4bit[1]),
									.sum(sum[11:8]), 
									.G(G_4bit[2]),
									.P(P_4bit[2]),
									.overflow()
									);	
									
assign cin_4bit[2] = G_4bit[2] | P_4bit[2] & (G_4bit[1] | P_4bit[1] & (G_4bit[0] | P_4bit[0] & cin));		

adder_4_bit adder4bit_3 (	.a(a[15:12]),
									.b(b[15:12]),
									.cin(cin_4bit[2]),
									.sum(sum[15:12]), 
									.G(G_4bit[3]),
									.P(P_4bit[3]),
									.overflow()
									);		
									
assign G = G_4bit[3] | P_4bit[3] & (G_4bit[2] | P_4bit[2] & (G_4bit[1] | P_4bit[1] & (G_4bit[0] | P_4bit[0] & cin)));		
assign P = P_4bit[3] & P_4bit[2] & P_4bit[1] & P_4bit[0];

assign overflow = G ^ cin_4bit[2];									
endmodule
 