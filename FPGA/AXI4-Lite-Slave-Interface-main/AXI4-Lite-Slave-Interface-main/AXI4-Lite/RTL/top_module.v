`default_nettype none
module top_module 
#(
	parameter ARADDR_WIDTH = 7,
    parameter RDATA_WIDTH  = 32,
    parameter ADDR_WIDTH   = 7,
    parameter DATA_WIDTH   = 32
)
(	
	input wire ACLK,
	input wire ARESETN,
	
	input wire [ARADDR_WIDTH-1:0] ARADDR,
	input wire  ARVALID,
	output wire ARREADY,
	
	
	output wire [RDATA_WIDTH-1:0] RDATA,
	output wire [1:0] RRESP ,
	output wire RVALID ,
	input wire RREADY,
 

    input wire [ADDR_WIDTH-1:0]     AWADDR,
    input wire                      AWVALID,
    output wire                      AWREADY,

    input wire [DATA_WIDTH-1:0]     WDATA,
    input wire [DATA_WIDTH/8-1:0]   WSTRB,
    input wire                      WVALID,
    output wire                      WREADY,

    output wire [1:0]                BRESP,
    output wire                      BVALID,
    input wire                      BREADY	
);
//between Read & reg file
	wire read_enable;
	wire [ARADDR_WIDTH-1:0] read_address;
	wire [DATA_WIDTH-1:0] read_data;
	wire read_done;
	wire read_error;

	wire write_enable;
	wire [ADDR_WIDTH-1:0] write_address;
	wire [DATA_WIDTH-1:0] write_data;
	wire [DATA_WIDTH/8-1:0] write_strobe;
	wire write_done;
	wire write_error; 
	
	

	Read_Controller #(.RDATA_WIDTH(RDATA_WIDTH) , .ARADDR_WIDTH(ARADDR_WIDTH)) RC 
    (.ACLK(ACLK) ,
	 .ARESETN(ARESETN) ,
	 .ARADDR(ARADDR),
	 .ARVALID(ARVALID),
	 .ARREADY(ARREADY),
     .read_enable(read_enable),
	 .read_address(read_address),
	 .read_data(read_data),
	 .read_done(read_done),
	 .read_error(read_error),
	 .RDATA(RDATA),
	 .RRESP(RRESP) ,
	 .RVALID(RVALID),
     .RREADY(RREADY)	
    );

    
	reg_file #(.DATA_WIDTH(DATA_WIDTH),.ADDR_WIDTH(ADDR_WIDTH))RF 
    (.ACLK(ACLK),
    .ARESETN(ARESETN),
    .write_enable(write_enable),
    .write_address(write_address),
    .write_data(write_data),
    .write_strobe(write_strobe),
    .write_done(write_done),
    .write_error(write_error),
    .read_enable(read_enable),
    .read_address(read_address[ADDR_WIDTH-1:0]),
    .read_data(read_data),
    .read_done(read_done),
    .read_error(read_error));


	write_controller
#(
	.DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) WC
(
    .ACLK(ACLK),
    .ARESETN(ARESETN),
    .AWADDR(AWADDR),
    .AWVALID(AWVALID),
    .AWREADY(AWREADY),
    .WDATA(WDATA),
    .WSTRB(WSTRB),
    .WVALID(WVALID),
    .WREADY(WREADY),
    .BRESP(BRESP),
    .BVALID(BVALID),
    .BREADY(BREADY),

    .write_enable(write_enable),
    .write_address(write_address),
    .write_data(write_data),
    .write_strobe(write_strobe),
    .write_done(write_done),
    .write_error(write_error)
);
	
endmodule
	
