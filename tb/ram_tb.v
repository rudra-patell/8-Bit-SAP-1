module ram_tb;

    // Testbench signals
    reg clk;
    reg we;
    reg cs;
    reg [3:0] addr;
    reg [7:0] data_in;
    wire [7:0] data_out;

    // Instantiate RAM module
    ram uut (
        .clk(clk),
        .write_enable(we),
        .chipsel_enable(cs),
        .address(addr),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test cases
    initial begin
        we = 0;
        addr = 0;
        data_in = 0;

        // Write test
        #10 we = 1; cs = 1; addr = 4'd0; data_in = 8'hAA;
        #10 addr = 4'd1; data_in = 8'hBB;
        
        #10 addr = 4'd2; data_in = 8'hCC;

        // Read test
        #10 we = 0; cs = 1'b1; addr = 4'd0;
        #10 addr = 4'd1;
        #10 addr = 4'd2;

        #20 $finish;
    end

    // Monitor
    initial begin
        $monitor("Time=%0t| CS=%b | WE=%b | Addr=%h | Data_In=%h | Data_Out=%h", 
                 $time, cs, we, addr, data_in, data_out);
    end

endmodule