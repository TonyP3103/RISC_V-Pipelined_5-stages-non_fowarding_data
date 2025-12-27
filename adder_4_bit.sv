module adder_4_bit //(a, b, cin, sum, G, P, overflow);
    (input logic [3:0] a, b,
    input logic cin,
    output logic [3:0] sum,
    output logic G, P  , 
    output logic overflow);

    logic [3:0] g, p;
    logic [4:0] c;

    assign c[0] = cin;

    adder_1_bit adder1bit_0 (.a(a[0]), .b(b[0]), .cin(c[0]), .cout(), .sum(sum[0]), .g(g[0]), .p(p[0]));
    adder_1_bit adder1bit_1 (.a(a[1]), .b(b[1]), .cin(c[1]), .cout(), .sum(sum[1]), .g(g[1]), .p(p[1]));
    adder_1_bit adder1bit_2 (.a(a[2]), .b(b[2]), .cin(c[2]), .cout(), .sum(sum[2]), .g(g[2]), .p(p[2]));
    adder_1_bit adder1bit_3 (.a(a[3]), .b(b[3]), .cin(c[3]), .cout(), .sum(sum[3]), .g(g[3]), .p(p[3]));

    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign G = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign P = p[3] & p[2] & p[1] & p[0];

    assign overflow = c[4] ^ c[3];
endmodule