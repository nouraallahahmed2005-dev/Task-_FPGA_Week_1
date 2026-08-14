module uart_tx#(
  parameter DATA_WIDTH = 32,
  parameter CLKS_PER_BIT= 4
)
(
  input wire ACLK,
  input wire ARESETN,

  input  wire [DATA_WIDTH-1:0] tx_data,
  input  wire                 tx_start,
  output reg                   tx_busy,
  output reg                        tx
);
  localparam IDLE  = 2'b00,
             START = 2'b01,
             DATA  = 2'b10,
             STOP  = 2'b11;

  reg [1:0]  present_state, next_state;
  reg [12:0] baud_counter;
  reg [2:0]  bit_counter;
  reg [3:0]  byte_counter;
  reg [DATA_WIDTH-1:0]  tx_reg;
  
  localparam NUM_BYTE =DATA_WIDTH/8;
  
  
  always @(posedge ACLK or negedge ARESETN) 
    begin
      if (!ARESETN) 
	    begin
          present_state <= IDLE;
          baud_counter  <= 0;
          bit_counter   <= 0;
		  byte_counter  <= 0;
          tx_reg  <= 0;
        end
		
      else 
	    begin
		
          present_state <= next_state;
		  
		  if(present_state == IDLE)
		    begin
			  byte_counter  <= 0;
			  if(next_state==START) 
			    begin
				  tx_reg  <= tx_data;
                  baud_counter  <= 0;
                  bit_counter   <= 0;
				end
			end
			
		  else if (present_state == START)
		   begin
			if (baud_counter == CLKS_PER_BIT-1) baud_counter <= 0;
		    else baud_counter <= baud_counter + 1;
		   end
		   
		  else if (present_state == DATA)
		   begin
		   
			if (baud_counter == CLKS_PER_BIT-1)
			  begin
				baud_counter <= 0;
                if(bit_counter < 3'b111)   bit_counter <= bit_counter + 1;	
			  end
			  
		    else baud_counter <= baud_counter + 1;
			
			if(next_state == STOP) 
			  begin
			    bit_counter <= 3'b000;
			    if(byte_counter < NUM_BYTE) byte_counter <= byte_counter + 1;
			  end
			  
		  end
		  
		  else if(present_state == STOP)
		    begin
			  if(baud_counter == CLKS_PER_BIT-1) baud_counter<=0;
			  else baud_counter <= baud_counter + 1;
			end  
			
        end
    end
	
  always @(*) 
    begin
	
      next_state = present_state;

      case (present_state)

        IDLE: 
		  begin
		    tx=1'b1;
			tx_busy=1'b0;
            if (tx_start) next_state = START;
          end

        START: 
		  begin
		    tx=1'b0;
			tx_busy=1'b1;
			if (baud_counter == CLKS_PER_BIT-1) next_state = DATA;
          end

        DATA: 
		  begin
		    tx = tx_reg[byte_counter*8 + bit_counter];
		    tx_busy=1'b1;
			if(bit_counter==3'b111 && baud_counter == CLKS_PER_BIT-1) next_state=STOP;
          end

        STOP: 
		  begin
		    tx=1'b1;
			tx_busy=1'b1;
			if (baud_counter == CLKS_PER_BIT-1)
              begin			
			    if(byte_counter == NUM_BYTE) next_state = IDLE;
				else next_state = START;
			  end
          end
		  
      endcase
	  
    end
  
endmodule