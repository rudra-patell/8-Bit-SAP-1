module IR(
    input wire [7:0] bus_in,    // Input from the shared W-Bus
    input wire clk,
    input wire reset,
    input wire load,           
    input wire en_out_IR,      
    output wire [7:0] bus_out,  // The W-Bus connection
    output wire [7:0] out_to_cu // Direct wire to Control Unit
);
    reg [7:0] ir_reg; // The internal 8-bit flip-flops

    // 1. Sequential Logic: Loading the instruction
    always @(posedge clk or posedge reset) begin
        if (reset)
            ir_reg <= 8'h00;
        else if (load)
            ir_reg <= bus_in;
    end

    // The upper 4 bits are typically masked or sent as 0s
    assign bus_out = (en_out_IR) ? {4'b0000, ir_reg[3:0]} : 8'bz;

    assign out_to_cu = ir_reg;

endmodule