module write_controller
#(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)
(
    input wire                      ACLK,
    input wire                      ARESETN,

    input wire [ADDR_WIDTH-1:0]     AWADDR,
    input wire                      AWVALID,
    output reg                      AWREADY,

    input wire [DATA_WIDTH-1:0]     WDATA,
    input wire [DATA_WIDTH/8-1:0]   WSTRB,
    input wire                      WVALID,
    output reg                      WREADY,

    output reg [1:0]                BRESP,
    output reg                      BVALID,
    input wire                      BREADY,

    output reg                      write_enable,
    output reg [ADDR_WIDTH-1:0]     write_address,
    output reg [DATA_WIDTH-1:0]     write_data,
    output reg [DATA_WIDTH/8-1:0]   write_strobe,
    input wire                      write_done,
    input wire                      write_error
);

localparam IDLE        = 3'b000,
           ADDR_READY  = 3'b001,
           DATA_READY  = 3'b010,
           WRITE       = 3'b011,
           WRITE_WAIT  = 3'b100,
           RESPONSE    = 3'b101;

reg [2:0] cs, ns;

reg [ADDR_WIDTH-1:0] awaddr_reg;
reg [DATA_WIDTH-1:0] wdata_reg;
reg [DATA_WIDTH/8-1:0] wstrb_reg;
reg [1:0] response_error;

always @(posedge ACLK or negedge ARESETN) begin
    if (!ARESETN) begin
        awaddr_reg     <= 'b0;
        wdata_reg      <= 'b0;
        wstrb_reg      <= 'b0;
        response_error <= 2'b00;
    end
    else begin
        if (AWVALID && AWREADY) begin
            awaddr_reg <= AWADDR;
        end

        if (WVALID && WREADY) begin
            wdata_reg <= WDATA;
            wstrb_reg <= WSTRB;
        end

        if (write_error) begin
            response_error <= 2'b10;
        end
        else if (write_done) begin
            response_error <= 2'b00;
        end
    end
end

always @(posedge ACLK or negedge ARESETN) begin
    if (!ARESETN) begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

always @(*) begin
    case (cs)

        IDLE: begin
            if (AWVALID && AWREADY && WVALID && WREADY)
                ns = WRITE;
            else if (AWVALID && AWREADY)
                ns = ADDR_READY;
            else if (WVALID && WREADY)
                ns = DATA_READY;
            else
                ns = IDLE;
        end

        ADDR_READY: begin
            if (WVALID && WREADY)
                ns = WRITE;
            else
                ns = ADDR_READY;
        end

        DATA_READY: begin
            if (AWVALID && AWREADY)
                ns = WRITE;
            else
                ns = DATA_READY;
        end

        WRITE: begin
            ns = WRITE_WAIT;
        end

        WRITE_WAIT: begin
            if (write_done || write_error)
                ns = RESPONSE;
            else
                ns = WRITE_WAIT;
        end

        RESPONSE: begin
            if (BVALID && BREADY)
                ns = IDLE;
            else
                ns = RESPONSE;
        end

        default: begin
            ns = IDLE;
        end

    endcase
end

always @(*) begin
    AWREADY       = 1'b0;
    WREADY        = 1'b0;
    BRESP         = 2'b00;
    BVALID        = 1'b0;
    write_enable  = 1'b0;
    write_address = 'b0;
    write_data    = 'b0;
    write_strobe  = 'b0;

    case (cs)

        IDLE: begin
            AWREADY = 1'b1;
            WREADY  = 1'b1;
        end

        ADDR_READY: begin
            WREADY = 1'b1;
        end

        DATA_READY: begin
            AWREADY = 1'b1;
        end

        WRITE: begin
            write_enable  = 1'b1;
            write_address = awaddr_reg;
            write_data    = wdata_reg;
            write_strobe  = wstrb_reg;
        end

        WRITE_WAIT: begin
        end

        RESPONSE: begin
            BVALID = 1'b1;
            BRESP  = response_error;
        end

        default: begin
            AWREADY       = 1'b0;
            WREADY        = 1'b0;
            BRESP         = 2'b00;
            BVALID        = 1'b0;
            write_enable  = 1'b0;
            write_address = 'b0;
            write_data    = 'b0;
            write_strobe  = 'b0;
        end

    endcase
end

endmodule