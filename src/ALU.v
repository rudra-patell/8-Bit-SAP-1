//arithmetic and logic unit(ALU)
module ALU (input [7:0] A, B, //8-bit inputs
            input [2:0] sel, //3-bit selector for operation
            output wire[7:0] data_out, //result of the ALU operation
            input rst, //reset signal for the ALU
            output reg[3:0] flags //flags will be implemented in future (oreder = Negative(Z), Zero(Z), Carry(C), Overflow(V))
            );

    reg [7:0] result; //internal register to hold the ALU result before output


always @(*) begin
    case (sel)
        3'b000: result = A + B; //Addition
        3'b001: result = A - B; //Subtraction
        3'b010: result = A & B; //Bitwise AND
        3'b011: result = A | B; //Bitwise OR
        3'b100: result = A ^ B; //Bitwise XOR
        3'b101: result = ~A;    //Bitwise NOT (only on A) (invert A)
        3'b110: result = A << 1; //Logical left shift
        3'b111: result = A >> 1; //Logical right shift
        default: result = 8'b00000000; //Default case
       
    endcase
    if (rst) begin
        result = 8'b00000000; //Reset result to 0
    end

   
    //flags = 4'bXXXX; //flags will be implemented in future
end
    assign data_out = result;
endmodule