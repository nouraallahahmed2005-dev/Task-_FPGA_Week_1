module topmodule#(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 5,
  parameter CLKS_PER_BIT= 4
)
(
  input wire ACLK,
  input wire ARESETN,
  
  input wire write_enable,
  input wire [ADDR_WIDTH-1:0] write_address,
  input wire [DATA_WIDTH-1:0] write_data,
  input wire [DATA_WIDTH/8-1:0] write_strobe,
  
  input wire read_enable,
  input wire [ADDR_WIDTH-1:0] read_address,
  
  output wire write_done,
  output wire write_error,
  
  output wire [DATA_WIDTH-1:0] read_data,
  output wire read_done,
  output wire read_error,
  
  input wire rx,
  
  output wire tx
);
  
  wire tx_busy;
  wire [DATA_WIDTH-1:0] tx_data;
  wire                 tx_start;
  
  wire [DATA_WIDTH-1:0] rx_data;
  wire rx_valid;
  
  
  reg_file# (.DATA_WIDTH(DATA_WIDTH), .ADDR_WIDTH(ADDR_WIDTH) ) 
           m(.ACLK(ACLK), .ARESETN(ARESETN),.write_enable(write_enable), .write_address(write_address),
             .write_data(write_data), .write_strobe(write_strobe), .read_enable(read_enable), .read_address(read_address),
			 .write_done(write_done), .write_error(write_error), .read_data(read_data), .read_done(read_done), .read_error(read_error),
             .tx_busy(tx_busy), .tx_data(tx_data), .tx_start(tx_start), .rx_data(rx_data), .rx_valid(rx_valid) );
					   
					   
  uart_tx# (.DATA_WIDTH(DATA_WIDTH), .CLKS_PER_BIT(CLKS_PER_BIT) )
         m1(.ACLK(ACLK), .ARESETN(ARESETN), .tx_busy(tx_busy), .tx_data(tx_data), .tx_start(tx_start), .tx(tx) );
		 
  uart_rx# (.DATA_WIDTH(DATA_WIDTH), .CLKS_PER_BIT(CLKS_PER_BIT) )
         m2(.ACLK(ACLK), .ARESETN(ARESETN), .rx_data(rx_data), .rx_valid(rx_valid), .rx(rx) );
            
endmodule