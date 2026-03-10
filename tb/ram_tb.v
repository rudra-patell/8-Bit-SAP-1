`timescale 1ns/1ps

module ram_tb;
    // Testbench signals
    reg clk;
    reg we;
    reg cs;
    reg [3:0] addr;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Instantiate RAM module
    RAM uut (
        .clk(clk),
        .write_enable(we),
        .chipsel_enable(cs),
        .address(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin
        // Waveform file setup
        $dumpfile("ram_tb.vcd");
        $dumpvars(0, ram_tb);

        // Initialization
        we = 0; cs = 0; addr = 0; data_in = 0;
        
        // Let memory initialize
        #10;

        // --- TEST 1: READ PRE-LOADED DATA (T3 Fetch Simulation) ---
        $display("--- Starting Read Test ---");
        cs = 1; addr = 4'h0; // Read address 0
        #10;
        $display("Addr 0: Expected 8A, Got %h", data_out);
        
        addr = 4'h1; // Read address 1
        #10;
        $display("Addr 1: Expected 0B, Got %h", data_out);

        // --- TEST 2: CHECK TRI-STATE (High-Z) ---
        $display("--- Starting Tri-state Test ---");
        cs = 0; // Disable RAM
        #10;
        $display("CS=0: Expected zz, Got %h", data_out);

        // --- TEST 3: WRITE AND READ BACK ---
        $display("--- Starting Write/Read Test ---");
        cs = 1; we = 1; addr = 4'h5; data_in = 8'hD1; // Write D1 to Addr 5
        #10;
        we = 0; // Stop writing
        #10;
        $display("Addr 5: Expected D1, Got %h", data_out);

        #20;
        $display("RAM Isolation Test Finished.");
        $finish;
    end

    // Monitor output
    initial begin
        $monitor("Time=%0t | CS=%b | WE=%b | Addr=%h | Data_Out=%h", 
                 $time, cs, we, addr, data_out);
    end
endmodule