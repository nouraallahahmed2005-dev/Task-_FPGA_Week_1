`timescale 1ns/1ps

module top_module_tb;

    parameter ARADDR_WIDTH = 7;
    parameter RDATA_WIDTH  = 32;
    parameter ADDR_WIDTH   = 7;
    parameter DATA_WIDTH   = 32;

    reg ACLK;
    reg ARESETN;

    reg [ARADDR_WIDTH-1:0] ARADDR;
    reg ARVALID;
    wire ARREADY;

    wire [RDATA_WIDTH-1:0] RDATA;
    wire [1:0] RRESP;
    wire RVALID;
    reg RREADY;

    reg [ADDR_WIDTH-1:0] AWADDR;
    reg AWVALID;
    wire AWREADY;

    reg [DATA_WIDTH-1:0] WDATA;
    reg [DATA_WIDTH/8-1:0] WSTRB;
    reg WVALID;
    wire WREADY;

    wire [1:0] BRESP;
    wire BVALID;
    reg BREADY;

    reg [1:0] captured_bresp;
    reg [1:0] captured_rresp;
    reg [DATA_WIDTH-1:0] captured_rdata;

    integer pass_count;
    integer fail_count;


    top_module DUT (
        .ACLK(ACLK),
        .ARESETN(ARESETN),

        .ARADDR(ARADDR),
        .ARVALID(ARVALID),
        .ARREADY(ARREADY),

        .RDATA(RDATA),
        .RRESP(RRESP),
        .RVALID(RVALID),
        .RREADY(RREADY),

        .AWADDR(AWADDR),
        .AWVALID(AWVALID),
        .AWREADY(AWREADY),

        .WDATA(WDATA),
        .WSTRB(WSTRB),
        .WVALID(WVALID),
        .WREADY(WREADY),

        .BRESP(BRESP),
        .BVALID(BVALID),
        .BREADY(BREADY)
    );


    always #5 ACLK = ~ACLK;


    task reset_dut;
        begin
            @(negedge ACLK);

            ARESETN = 1'b0;

            ARADDR  = '0;
            ARVALID = 1'b0;
            RREADY  = 1'b0;

            AWADDR  = '0;
            AWVALID = 1'b0;

            WDATA   = '0;
            WSTRB   = '0;
            WVALID  = 1'b0;

            BREADY  = 1'b0;

            captured_bresp = 2'b00;
            captured_rresp = 2'b00;
            captured_rdata = '0;

            repeat (3)
                @(negedge ACLK);

            ARESETN = 1'b1;

            @(negedge ACLK);
        end
    endtask


    task axi_write;
        input [ADDR_WIDTH-1:0] addr;
        input [DATA_WIDTH-1:0] data;
        input [DATA_WIDTH/8-1:0] strb;

        reg aw_done;
        reg w_done;

        begin

            aw_done = 1'b0;
            w_done  = 1'b0;

            captured_bresp = 2'bxx;

            @(negedge ACLK);

            AWADDR  = addr;
            AWVALID = 1'b1;

            WDATA   = data;
            WSTRB   = strb;
            WVALID  = 1'b1;

            while (!aw_done || !w_done) begin

                @(posedge ACLK);

                if (AWVALID && AWREADY)
                    aw_done = 1'b1;

                if (WVALID && WREADY)
                    w_done = 1'b1;

                @(negedge ACLK);

                if (aw_done)
                    AWVALID = 1'b0;

                if (w_done)
                    WVALID = 1'b0;

            end

            BREADY = 1'b0;

            while (!BVALID)
                @(posedge ACLK);

            @(negedge ACLK);

            BREADY = 1'b1;

            @(posedge ACLK);

            if (BVALID && BREADY)
                captured_bresp = BRESP;

            @(negedge ACLK);

            BREADY = 1'b0;

        end
    endtask


    task axi_read;
        input [ARADDR_WIDTH-1:0] addr;

        begin
			 ARADDR  = 32'hxxxxxxxx;
            captured_rresp = 2'bxx;
            captured_rdata = 'x;
			

            @(negedge ACLK);

            ARADDR  = addr;
            ARVALID = 1'b1;

            while (!(ARVALID && ARREADY))
                @(posedge ACLK);

            @(negedge ACLK);

            ARVALID = 1'b0;

            RREADY = 1'b0;

            while (!RVALID)
                @(posedge ACLK);

            @(negedge ACLK);

            RREADY = 1'b1;

            @(posedge ACLK);

            if (RVALID && RREADY) begin
                captured_rresp = RRESP;
                captured_rdata = RDATA;
            end

            @(negedge ACLK);

            RREADY = 1'b0;

        end
    endtask


    task check_write_response;
        input [1:0] expected_resp;
        input [8*40-1:0] test_name;

        begin

            if (captured_bresp === expected_resp) begin

                $display(
                    "[PASS] %s | BRESP = %b",
                    test_name,
                    captured_bresp
                );

                pass_count = pass_count + 1;

            end

            else begin

                $display(
                    "[FAIL] %s | Expected BRESP = %b, Got = %b",
                    test_name,
                    expected_resp,
                    captured_bresp
                );

                fail_count = fail_count + 1;

            end

        end
    endtask


    task check_read_response;
        input [1:0] expected_resp;
        input [DATA_WIDTH-1:0] expected_data;
        input [8*40-1:0] test_name;

        begin

            if ((captured_rresp === expected_resp) &&
                (captured_rdata === expected_data)) begin

                $display(
                    "[PASS] %s | RRESP = %b | RDATA = %h",
                    test_name,
                    captured_rresp,
                    captured_rdata
                );

                pass_count = pass_count + 1;

            end

            else begin

                $display(
                    "[FAIL] %s | Expected RRESP = %b RDATA = %h | Got RRESP = %b RDATA = %h",
                    test_name,
                    expected_resp,
                    expected_data,
                    captured_rresp,
                    captured_rdata
                );

                fail_count = fail_count + 1;

            end

        end
    endtask


    initial begin

        ACLK = 1'b0;
        ARESETN = 1'b0;

        ARADDR  = '0;
        ARVALID = 1'b0;
        RREADY  = 1'b0;

        AWADDR  = '0;
        AWVALID = 1'b0;

        WDATA   = '0;
        WSTRB   = '0;
        WVALID  = 1'b0;

        BREADY  = 1'b0;

        captured_bresp = 2'b00;
        captured_rresp = 2'b00;
        captured_rdata = '0;

        pass_count = 0;
        fail_count = 0;


        reset_dut;


        $display("");
        $display("==========================================");
        $display("TEST 1: NORMAL WRITE");
        $display("==========================================");

        axi_write(
            7'h00,
            32'h12345678,
            4'b1111
        );

        check_write_response(
            2'b00,
            "Normal Write"
        );


        $display("");
        $display("==========================================");
        $display("TEST 2: READ AFTER WRITE");
        $display("==========================================");

        axi_read(32'h00);

        check_read_response(
            2'b00,
            32'h12345678,
            "Read After Write"
        );


        $display("");
        $display("==========================================");
        $display("TEST 3: BYTE STROBE");
        $display("==========================================");

        axi_write(
            7'h00,
            32'hAABBCCDD,
            4'b0011
        );

        check_write_response(
            2'b00,
            "Byte Strobe Write"
        );

        axi_read(32'h00);

        check_read_response(
            2'b00,
            32'h1234CCDD,
            "Byte Strobe Read"
        );


        $display("");
        $display("==========================================");
        $display("TEST 4: ADDRESS FIRST");
        $display("==========================================");

        @(negedge ACLK);

        AWADDR  = 7'h04;
        AWVALID = 1'b1;

        while (!(AWVALID && AWREADY))
            @(posedge ACLK);

        @(negedge ACLK);

        AWVALID = 1'b0;

        WDATA   = 32'hCAFEBABE;
        WSTRB   = 4'b1111;
        WVALID  = 1'b1;

        while (!(WVALID && WREADY))
            @(posedge ACLK);

        @(negedge ACLK);

        WVALID = 1'b0;

        BREADY = 1'b0;

        while (!BVALID)
            @(posedge ACLK);

        @(negedge ACLK);

        BREADY = 1'b1;

        @(posedge ACLK);

        if (BVALID && BREADY)
            captured_bresp = BRESP;

        @(negedge ACLK);

        BREADY = 1'b0;

        check_write_response(
            2'b00,
            "Address First"
        );

        axi_read(32'h04);

        check_read_response(
            2'b00,
            32'hCAFEBABE,
            "Address First Readback"
        );


        $display("");
        $display("==========================================");
        $display("TEST 5: DATA FIRST");
        $display("==========================================");

        @(negedge ACLK);

        WDATA   = 32'hDEADBEEF;
        WSTRB   = 4'b1111;
        WVALID  = 1'b1;

        while (!(WVALID && WREADY))
            @(posedge ACLK);

        @(negedge ACLK);

        WVALID = 1'b0;

        AWADDR  = 7'h08;
        AWVALID = 1'b1;

        while (!(AWVALID && AWREADY))
            @(posedge ACLK);

        @(negedge ACLK);

        AWVALID = 1'b0;

        BREADY = 1'b0;

        while (!BVALID)
            @(posedge ACLK);

        @(negedge ACLK);

        BREADY = 1'b1;

        @(posedge ACLK);

        if (BVALID && BREADY)
            captured_bresp = BRESP;

        @(negedge ACLK);

        BREADY = 1'b0;

        check_write_response(
            2'b00,
            "Data First"
        );

        axi_read(32'h08);

        check_read_response(
            2'b00,
            32'hDEADBEEF,
            "Data First Readback"
        );


        $display("");
        $display("==========================================");
        $display("TEST 6: WRITE TO READ-ONLY COUNTER");
        $display("==========================================");

        axi_write(
            7'h70,
            32'hFFFFFFFF,
            4'b1111
        );

        check_write_response(
            2'b10,
            "Write To Counter"
        );


        $display("");
        $display("==========================================");
        $display("TEST 7: READ WRITE COUNTER");
        $display("==========================================");

        axi_read(32'h7C);

        check_read_response(
            2'b00,
            32'h00000004,
            "Write Counter"
        );


        $display("");
        $display("==========================================");
        $display("TEST 8: UNALIGNED WRITE");
        $display("==========================================");

        axi_write(
            7'h01,
            32'h11111111,
            4'b1111
        );

        check_write_response(
            2'b10,
            "Unaligned Write"
        );


        $display("");
        $display("==========================================");
        $display("TEST 9: UNALIGNED READ");
        $display("==========================================");

        axi_read(32'h01);

        check_read_response(
            2'b10,
            32'h00000000,
            "Unaligned Read"
        );


        $display("");
        $display("==========================================");
        $display("FINAL RESULTS");
        $display("==========================================");

        $display("TOTAL PASSED = %0d", pass_count);
        $display("TOTAL FAILED = %0d", fail_count);

        if (fail_count == 0) begin

            $display("");
            $display("**************************************");
            $display("*        ALL TESTS PASSED            *");
            $display("**************************************");
            $display("");

        end

        else begin

            $display("");
            $display("**************************************");
            $display("*        TESTS FAILED                *");
            $display("**************************************");
            $display("");

        end

        #50;

        $stop;

    end

endmodule