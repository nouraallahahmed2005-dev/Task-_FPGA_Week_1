module FA
(
    input wire a, b, c1,
    output wire result, c2
);

wire s1, c11, c22;

HA HA1(.a(a),.b(b),.R1(s1),.c1(c11));

HA HA2(.a(s1),.b(c1),.R1(result),.c1(c22));


or or1 (c2, c11, c22);

endmodule