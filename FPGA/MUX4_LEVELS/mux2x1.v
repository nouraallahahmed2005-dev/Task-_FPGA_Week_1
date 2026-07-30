module mux2x1
(
    input a, b,
    input sel,
    output out
);

assign out = (~sel & a) | (sel & b);

endmodule