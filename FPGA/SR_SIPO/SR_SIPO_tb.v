
module SR_SIPO_tb;

parameter n = 4;

reg s_in;
reg clk;
reg reset;

wire [n-1:0] s_out;

SR_SIPO #(.n(n)) SFR (.s_in(s_in),.clk(clk),.reset(reset),.s_out(s_out));

always #5 clk = ~clk;

initial
begin
    clk = 0;
    reset = 0;
    s_in = 0;
    #10;
    reset = 1;
    #10 
	s_in = 1;
    #10 
	s_in = 0;
    #10 
	s_in = 1;
    #10 
	s_in = 1;

    #20;
    $stop;
end

endmodule