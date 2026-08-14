`default_nettype none
module reg_file #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 5
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

  output reg write_done,
  output reg write_error,

  output reg [DATA_WIDTH-1:0] read_data,
  output reg read_done,
  output reg read_error,
	
  input  wire                  tx_busy,
  output wire [DATA_WIDTH-1:0] tx_data,
  output reg                  tx_start,
  
  input  wire [DATA_WIDTH-1:0] rx_data,
  input  wire rx_valid
);

  localparam NUM_REGS   = (2**ADDR_WIDTH) / (DATA_WIDTH/8);
  localparam NUM_BYTES  = DATA_WIDTH/8;
  localparam ADDR_LSB   = $clog2(NUM_BYTES);

  localparam WRITE_COUNTER_ADDR       = NUM_REGS - 1;
  localparam READ_COUNTER_ADDR        = NUM_REGS - 2;
  localparam WRITE_ERROR_COUNTER_ADDR = NUM_REGS - 3;
  localparam READ_ERROR_COUNTER_ADDR  = NUM_REGS - 4;

  reg [DATA_WIDTH-1:0] data_array [0:NUM_REGS-1];

  wire [2:0] type_array [0:NUM_REGS-1];   // R = 4 => 3'b100, W = 2 => 3'b010, RW = 6 => 3'b110

  assign type_array[0] = 3'b100; //RX
  assign type_array[1] = 3'b010; //TX
  assign type_array[2] = 3'b010;
  assign type_array[3] = 3'b110;

  assign type_array[WRITE_COUNTER_ADDR]       = 3'b100;
  assign type_array[READ_COUNTER_ADDR]        = 3'b100;
  assign type_array[WRITE_ERROR_COUNTER_ADDR] = 3'b100;
  assign type_array[READ_ERROR_COUNTER_ADDR]  = 3'b100;

  assign tx_data=data_array[1];

  integer i;
  integer j;

  always @(posedge ACLK or negedge ARESETN) 
    begin
      if (!ARESETN) 
	    begin

          for (i = 0; i < NUM_REGS; i = i + 1)
            data_array[i] <= '0;

          write_done  <= 1'b0;
          write_error <= 1'b0;

          read_done   <= 1'b0;
          read_error  <= 1'b0;
          read_data   <= '0;
		
		  tx_start    <= 1'b0;
        end

      else 
	    begin

          write_done  <= 1'b0;
          write_error <= 1'b0;

          read_done   <= 1'b0;
          read_error  <= 1'b0;
		
		  tx_start <= 1'b0;
		
		  if (rx_valid) data_array[0] <= rx_data;

          if (write_enable) 
		    begin

              if ((write_address[ADDR_LSB-1:0] == '0) &&
                 ((write_address >> ADDR_LSB) < NUM_REGS) &&
				 !(write_address == NUM_BYTES && tx_busy == 1'b1) &&
                  (type_array[write_address >> ADDR_LSB] == 3'b110 ||
                   type_array[write_address >> ADDR_LSB] == 3'b010)) 
				begin

                  for (j = 0; j < NUM_BYTES; j = j + 1) 
				    begin
                      if (write_strobe[j])
                        data_array[write_address >> ADDR_LSB][(8*j) +: 8]
                            <= write_data[(8*j) +: 8];
                    end

                  write_done <= 1'b1;
				
				  data_array[WRITE_COUNTER_ADDR] <=
                  data_array[WRITE_COUNTER_ADDR] + 1'b1;
				
				  if (write_address==NUM_BYTES) tx_start <= 1'b1;
                end

              else 
		        begin
                  write_error <= 1'b1;
				
				  data_array[WRITE_ERROR_COUNTER_ADDR] <= 
                  data_array[WRITE_ERROR_COUNTER_ADDR] + 1'b1;
                end
            end

          if (read_enable) 
		    begin

              if ((read_address[ADDR_LSB-1:0] == '0) &&
                 ((read_address >> ADDR_LSB) < NUM_REGS) &&
                 (type_array[read_address >> ADDR_LSB] == 3'b100 ||
                  type_array[read_address >> ADDR_LSB] == 3'b110 )) 
				begin

                  read_data <= data_array[read_address >> ADDR_LSB];
                  read_done <= 1'b1;
				
				  data_array[READ_COUNTER_ADDR] <= 
                  data_array[READ_COUNTER_ADDR] + 1'b1;
                end

              else 
			    begin
                  read_error <= 1'b1;
				
				  data_array[READ_ERROR_COUNTER_ADDR] <= 
                  data_array[READ_ERROR_COUNTER_ADDR] + 1'b1;
                end
            end

        end
  end

endmodule

