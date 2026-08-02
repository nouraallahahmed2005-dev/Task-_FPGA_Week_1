/*
Vector5

As the diagram shows, this can be done more easily using the replication and concatenation operators.

The top vector is a concatenation of 5 repeats of each input
The bottom vector is 5 repeats of a concatenation of the 5 inputs



*/
module top_module (
	input a, b, c, d, e,
	output [24:0] out
);

	wire [24:0] top, bottom;
	assign top    = { {5{a}}, {5{b}}, {5{c}}, {5{d}}, {5{e}} };
	assign bottom = {5{a,b,c,d,e}};
	assign out = ~top ^ bottom;	

	
endmodule
