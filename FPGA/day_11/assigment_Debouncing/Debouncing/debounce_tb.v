
module debounce_tb;

reg clk;
reg rest_n;
reg sw;

wire db;

debounce uut
(
    .clk(clk),
    .rest_n(rest_n),
    .sw(sw),
    .db(db)
);

always #5 clk = ~clk;

initial
begin
    clk = 0;
    rest_n = 0;
    sw = 0;

    #20;
    rest_n = 1;
    #20;

    sw = 1; #7;
    sw = 0;#8;
    sw = 1;#7;
    sw = 0;#6;
    sw = 1;
    #100;
	#5;
    sw = 0; #7;
    sw = 1;#8;
	sw = 0;#7;
    sw = 1;#6;
    sw = 0;
    #100;

    $stop;
end

endmodule