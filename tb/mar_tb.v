module mar_tb();
    reg [3:0] data_in;
    reg load;
    reg clk;
    wire [3:0] data_out;

    MAR mar (
        .data_in(data_in),
        .load(load),
        .clk(clk),
        .data_out(data_out)
    );

    initial begin
        // Initialize inputs
        data_in = 4'b0000;
        load = 0;
        clk = 0;

        // Test case 1: Load a value into MAR
        #10 data_in = 4'b1010; // Set data input to 1010
        #10 load = 1;           // Enable loading
        #10 load = 0;           // Disable loading

        // Test case 2: Load another value into MAR
        #10 data_in = 4'b0101; // Set data input to 0101
        #10 load = 1;           // Enable loading
        #10 load = 0;           // Disable loading

        // Finish simulation after some time
        #50 $finish;
    end

    //monitor changes in data_out
    initial begin
        $monitor("At time %0t, data_in = %b, load = %b, data_out = %b", $time, data_in, load, data_out);
    end

    // Clock generation
    always #5 clk = ~clk; // Toggle clock every 5 time units

endmodule