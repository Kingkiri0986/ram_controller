module ram_controller #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
)(
    input wire clk,
    input wire rst,
    
    // User interface
    input wire start,
    input wire rw,              // 0=read, 1=write
    input wire [ADDR_WIDTH-1:0] address,
    input wire [DATA_WIDTH-1:0] write_data,
    output reg [DATA_WIDTH-1:0] read_data,
    output reg done,
    
    // RAM interface
    output reg ram_wr_en,
    output reg ram_rd_en,
    output reg [ADDR_WIDTH-1:0] ram_addr,
    output reg [DATA_WIDTH-1:0] ram_data_in,
    input wire [DATA_WIDTH-1:0] ram_data_out,
    input wire ram_ready
);

    // State machine
    localparam IDLE = 2'b00;
    localparam WRITE = 2'b01;
    localparam READ = 2'b10;
    localparam DONE = 2'b11;
    
    reg [1:0] state, next_state;

    // State register
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (start)
                    next_state = rw ? WRITE : READ;
            end
            
            WRITE: begin
                if (ram_ready)
                    next_state = DONE;
            end
            
            READ: begin
                if (ram_ready)
                    next_state = DONE;
            end
            
            DONE: begin
                if (!start)
                    next_state = IDLE;
            end
        endcase
    end

    // Output logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ram_wr_en <= 0;
            ram_rd_en <= 0;
            ram_addr <= 0;
            ram_data_in <= 0;
            read_data <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    ram_wr_en <= 0;
                    ram_rd_en <= 0;
                    done <= 0;
                end
                
                WRITE: begin
                    ram_wr_en <= 1;
                    ram_rd_en <= 0;
                    ram_addr <= address;
                    ram_data_in <= write_data;
                end
                
                READ: begin
                    ram_wr_en <= 0;
                    ram_rd_en <= 1;
                    ram_addr <= address;
                    read_data <= ram_data_out;
                end
                
                DONE: begin
                    ram_wr_en <= 0;
                    ram_rd_en <= 0;
                    done <= 1;
                end
            endcase
        end
    end

endmodule