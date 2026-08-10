`default_nettype none
module nonoverlapping_mealy
(
    input  wire clk,
    input  wire rest_n,
    input  wire num,
    output reg  out
);

reg [2:0] present_state, next_state;

localparam s0 = 3'b000,
           s1 = 3'b001,
           s2 = 3'b010,
           s3 = 3'b011,
           s4 = 3'b100,
           s5 = 3'b101;

always @(posedge clk or negedge rest_n)
begin
    if (!rest_n)
        present_state <= s0;
    else
        present_state <= next_state;
end

always @(*)
begin
    next_state = present_state;
    out = 1'b0;

    case(present_state)

        s0:
        begin
            if (num)
                next_state = s1;
            else
                next_state = s0;
        end

        s1:
        begin
            if (num)
                next_state = s2;
            else
                next_state = s0;
        end

        s2:
        begin
            if (num)
                next_state = s2;
            else
                next_state = s3;
        end

        s3:
        begin
            if (num)
                next_state = s4;
            else
                next_state = s0;
        end

        s4:
        begin
            if (num)
                next_state = s2;
            else
                next_state = s5;
        end

        s5:
        begin
            if (num)
            begin
       
                out = 1'b1;
                next_state = s0;
            end
            else
                next_state = s0;
        end

        default:
            next_state = s0;

    endcase
end

endmodule