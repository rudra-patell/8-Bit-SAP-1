module IR_tb();

    reg [7:0] Data_in;     // SAP-1 is 8-bit
    wire [7:0] Data_out;
    reg clk = 0;
    reg load;

    // Fixed clock generation
    always #5 clk = ~clk; 

    IR uut(
        .Data_in(Data_in),
        .load(load),         // Using the names from your IR module
        .Data_out(Data_out),
        .clk(clk)
    ); 

    initial begin
        // Initialize values
        load = 0; Data_in = 8'h00;
        
        #10 load = 1;
        #10 Data_in = 8'hA5; 
        #20 Data_in = 8'hFF;
        #10 load = 0;
        #10 Data_in = 8'h12; // Data_out should stay 0xFF
        
        #50 $finish;
    end

    initial begin
        $monitor("Time: %0t | Load: %b | In: %h | Out: %h", $time, load, Data_in, Data_out);
        $dumpfile("ir_tb.vcd"); 
        $dumpvars(0, IR_tb);
    end
endmodule