module flip_flop 
(
	input wire CLK,
	input wire reset,
	input wire d,
	output reg q

);
	always@(posedge CLK or posedge reset)
	begin
		if (reset==1)
		begin
			q = 1'b0;
		end
		else
		begin
			q <=d;
		end
	
	
	end
endmodule