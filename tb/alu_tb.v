module alu_tb ();
    reg [7:0] A; //first input to the ALU
    reg [7:0] B; //second input to the ALU
    reg [2:0] sel; //selector for ALU operation
    wire [7:0] result; //output of the ALU
    reg rst; //reset signal for the ALU

ALU alu (.A(A),
        .B(B),
        .sel(sel),
        .result(result),
        .rst(rst)
);
initial begin
        rst = 1; //reset the ALU
    #10 rst = 0; //release reset

    //testing addition
    #10 A = 8'b00001111; //set A to 15
    #10 B = 8'b00000101; //set B to 5
    #10 sel = 3'b000; //select addition
    #10 $display("Addition: A = %b, B = %b, Result = %b", A, B, result);

    //testing subtraction
    #10 sel = 3'b001; //select subtraction
    #10 $display("Subtraction: A = %b, B = %b, Result = %b", A, B, result);

    //testing bitwise AND
    #10 sel = 3'b010; //select bitwise AND
    #10 $display("Bitwise AND: A = %b, B = %b, Result = %b", A, B, result);

    //testing bitwise OR
    #10 sel = 3'b011; //select bitwise OR
    #10 $display("Bitwise OR: A = %b, B = %b, Result = %b", A, B, result);

    //testing bitwise XOR
    #10 sel = 3'b100; //select bitwise XOR
    #10 $display("Bitwise XOR: A = %b, B = %b, Result = %b", A, B, result);

    //testing bitwise NOT
    #10 sel = 3'b101; //select bitwise NOT
    #10 $display("Bitwise NOT: A = %b, Result = %b", A, result);

    //testing logical left shift
    #10 sel = 3'b110; //select logical left shift
    #10 $display("Logical Left Shift: A = %b, Result = %b", A, result);

    //testing logical right shift
    #10 sel = 3'b111; //select logical right shift
    #10 $display("Logical Right Shift: A = %b, Result = %b", A, result);

    //testing overflow in addition
    #10 A = 8'b11111111; //set A to 255
    #10 B = 8'b00000010; //set B to 2
    #10 sel = 3'b000; //select addition
    #10 $display("Overflow in Addition: A = %b, B = %b, Result = %b", A, B, result);

    //testing underflow in subtraction
    #10 A = 8'b00000000; //set A to 0
    #10 B = 8'b00000001; //set B to 1
    #10 sel = 3'b001; //select subtraction
    #10 $display("Underflow in Subtraction: A = %b, B = %b, Result = %b", A, B, result);

    //test reset functionality
    #10 rst = 1; //assert reset
    #10 $display("After Reset: A = %b, B = %b, Result = %b", A, B, result);

    #100 $finish; //end the simulation
    end
initial begin
    $monitor("Time: %0t | A: %b | B: %b | sel: %b | Result: %b", $time, A, B, sel, result);
    $dumpfile("alu_tb.vcd");    
    $dumpvars(0, alu_tb);
end

endmodule
