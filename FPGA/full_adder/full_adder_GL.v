module FA
(
    input wire a, b, c1,
    output wire result, c2
);

wire out1, out2, out3;

xor xor1(out1, a, b);
xor xor2 (result, out1, c1);

and and1 (out2, a, b);
and and2 (out3, out1, c1);

or or1 (c2, out2, out3);

endmodule