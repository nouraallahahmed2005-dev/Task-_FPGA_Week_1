
module flip_flop_tb;

reg CLK;
reg reset;
reg d;
wire q;

flip_flop FLP (
    .CLK(CLK),
    .reset(reset),
    .d(d),
    .q(q)
);

always #5 CLK = ~CLK;

initial begin
    CLK = 1'b0;
    reset = 1'b0;
    d = 1'b0;

    #10 d = 1'b1;
    #10 d = 1'b0;
    #10 reset = 1'b1;
    #10 reset = 1'b0;
    #10 d = 1'b1;

    #20 $stop;
end

endmodule