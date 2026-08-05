module Light_Chaser
(
    input wire clk,
    input wire reset,
    input wire hold,
    output reg [3:0] SR_out
);

always @(posedge clk or negedge reset)
begin
    if(!reset)
        SR_out <= 4'b0111;

    else if(!hold)
        SR_out <= SR_out;

    else
    begin
	
	/*
        SR_out[3] <= SR_out[0];
        SR_out[2] <= SR_out[3];
        SR_out[1] <= SR_out[2];
        SR_out[0] <= SR_out[1];
		*/
	
	SR_out <= {SR_out[0], SR_out[3:1]};

	
    end
end

endmodule