module priority_encoder_tb;

reg [3:0] I;
wire [1:0] Y;
wire valid;

priority_encoder p0 (
    .I(I),
    .Y(Y),
    .valid(valid)
);

initial
begin
	I[0] = 1;
    #10;
    I = 4'b0100;
    $display("Input : %4b, Valid %1b, Output : %2b", I, valid, Y);

    #10;
    I = 4'b1000;
    $display("Input : %4b, Valid %1b, Output : %2b", I, valid, Y);

    #10;
    I = 4'b0010;
    $display("Input : %4b, Valid %1b, Output : %2b", I, valid, Y);

    #10;
    I = 4'b0001;
    $display("Input : %4b, Valid %1b, Output : %2b", I, valid, Y);

    #10;
    I = 4'b1100;
    $display("Input : %4b, Valid %1b, Output : %2b", I, valid, Y);

    #10;
    I = 4'b0000;
    $display("Input : %4b, Valid %1b, Output : %2b", I, valid, Y);

    $stop;

end

endmodule