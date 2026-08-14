`default_nettype none
`timescale 1ns/1ps

module Read_Controller_tbn;

parameter ARADDR_WIDTH = 32;
parameter RDATA_WIDTH  = 32;


reg ACLK;
reg ARESETN;



reg  [ARADDR_WIDTH-1:0] ARADDR;
reg  ARVALID;
wire ARREADY;



wire read_enable;
wire [ARADDR_WIDTH-1:0] read_address;


reg [RDATA_WIDTH-1:0] read_data;
reg read_done;
reg read_error;

wire [RDATA_WIDTH-1:0] RDATA;
wire [1:0] RRESP;
wire RVALID;



//wire [ARADDR_WIDTH-1:0] address_reg;
reg RREADY;



Read_Controller RC (.*);


always #5 ACLK = ~ACLK;


initial
begin

	 ACLK      = 1'b0;
	  ARESETN   = 1'b0;


    #10;

    ARESETN = 1'b1;

// state_ready
    @(posedge ACLK);

    ARADDR  = 32'h00000010;
    ARVALID = 1'b1;
	@(posedge ACLK);
	if (ARREADY)
	begin
        @(posedge ACLK);
        ARVALID = 1'b0;
        ARADDR  = 32'b0;
	end
	
//we ready to read data _state_read

    #30;

    read_data = 32'h12345678;
    read_done = 1'b1;
	
	#10.1;

  //  @(posedge ACLK);

    read_done = 1'b0;
    #50;
	//state_resp

    RREADY = 1'b1;
	#5
    @(posedge ACLK);
    RREADY = 1'b0;
	read_data = 32'b0;
    #20;
	// state_ready

    ARADDR  = 32'h00000020;
    ARVALID = 1'b1;
		#5
        @(posedge ACLK);
		ARADDR  = 32'b0;
         ARVALID = 1'b0;
  
	
//we ready to read data_state_read 

    #30;

    read_error = 1'b1;
	
	#10.1;
    read_error = 1'b0;
	
	//state_resp
    #20;

    RREADY = 1'b1;
	#5

    @(posedge ACLK);

    RREADY = 1'b0;



  #20;
//state(2)_read_time_out
    ARADDR  = 32'h00000030;
    ARVALID = 1'b1;
	#5

        @(posedge ACLK);
        ARVALID = 1'b0;
        ARADDR  = 32'b0;
   
//state_read

    #300;
	
	read_error = 1'b1;
	#10.1;

    read_error = 1'b0;
	
    #20;
// state RRESP
    RREADY = 1'b1;
	#5

    @(posedge ACLK);

    RREADY = 1'b0;


    $stop;

end

endmodule