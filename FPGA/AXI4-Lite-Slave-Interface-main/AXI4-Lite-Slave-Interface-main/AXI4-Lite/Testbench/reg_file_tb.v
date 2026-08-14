`default_nettype none 
`timescale 1ns/1ns
module reg_file_tb;

  parameter DATA_WIDTH = 32;
  parameter ADDR_WIDTH = 5;
  
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
  
  reg_file #(.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH) ) register (.*);
  
  always #5 ACLK = ~ ACLK ; 
  
  initial
    begin
	  ACLK = 1'b0;
	  ARESETN = 1'b0; #3; ARESETN = 1'b1;
	  
	  
	  @(posedge ACLK); write_enable=1'b1; read_enable=1'b1;
	  write_address=5'b01100;
	  write_data=32'hABCD_1234;
	  write_strobe=4'b1010;
	
	  read_address=5'b00101;

      #5;
	  
	  wait (read_done || read_error); read_enable = 1'b0;

      wait (write_done || write_error); write_enable = 1'b0;
	  

	  @(posedge ACLK); write_enable=1'b1; read_enable=1'b1;
	  write_address=5'b00100;
	  write_data=32'hEF98_7654;
	  write_strobe=4'b1111;
	
	  read_address=5'b01100;
	  
	  #5;

	  wait (read_done || read_error); read_enable = 1'b0;

      wait (write_done || write_error); write_enable = 1'b0;
	  

	  @(posedge ACLK); write_enable=1'b1; read_enable=1'b1;
	  write_address=5'b01101;
	  write_data=32'hEF98_7654;
	  write_strobe=4'b1111;
	  
	  read_address=5'b00100;

	  #5;

	  wait (read_done || read_error); read_enable = 1'b0;

      wait (write_done || write_error); write_enable = 1'b0;

	  @(posedge ACLK); write_enable=1'b1; read_enable=1'b1;
	  write_address=5'b11100;
	  write_data=32'hABCD_1234;
	  write_strobe=4'b1010;
	
	  read_address=5'b11100;
	  
	  #5;

	  wait (read_done || read_error); read_enable = 1'b0;

      wait (write_done || write_error); write_enable = 1'b0;
	  
	  #50; $stop;
	end

endmodule