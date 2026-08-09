module Rising_edge_moore
(
	input wire clk,
	input wire level,
	input wire restn,
	output reg tick
);

localparam [1:0] s0 = 2'b00,  
				 s1 = 2'b01,   
				 s2 = 2'b10; 
		
reg [1:0] present_state ,next_state;


always @(posedge clk or negedge restn)
begin
	if (!restn)
		present_state <= s0;
	else
		present_state <= next_state;
end
always @(*)
begin
	next_state = present_state;
	case (present_state)
		s0: 
		 begin
            if (!level)
                next_state = s0;
            else
                next_state = s1;
        end

        s1:
        begin
            next_state = s2;
        end

        s2:
        begin
            if (level)
                next_state = s2;
            else
                next_state = s0;
        end

        default:
            next_state = s0;

    endcase
end

always @(*)
begin
	case(present_state)
	s0: tick = 1'b0;
	s1: tick = 1'b1;
	s2: tick = 1'b0;
	default: tick = 1'b0;
	endcase
end	
	
endmodule
	
