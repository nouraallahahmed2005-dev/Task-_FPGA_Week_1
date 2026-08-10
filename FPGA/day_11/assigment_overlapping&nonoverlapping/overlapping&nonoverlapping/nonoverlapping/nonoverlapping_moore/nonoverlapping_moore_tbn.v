`default_nettype none
module nonoverlapping_moore_tbn;

reg clk;
reg rest_n;
reg num;
wire out;

nonoverlapping_moore nm (.*);

always #5 clk = ~clk;

initial
begin
    clk    = 1'b0;
    rest_n = 1'b0;
  

    #10;
    rest_n = 1'b1;

    num = 1'b1; #10;
    num = 1'b1; #10;
    num = 1'b0; #10;
    num = 1'b1; #10;
    num = 1'b0; #10;
    num = 1'b1; 
	#20;

    num = 1'b1; #10;
    num = 1'b1; #10;
    num = 1'b0; #10;
    num = 1'b1; #10;
    num = 1'b0; #10;
    num = 1'b0; #10;

    #20;

    $stop;
end

endmodule