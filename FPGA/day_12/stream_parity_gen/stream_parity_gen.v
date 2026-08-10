`default_nettype none
module stream_parity_gen
(
	input wire clk,
	input wire rest_n,
	input wire serial_in,
	output reg p_out
);
reg [7:0] shift_reg;

function parity_calc (input [7:0]data);
	integer i;
	begin
		parity_calc = 1'b0;
		for (i = 0;i<=7; i=i+1)
			parity_calc = parity_calc ^ data[i];
	end
endfunction

always @(posedge clk or negedge rest_n)
begin
    if (!rest_n)
    begin
        shift_reg <= 8'b0;
        p_out <= 1'b0;
    end
    else
    begin
        shift_reg <= {shift_reg[6:0], serial_in};
        p_out <= parity_calc({shift_reg[6:0], serial_in});
    end
end

endmodule
