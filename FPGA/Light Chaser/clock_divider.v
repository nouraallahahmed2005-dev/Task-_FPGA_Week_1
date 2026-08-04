module clock_divider
(
    input wire clk_in,
    input wire reset,
    output reg clk_out
);

reg [24:0] counter;

always @(posedge clk_in or posedge reset)
begin
    if (reset)
    begin
        counter <= 25'b0;
        clk_out <= 1'b0;
    end
    else
    begin
        if(counter == 25_000_000-1)
        begin
            counter <= 0;
            clk_out <= ~clk_out;
        end
        else
            counter <= counter + 1;
    end
end

endmodule