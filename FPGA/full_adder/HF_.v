module HA
(
    input wire a, b,
    output wire R1, c1
);

assign R1 = a ^ b;
assign c1 = a & b;

endmodule