`default_nettype none
module stream_parity_gen_tbn;

	reg clk;
	reg rest_n;
	reg serial_in;
	wire p_out;
	
	
	
stream_parity_gen parity (.*);

always #5 clk= ~ clk;

initial 
	begin
		rest_n = 1'b0; clk=1'b0;
		#10;
		rest_n = 1'b1; #5;
		serial_in = 1'b0; #10;
		serial_in = 1'b1;#10;
		serial_in = 1'b1; #10;
		serial_in = 1'b0; #10;
		serial_in = 1'b1; #10;
		serial_in = 1'b0; #10;
		serial_in = 1'b0; #10;
		serial_in = 1'b0; #10;
		#25;
		serial_in = 1'b0; #10;
		serial_in = 1'b0; #10;
		serial_in = 1'b0; #10;
		serial_in = 1'b0; #10;
		serial_in = 1'b0; #10;
		serial_in = 1'b0; #10;
		serial_in = 1'b0; #10;
		serial_in = 1'b0; #10;
		
	#20;
	$stop;
	
	end
endmodule