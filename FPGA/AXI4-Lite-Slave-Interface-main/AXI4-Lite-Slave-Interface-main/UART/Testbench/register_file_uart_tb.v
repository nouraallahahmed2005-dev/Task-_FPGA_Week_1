`default_nettype none 
`timescale 1ns/1ns
module register_file_uart_tb;

  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 5;
  parameter CLKS_PER_BIT= 4;
  
  reg ACLK;
  reg ARESETN;
  
  reg write_enable;
  reg [ADDR_WIDTH-1:0] write_address;
  reg [DATA_WIDTH-1:0] write_data;
  reg [DATA_WIDTH/8-1:0] write_strobe;
  
  reg read_enable;
  reg [ADDR_WIDTH-1:0] read_address;
  
  wire write_done;
  wire write_error;
  
  wire [DATA_WIDTH-1:0] read_data;
  wire read_done;
  wire read_error;
  
  reg rx;
  
  wire tx;
  
  topmodule #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH), .CLKS_PER_BIT(CLKS_PER_BIT) ) top (.*);
  
  always #5 ACLK = ~ ACLK ; 
  
  initial
    begin
	  ACLK = 1'b0;
	  ARESETN = 1'b0; 
	  
	  #10; 
	  
	  ARESETN = 1'b1;
	  rx = 1;
	  
	  
	  @(posedge ACLK); rx = 0;
	  
	  write_enable=1'b1; 
	  write_address=5'b00100;
	  write_data=32'hABCD_1234;
	  write_strobe=4'b1111;

	  @(posedge ACLK); 
	  write_enable=1'b0; 
      

      repeat(2) @(posedge ACLK); write_enable=1'b1; 
	  write_address=5'b00100;
	  write_data=32'hEF98_7654;
	  write_strobe=4'b1111;
	  
	  @(posedge ACLK); 
	  write_enable=1'b0;
	  
	  @(posedge ACLK);
	  
      rx = 0; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);

	  rx = 1; repeat(4) @(posedge ACLK);

	  rx = 0; repeat(4) @(posedge ACLK);

	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);

	  rx = 1; repeat(4) @(posedge ACLK);

	  rx = 0; repeat(4) @(posedge ACLK);

	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);

	  rx = 1; repeat(4) @(posedge ACLK);

	  rx = 0; repeat(4) @(posedge ACLK);

	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);
	  rx = 0; repeat(4) @(posedge ACLK);
	  rx = 1; repeat(4) @(posedge ACLK);

	  rx = 1; repeat(4) @(posedge ACLK);

	  #40; $stop;
	end

endmodule