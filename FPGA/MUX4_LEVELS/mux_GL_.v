module mux4_GL
(
    input wire a, b, c, d,
    input wire [1:0] sel,
    output wire out
);

wire n0, n1;
wire w1, w2, w3, w4;

not not1 (n0, sel[0]);
not not2 (n1, sel[1]);

and a0 (w1, a, n1, n0);
and a1 (w2, b, n1, sel[0]);
and a2(w3, c, sel[1], n0);
and a3 (w4, d, sel[1], sel[0]);

or or1 (out, w1, w2, w3, w4);

endmodule