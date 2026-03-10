//program counter
module PC(
    input wire clk,
    input wire rst,
    input wire load,
    input wire inc, //increment mode (set it in TB when you want to increment the counter)
    input wire EN, //enable signal for outputting to the bus
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output [7:0] bus //main output of the program counter to the bus
 );
    

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            data_out <= 8'b00000000; //reset to 0
        end
        
        else if(load) begin
            data_out <= data_in; //load new value

        end
        else if(inc) begin
            data_out <= data_out + 1'b1; //increment
        end
    end
    assign bus = EN ? data_out : 8'bz; //output to bus when enabled, otherwise high impedance
endmodule