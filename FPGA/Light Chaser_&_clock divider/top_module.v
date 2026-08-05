module top_module
(
    input wire clk50,
    input wire reset,
    input wire hold,

    output wire [3:0] outs
);

wire clk2hz;

clock_divider mod1
(
    .clk_in(clk50),
    .reset(reset),
    .clk_out(clk2hz)
);

Light_Chaser mod2
(
    .clk(clk2hz),
    .reset(reset),
    .hold(hold),
    .SR_out(outs)
);

endmodule