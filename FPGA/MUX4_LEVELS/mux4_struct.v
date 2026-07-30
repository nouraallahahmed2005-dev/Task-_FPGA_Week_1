module mux4_struct
(
    input a, b, c, d,
    input [1:0] sel,
    output out
);

wire w1, w2;

mux2x1 M1 (.a(a),.b(b),.sel(sel[0]), .out(w1));

mux2x1 M2 (.a(c),.b(d),.sel(sel[0]),.out(w2));

mux2x1 M3 (.a(w1),.b(w2),.sel(sel[1]),.out(out));

endmodule