`default_nettype none

module reg_file #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 7
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
    output reg read_error
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

assign type_array[0] = 3'b110;
assign type_array[1] = 3'b110;
assign type_array[2] = 3'b110;
assign type_array[3] = 3'b110;

assign type_array[4] = 3'b110;
assign type_array[5] = 3'b110;
assign type_array[6] = 3'b110;
assign type_array[7] = 3'b110;

assign type_array[8]  = 3'b110;
assign type_array[9]  = 3'b110;
assign type_array[10] = 3'b110;
assign type_array[11] = 3'b110;
assign type_array[12] = 3'b110;
assign type_array[13] = 3'b110;
assign type_array[14] = 3'b110;
assign type_array[15] = 3'b110;
assign type_array[16] = 3'b110;
assign type_array[17] = 3'b110;
assign type_array[18] = 3'b110;
assign type_array[19] = 3'b110;
assign type_array[20] = 3'b110;
assign type_array[21] = 3'b110;
assign type_array[22] = 3'b110;
assign type_array[23] = 3'b110;
assign type_array[24] = 3'b110;
assign type_array[25] = 3'b110;
assign type_array[26] = 3'b110;
assign type_array[27] = 3'b110;

assign type_array[WRITE_COUNTER_ADDR]       = 3'b100;
assign type_array[READ_COUNTER_ADDR]        = 3'b100;
assign type_array[WRITE_ERROR_COUNTER_ADDR] = 3'b100;
assign type_array[READ_ERROR_COUNTER_ADDR]  = 3'b100;

integer i;
integer j;

always @(posedge ACLK or negedge ARESETN) begin
    if (!ARESETN) begin

        for (i = 0; i < NUM_REGS; i = i + 1)
            data_array[i] <= 'b0;

        write_done  <= 1'b0;
        write_error <= 1'b0;

        read_done   <= 1'b0;
        read_error  <= 1'b0;
        read_data   <= 'b0;
    end

    else begin

        write_done  <= 1'b0;
        write_error <= 1'b0;

        read_done   <= 1'b0;
        read_error  <= 1'b0;

        if (write_enable) begin

            if ((write_address[ADDR_LSB-1:0] == 'b0) &&
                ((write_address >> ADDR_LSB) < NUM_REGS) &&
                (type_array[write_address >> ADDR_LSB] == 3'b110 ||
                 type_array[write_address >> ADDR_LSB] == 3'b010)) begin

                for (j = 0; j < NUM_BYTES; j = j + 1) begin
                    if (write_strobe[j])
                        data_array[write_address >> ADDR_LSB][(8*j) +: 8]
                            <= write_data[(8*j) +: 8];
                end

                write_done <= 1'b1;
            end

            else begin
                write_error <= 1'b1;
            end
        end

        if (read_enable) begin

            if ((read_address[ADDR_LSB-1:0] == 'b0) &&
                ((read_address >> ADDR_LSB) < NUM_REGS) &&
                (type_array[read_address >> ADDR_LSB] == 3'b100 ||
                 type_array[read_address >> ADDR_LSB] == 3'b110 ||
                 type_array[read_address >> ADDR_LSB] == 3'b010)) begin

                read_data <= data_array[read_address >> ADDR_LSB];
                read_done <= 1'b1;
            end

            else begin
                read_error <= 1'b1;
            end
        end

        if (write_done)
            data_array[WRITE_COUNTER_ADDR]
                <= data_array[WRITE_COUNTER_ADDR] + 1'b1;

        if (read_done)
            data_array[READ_COUNTER_ADDR]
                <= data_array[READ_COUNTER_ADDR] + 1'b1;

        if (write_error)
            data_array[WRITE_ERROR_COUNTER_ADDR]
                <= data_array[WRITE_ERROR_COUNTER_ADDR] + 1'b1;

        if (read_error)
            data_array[READ_ERROR_COUNTER_ADDR]
                <= data_array[READ_ERROR_COUNTER_ADDR] + 1'b1;

    end
end

endmodule

