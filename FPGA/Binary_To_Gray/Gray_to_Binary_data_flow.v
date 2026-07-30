module Gray_to_Binary_data_flow
(
    input wire [3:0] a,
    output wire [3:0] b
);

assign b[3] = a[3];
assign b[2] = b[3] ^ a[2];
assign b[1] = b[2] ^ a[1];
assign b[0] = b[1] ^ a[0];

endmodule