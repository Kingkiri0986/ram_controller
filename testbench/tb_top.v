`timescale 1ns/1ps

module tb_top;

    reg clk;
    reg rst;
    reg start;
    reg rw;
    reg [7:0] address;
    reg [7:0] write_data;
    wire [7:0] read_data;
    wire done;

    // Instantiate the top module
    top #(
        .ADDR_WIDTH(8),
        .DATA_WIDTH(8),
        .DEPTH(256)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .rw(rw),
        .address(address),
        .write_data(write_data),
        .read_data(read_data),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 100MHz clock
    end

    // Dump waveforms
    initial begin
        $dumpfile("sim/ram_controller.vcd");
        $dumpvars(0, tb_top);
    end

    // Test sequence
    initial begin
        $display("=== RAM Controller Testbench ===");
        
        // Initialize
        rst = 1;
        start = 0;
        rw = 0;
        address = 0;
        write_data = 0;
        
        #20 rst = 0;
        
        // Test 1: Write to address 0x10
        $display("Test 1: Write 0xAB to address 0x10");
        #10;
        address = 8'h10;
        write_data = 8'hAB;
        rw = 1;
        start = 1;
        
        @(posedge done);
        #10 start = 0;
        $display("Write complete");
        
        // Test 2: Read from address 0x10
        #20;
        $display("Test 2: Read from address 0x10");
        address = 8'h10;
        rw = 0;
        start = 1;
        
        @(posedge done);
        $display("Read data: 0x%h (expected 0xAB)", read_data);
        #10 start = 0;
        
        // Test 3: Write to address 0x20
        #20;
        $display("Test 3: Write 0xCD to address 0x20");
        address = 8'h20;
        write_data = 8'hCD;
        rw = 1;
        start = 1;
        
        @(posedge done);
        #10 start = 0;
        $display("Write complete");
        
        // Test 4: Read from address 0x20
        #20;
        $display("Test 4: Read from address 0x20");
        address = 8'h20;
        rw = 0;
        start = 1;
        
        @(posedge done);
        $display("Read data: 0x%h (expected 0xCD)", read_data);
        #10 start = 0;
        
        // Test 5: Read from address 0x10 again
        #20;
        $display("Test 5: Read from address 0x10 again");
        address = 8'h10;
        rw = 0;
        start = 1;
        
        @(posedge done);
        $display("Read data: 0x%h (expected 0xAB)", read_data);
        #10 start = 0;
        
        #50;
        $display("=== All tests completed ===");
        $finish;
    end

    // Timeout
    initial begin
        #10000;
        $display("ERROR: Simulation timeout");
        $finish;
    end

endmodule