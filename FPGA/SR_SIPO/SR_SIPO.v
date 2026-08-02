`default_nettype none

module SR_SIPO
#(
    parameter n = 4
)

(
    input wire s_in,
    input wire clk,
    input wire reset,
    output reg [n-1:0] s_out
);

	always @(posedge clk or negedge reset)
	begin
		if (!reset)
			s_out <= 4'b0000;
		else
		begin
			s_out[n-4] <= s_in;
			s_out[n-3] <= s_out[n-4];
			s_out[n-2] <= s_out[n-3];
			s_out[n-1] <= s_out[n-2];
		end
	end

endmodule


/*
كود البشمهندس 

module shiftR_SIPO
#(parameter   size=4)
(
    input clk,
    input reset,
    input sin,
    output reg [size-1:0]sout
);
  //reg[2:0]  s.shift;
  always@(posedge clk, negedge clk)
    begin
      if (reset)  sout<= {size{1'b0}};    
	  else        
	    begin
		 //1101
		// s.shift<=(sout>>1);
		  sout<= (sin<<3)|(sout>>1); //sout[size-1:1]
		end
	end	
endmodule
*/