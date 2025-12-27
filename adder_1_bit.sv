module adder_1_bit //(a, b, cin, cout, sum, g, p);					//g: generate 				p: propagate
		(input logic a, b, cin,	
		output logic cout, sum, g, p);
		
		assign p = a ^ b;
		assign g = a & b;
		
		assign sum = p ^ cin;
		assign cout = g | p & cin;
endmodule 