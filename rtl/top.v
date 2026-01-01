module top #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 256
)(
    input wire clk,
    input wire rst,
    input wire start,
    input wire rw,
    input wire [ADDR_WIDTH-1:0] address,
    input wire [DATA_WIDTH-1:0] write_data,
    output wire [DATA_WIDTH-1:0] read_data,
    output wire done
);

    wire ram_wr_en, ram_rd_en, ram_ready;
    wire [ADDR_WIDTH-1:0] ram_addr;
    wire [DATA_WIDTH-1:0] ram_data_in, ram_data_out;

    ram_controller #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) controller (
        .clk(clk),
        .rst(rst),
        .start(start),
        .rw(rw),
        .address(address),
        .write_data(write_data),
        .read_data(read_data),
        .done(done),
        .ram_wr_en(ram_wr_en),
        .ram_rd_en(ram_rd_en),
        .ram_addr(ram_addr),
        .ram_data_in(ram_data_in),
        .ram_data_out(ram_data_out),
        .ram_ready(ram_ready)
    );

    ram #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) memory (
        .clk(clk),
        .wr_en(ram_wr_en),
        .rd_en(ram_rd_en),
        .addr(ram_addr),
        .data_in(ram_data_in),
        .data_out(ram_data_out),
        .ready(ram_ready)
    );

endmodule