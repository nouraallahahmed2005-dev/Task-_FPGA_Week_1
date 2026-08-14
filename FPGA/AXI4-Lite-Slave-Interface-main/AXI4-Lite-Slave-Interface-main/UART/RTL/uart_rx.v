module uart_rx #(
  parameter DATA_WIDTH   = 32,
  parameter CLKS_PER_BIT = 4
)
(
  input  wire ACLK,
  input  wire ARESETN,

  input  wire rx,

  output reg [DATA_WIDTH-1:0] rx_data,
  output reg                  rx_valid
);

  localparam IDLE  = 2'b00,
             START = 2'b01,
             DATA  = 2'b10,
             STOP  = 2'b11;

  reg [1:0] present_state, next_state;

  reg [12:0] baud_counter;
  reg [2:0]  bit_counter;
  reg [3:0]  byte_counter;

  reg [DATA_WIDTH-1:0] rx_reg;

  localparam NUM_BYTE = DATA_WIDTH / 8;

  always @(posedge ACLK or negedge ARESETN)
    begin
      if (!ARESETN)
        begin
          present_state <= IDLE;
		  baud_counter  <= 0;
		  bit_counter   <= 0;
		  byte_counter  <= 0;
		  rx_reg        <= 0;
		  rx_data       <= 0;
		  rx_valid      <= 0;
        end

      else
		begin
		  present_state <= next_state;
		  rx_valid      <= 0;

          if (present_state == IDLE)
            begin
	          byte_counter <= 0;
	          if (next_state == START)
	            begin
                  baud_counter <= 0;
                  bit_counter  <= 0;
                  rx_reg <= 0;
		        end
            end

		  else if (present_state == START)
			begin
			  if (baud_counter == (CLKS_PER_BIT/2)-1) baud_counter <= 0;
		      else baud_counter <= baud_counter + 1;
		    end

		  else if (present_state == DATA)
			begin
			  if (baud_counter == CLKS_PER_BIT-1)
		        begin
			      baud_counter <= 0;

			      rx_reg[byte_counter*8 + bit_counter] <= rx;

			      if (bit_counter < 3'b111) bit_counter <= bit_counter + 1;
		        end

		      else baud_counter <= baud_counter + 1;

		      if (next_state == STOP)
				begin
				  bit_counter <= 0;

			      if (byte_counter < NUM_BYTE) byte_counter <= byte_counter + 1;
		        end
		    end

		  else if (present_state == STOP)
			begin
		      if (baud_counter == CLKS_PER_BIT+1)
		        begin
			      baud_counter <= 0;

			      if (next_state == IDLE)
			          begin
			            rx_data  <= rx_reg;
			            rx_valid <= 1'b1;
			          end
		        end

		      else baud_counter <= baud_counter + 1;
            end
        end
    end


  always @(*)
    begin
      next_state = present_state;

      case (present_state)

		IDLE:
		  if (!rx) next_state = START;

		START:
		  if (baud_counter == (CLKS_PER_BIT/2)-1) next_state = DATA;

		DATA:
		  if ((bit_counter == 3'b111) && (baud_counter == CLKS_PER_BIT-1))
              next_state = STOP;

		STOP:
		  begin
            if (baud_counter == CLKS_PER_BIT+1)
			  begin
				if (byte_counter == NUM_BYTE) next_state = IDLE;
                else next_state = START;
              end
          end

      endcase
	  
    end

endmodule