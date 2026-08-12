`default_nettype none
module stream_parity_gen_tbn;
reg clk;
reg rest_n;
reg serial_in;
wire p_out;

stream_parity_gen dut (
    .clk(clk),
    .rest_n(rest_n),
    .serial_in(serial_in),
    .p_out(p_out)
);

always #5 clk = ~clk;
task send_bit;
    input bit_value;
    begin
        @(negedge clk);
        serial_in = bit_value;

        @(posedge clk);
        #1;
    end
endtask

task send_byte;
    input [7:0] data;
    integer i;

    begin
        for (i = 7; i >= 0; i = i - 1)
        begin
            send_bit(data[i]);
        end
    end
endtask

initial
	begin
		clk       = 1'b0;
		rest_n    = 1'b0;
		serial_in = 1'b0;
		#12;
		rest_n = 1'b1;

		send_byte(8'b10110010);
		send_byte(8'b11110000);
		send_byte(8'b10101010);

		#20;
		$stop;
	end

endmodule