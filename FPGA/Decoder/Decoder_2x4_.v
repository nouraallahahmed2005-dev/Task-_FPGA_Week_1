module Decoder_2x4_(
	input wire A, B,
	input wire EN,
	output reg [3:0] out


);

always@(*)
	begin
		if (EN==1)
		begin
			if ({A,B}==2'b00)
			begin
				out=4'b0001;
			end
			 else if ({A,B}==2'b01)
			begin
				out=4'b0010;
			end
			 else if ({A,B}==2'b10)
			begin
				out=4'b0100;
			end
			 else if ({A,B}==2'b11)
			begin
				out=4'b1000;
			end
		end
		else
		begin
			out=4'b0000;
		end
	end
endmodule