// src/MAR.v
module MAR (
    input wire clk,
    input wire load_MAR,
    input wire [7:0] bus,
    output reg [3:0] addr_to_ram
);
    initial addr_to_ram = 4'h0;

    always @(posedge clk) begin
        if (load_MAR) 
            addr_to_ram <= bus[3:0]; // Latch and HOLD
    end
    
endmodule