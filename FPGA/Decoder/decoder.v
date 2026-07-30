module Decoder ;
	reg A, B;
reg EN;
wire [3:0] out;




Decoder_2x4_ Decoder1 (.A(A), .B(B), .EN(EN), .out(out));

initial begin
   
    EN = 0; A = 0; B = 0; #10;

   EN = 0; A = 0; B = 1; #10;
   
   EN = 0; A = 1; B = 0; #10;
   EN = 0; A = 1; B = 1; #10;
   
   
   EN = 1; A = 0; B = 0; #10;
    EN = 1; A = 0; B = 1; #10;
	 EN = 1; A = 1; B = 0; #10;
	  EN = 1; A = 1; B =1; #10;
   
   
    $stop;
end
endmodule