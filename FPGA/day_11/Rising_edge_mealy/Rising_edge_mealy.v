module Rising_edge_mealy
(
    input  wire clk,
    input  wire level,
    input  wire restn,
    output reg  tick
);

localparam s0 = 1'b0,
           s1 = 1'b1;

reg [1:0] present_state ,next_state;

always @(posedge clk or negedge restn)
begin
    if (!restn)
        present_state <= s0;
		tick <= 1'b0,
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
            if (level)
                next_state = s1;
            else
                next_state = s0;
        end

        default:
            next_state = s0;

    endcase
end

always @(*)
begin
    case (present_state)

        s0:
        begin
            if (level)
                tick = 1'b1;
            else
                tick = 1'b0;
        end

        s1:
        begin
            tick = 1'b0;
        end

        default:
            tick = 1'b0;

    endcase
end

endmodule