`default_nettype none
module FSM
(
	input wire clk ,rst_n,
	input wire a,b ,
	output wire y0,y1 

);
localparam s0=2'b00,
		    s1=2'b01,
			s2=2'b10;
			
	reg [1:0] present_state ,next_state;  //seq , combin
	// state register
	always @(posedge clk , negedge rst_n)
	begin : present_state_logic
		if (~rst_n)
			present_state <= s0;
		else
			present_state <= next_state;
	end
		
	always @(*)
	begin : next_state_logic
	next_state=present_state;
		case (present_state)
			s0: 
				begin
					case({a,b})
						2'b10: next_state=s1;
						2'b11: next_state=s2;
					endcase
				end
				s1: 
					begin
					case({a,b})
						
						2'b10: next_state=s0;
						2'b11: next_state=s0;
					endcase		
					end
				s2 :next_state=s0;
		endcase
	end
	//output logic
	//moore output  depend on state
	assign y1= (present_state ==s0) || (present_state==s1);
	
	
	//meely output
	assign y0 = (present_state == s0) && (a&b);
	
	
	
	
endmodule
	

