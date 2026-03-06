module tb ();
    reg clk = 0;
    reg rst;
    always #5 clk = ~clk;
    reg inc = 1; //increment signal for the program counter
    wire [7:0] pc_out; //output of the program counter
    reg pc_load = 0; //load signal for the program counter
    reg [7:0] pc_in; //input for the program counter
    wire [7:0] bus; //bus output from the program counter
    reg en; //enable signal for outputting to the bus

PC pc (
    .clk(clk),
    .rst(rst),
    .inc(inc),
    .load(pc_load),
    .data_in(pc_in),
    .data_out(pc_out),
    .bus(bus),
    .EN(en)
);

initial begin
    rst = 1; //reset the program counter
    en = 0; //disable output to bus
#9 rst = 0; //release reset

//checking load functionality of the program counter

#10 pc_load = 1; //enable load signal
#15 pc_in = 8'b00001111; //load a value into the program counter

#20 pc_load = 0; //disable load signal
#50 inc = 1; //enable increment signal to see the program counter incrementing
en = 1; //enable output to bus to see the value on the bus
#60 pc_in = 8'b11110000; //try to load another value into the program counter while load = 0 (see if it works correctly)
inc = 0; //disable increment signal to see if the program counter holds the value correctly
#10 en = 0; //disable output to bus
inc = 1; //enable increment signal again to see if the program counter increments correctly after disabling output to bus
#15 en = 1;

inc =0; //disable increment signal
pc_load = 1; //enable load signal again
#10 pc_in = 8'b11111111; //load PC to max value
#25 pc_load = 0; //disable load signal
#20 inc = 1; //enable increment signal to see if the program counter rolls over correctly from 255 to 0

#100 $finish; //end the simulation

end

initial begin
    $monitor("Time: %0t | PC Output: %b | Bus Output: %b", $time, pc_out, bus);
    $dumpfile("pc_tb.vcd");
    $dumpvars(0, tb);
end

    
endmodule