module multiplexor
#(
    parameter WIDTH = 5
)
(
    input sel,
    input [WIDTH-1:0] in0,
    input [WIDTH-1:0] in1,
    output reg [WIDTH-1:0] mux_out
);

always @(*) begin
    if (sel)
        mux_out = in1;
    else
        mux_out = in0;
end

endmodule