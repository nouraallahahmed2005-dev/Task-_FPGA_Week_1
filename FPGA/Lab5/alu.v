module alu
#(
    parameter WIDTH = 8
)
(
    input wire [2:0] opcode,
    input wire [WIDTH-1:0] in_a,
    input wire [WIDTH-1:0] in_b,
    output reg a_is_zero,
    output reg [WIDTH-1:0] alu_out
);


always @(*) begin

	if (in_a==0)
		
    a_is_zero = 1'b1;
	else
		a_is_zero = 1'b0;
    if (opcode == 3'b000)
        alu_out = in_a;

    else if (opcode == 3'b001)
        alu_out = in_a;

    else if (opcode == 3'b010)
        alu_out = in_a + in_b;

    else if (opcode == 3'b011)
        alu_out = in_a & in_b;

    else if (opcode == 3'b100)
        alu_out = in_a ^ in_b;

    else if (opcode == 3'b101)
        alu_out = in_b;

    else if (opcode == 3'b110)
        alu_out = in_a;

    else if (opcode == 3'b111)
        alu_out = in_a;

    else
        alu_out = {WIDTH{1'b0}};
end

endmodule