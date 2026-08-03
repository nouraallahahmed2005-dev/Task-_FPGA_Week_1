/*
Module addsub



*/

module top_module(
    input [31:0] a,
    input [31:0] b,
    input sub,
    output [31:0] sum
);

    wire [31:0] bx;
    wire c;

    assign bx = b ^ {32{sub}};

    add16 A1 (.a(a[15:0]),  .b(bx[15:0]),  .cin(sub), .sum(sum[15:0]),  .cout(c));
    add16 A2 (.a(a[31:16]), .b(bx[31:16]), .cin(c),   .sum(sum[31:16]), .cout());

endmodule