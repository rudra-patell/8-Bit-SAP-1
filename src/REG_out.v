module Output_Reg (
    input wire clk,
    input wire reset,    // Changed from rst to match your other modules
    input wire load_out, // From CU: T4 of an OUT instruction
    input wire [7:0] bus,
    output reg [7:0] out_port
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            out_port <= 8'b0;
        else if (load_out) begin
            if (bus !== 8'bzzzz_zzzz) begin // Check for high-impedance before loading this is only for simulation purposes to avoid loading from an undriven bus
                out_port <= bus;
            end
        end
    end

endmodule