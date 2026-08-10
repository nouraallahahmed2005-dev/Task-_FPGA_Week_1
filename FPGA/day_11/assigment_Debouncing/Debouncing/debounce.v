`default_nettype none
module debounce
(
    input wire clk,
    input wire rest_n,
    input wire sw,
    output reg db
);

localparam zero   = 4'b0000,
           wait0_1 = 4'b0001,
           wait0_2 = 4'b0010,
           wait0_3 = 4'b0011,
           one     = 4'b0100,
           wait1_1 = 4'b0101,
           wait1_2 = 4'b0110,
           wait1_3 = 4'b0111;

reg [3:0] present_state, next_state;
reg [18:0] counter;  //2**19
reg m_tick;

always @(posedge clk or negedge rest_n)
	begin
		if (!rest_n)
		begin
			counter <= 0;
			m_tick <= 0;
		end
		else
		begin
			if (counter == 19'd499_999)					//if (counter == 19'd1)  for testbench
				begin
					counter <= 0;
					m_tick <= 1;
				end
				else
				begin
					counter <= counter + 1;
					m_tick <= 0;
				end
		end
	end

always @(posedge clk or negedge rest_n)
begin
    if (!rest_n)
        present_state <= zero;
    else
        present_state <= next_state;
end

always @(*)
	begin
		case (present_state)

			zero:
			begin
				if (sw)
					next_state = wait0_1;
				else
					next_state = zero;
			end

			wait0_1:
			begin
				if (!sw)
					next_state = zero;
				else if (m_tick)
					next_state = wait0_2;
				else
					next_state = wait0_1;
			end

			wait0_2:
			begin
				if (!sw)
					next_state = zero;
				else if (m_tick)
					next_state = wait0_3;
				else
					next_state = wait0_2;
			end

			wait0_3:
			begin
				if (!sw)
					next_state = zero;
				else if (m_tick)
					next_state = one;
				else
					next_state = wait0_3;
			end

			one:
			begin
				if (!sw)
					next_state = wait1_1;
				else
					next_state = one;
			end

			wait1_1:
			begin
				if (sw)
					next_state = one;
				else if (m_tick)
					next_state = wait1_2;
				else
					next_state = wait1_1;
			end

			wait1_2:
			begin
				if (sw)
					next_state = one;
				else if (m_tick)
					next_state = wait1_3;
				else
					next_state = wait1_2;
			end

			wait1_3:
			begin
				if (sw)
					next_state = one;
				else if (m_tick)
					next_state = zero;
				else
					next_state = wait1_3;
			end

			default:
				next_state = zero;

		endcase
	end
always @(*)
	begin
		case (present_state)

			zero, wait0_1, wait0_2, wait0_3:
				db = 1'b0;

			one, wait1_1, wait1_2, wait1_3:
				db = 1'b1;

			default:
				db = 1'b0;

		endcase
	end

endmodule