module ram #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 256
)(
    input wire clk,
    input wire wr_en,
    input wire rd_en,
    input wire [ADDR_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg ready
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    
    integer i;
    initial begin
        for (i = 0; i < DEPTH; i = i + 1)
            mem[i] = 8'h00;
    end

    always @(posedge clk) begin
        ready <= 0;
        
        if (wr_en) begin
            mem[addr] <= data_in;
            ready <= 1;
        end
        
        if (rd_en) begin
            data_out <= mem[addr];
            ready <= 1;
        end
    end

endmodule