module FA
(
    input wire a, b, c1,
    output reg result, c2
);

always @(*)
begin
    if (a + b + c1 == 0)
		begin
        {c2, result} = 2'b00;
		end
    else if (a + b + c1 == 1)
		begin
        {c2, result} = 2'b01;
		end
    else if (a + b + c1 == 2)
	     begin
        {c2, result} = 2'b10;
		end
    else
		begin
        {c2, result} = 2'b11;
		end
end

endmodule