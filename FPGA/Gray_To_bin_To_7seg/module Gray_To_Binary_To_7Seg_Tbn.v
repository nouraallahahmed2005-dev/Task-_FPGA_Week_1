module Gray_To_Binary_Tbn;

	reg [3:0] gray;
     wire [3:0] bin;
	 wire [6:0] seg;


Gray_To_Binary G_T_B (.gray(gray),.bin(bin));

Binary_To_7seg  B_T_S (.bin(bin),.seg(seg));

initial begin
    gray = 4'b0000; 
	#10;
    gray = 4'b0001;
	#10;
    gray = 4'b0011;
	#10;
    gray = 4'b0010;
	#10;
    gray = 4'b0110; 
	#10;
    gray = 4'b0111;
	#10;
    gray = 4'b0101;
	#10;
    gray = 4'b0100;
	#10;

    $stop;
end
endmodule

 