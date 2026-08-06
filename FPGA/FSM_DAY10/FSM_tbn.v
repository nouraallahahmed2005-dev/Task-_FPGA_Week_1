
module FSM_tbn;

	reg clk ,rst_n;
	reg a,b ;
	wire y0,y1 ; 
	
FSM fsm0 (.*);

always #10 clk= ~clk ;

initial 
	begin
		clk =1'b0;
		rst_n= 1'b0 ;
		#10;
		rst_n=1'b1;
		{a,b} =2'b11;
		#10;
		
		{a,b} =2'b10;
		#15;
		{a,b} =2'b01;
		#20;
		{a,b} =2'b10;
		#20;
		{a,b} =2'b11;
		#45;
		#20;
		$stop;

	end
endmodule




