module adder_32_bit //(a, b, cin, sum, G, P, cout, overflow);
(
input logic [31:0] a, b,
input logic cin,
output logic  [31:0] sum,
output logic G, P, cout, overflow
);
logic G_16bit, P_16bit;

logic cin_16bit;


adder_16_bit adder16bit_0 (  .a(a[15:0]),
                                .b(b[15:0]),
                                .cin(cin),
                                .sum(sum[15:0]),
                                .G(G_16bit),
                                .P(P_16bit),
                                .cout(),
				.overflow()
                                );

assign cin_16bit = G_16bit | P_16bit & cin;

adder_16_bit adder16bit_1 (  .a(a[31:16]),
                                .b(b[31:16]),
                                .cin(cin_16bit),
                                .sum(sum[31:16]),
                                .G(G),
                                .P(P),
                                .cout(),
				.overflow()
                                );
                                
assign cout = G | P & (G_16bit | P_16bit & cin);

assign overflow = cin_16bit ^ cout;

endmodule