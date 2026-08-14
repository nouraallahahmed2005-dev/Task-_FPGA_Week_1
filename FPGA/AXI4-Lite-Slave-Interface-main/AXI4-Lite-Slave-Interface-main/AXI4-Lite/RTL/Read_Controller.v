`default_nettype none
module Read_Controller
#(
	parameter ARADDR_WIDTH =32,
	parameter RDATA_WIDTH = 32

)
(
	input wire ACLK ,
	input wire ARESETN ,
	
	//state_1
	//add from master to Read_Controller
	input wire [ARADDR_WIDTH-1:0] ARADDR,
	input wire  ARVALID,
	output reg ARREADY,
	
	//from Read_Controller to file reg
	
	output reg read_enable,
	output reg [ARADDR_WIDTH-1:0] read_address,
	
	
	//from file reg to Read_Controller
	input wire [RDATA_WIDTH-1:0] read_data,
	input wire read_done,
	input wire read_error,
	
	//from Read_Controller to master
	output reg [RDATA_WIDTH-1:0] RDATA,
	output reg [1:0] RRESP ,
	output reg RVALID ,
	// from master to Read_Controller
	input wire RREADY	
	
);
localparam  READY = 2'b00,
			READ  = 2'b01,
			RESP  = 2'b10;
			
reg [1:0] present_state ,next_state;   //seg , combin

reg [ARADDR_WIDTH-1:0] address_reg;

reg [4:0] counter;

//present_state_reg
always @(posedge ACLK , negedge ARESETN)
	begin :present_state_reg
		if (!ARESETN)
		begin
			present_state <= READY;
			address_reg <= {ARADDR_WIDTH{1'b0}};
			counter <= 5'd0;
			RDATA <= {RDATA_WIDTH{1'b0}};
			RRESP <= 2'b00;
		end
		else
			begin
				present_state <= next_state;
				case(present_state)
					READY:
					begin
						counter <= 5'd0;
						  if (ARVALID && ARREADY)
							begin
								address_reg <= ARADDR;
							end
					end
					READ:
					begin
						if (read_done)
						begin
							RDATA <= read_data;
							RRESP <= 2'b00;
							counter <= 5'd0;
						end
						 else if (read_error)
						begin
							RDATA <= {RDATA_WIDTH{1'b0}};
							RRESP <= 2'b10;
							counter <= 5'd0;
						end
						
						 else if (counter == 5'd30)
						begin

							RDATA <= {RDATA_WIDTH{1'b0}};
							RRESP <= 2'b10;
							counter <= 5'd0;

						end
						else
						begin

							counter <= counter + 1'b1;

						end
						end
					   RESP:
						begin
							if (RVALID && RREADY)
							begin

								counter <= 5'd0;

							end

						end


						default:
						begin
							address_reg <= {ARADDR_WIDTH{1'b0}};
							counter <= 5'd0;
							RDATA <= {RDATA_WIDTH{1'b0}};
							RRESP <= 2'b00;

						end

				endcase				
								
			end
			
			
			
	end

//next_state_reg
always @(*)
begin : next_state_reg

    next_state = present_state;

    case (present_state)

        READY:
        begin
            if (ARVALID && ARREADY)
                next_state = READ;
        end

        READ:
        begin
            if (read_done)
                next_state = RESP;

            else if (read_error)
                next_state = RESP;

            else if (counter == 5'd30)
                next_state = RESP;
        end

        RESP:
        begin
            if (RVALID && RREADY)
                next_state = READY;
        end

        default:
            next_state = READY;

    endcase

end
//output_logic
always @(*)
 begin : output_logic
	{ARREADY  ,read_enable, RVALID} =3'b000;
      
    read_address = address_reg;
    case (present_state)
        READY:
			begin
				{ARREADY  ,read_enable, RVALID} = {1'b1,1'b0,1'b0};
			end

       READ:
			begin
				{ARREADY  , RVALID} = 2'b00;
			 
				if (read_done || read_error)
					read_enable = 1'b0;
				else
					read_enable = 1'b1;

			end

        RESP:
        begin
			{ARREADY  ,read_enable, RVALID} = {1'b0,1'b0,1'b1};
        end

        default:
        begin
			{ARREADY  ,read_enable, RVALID} =3'b000;
        end

    endcase

end
endmodule