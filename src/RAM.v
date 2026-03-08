module ram (
    input wire [7:0] data_in,
    input wire [3:0] address,      // From Memory Address Register (MAR)
    input wire write_enable,       // Load RAM (from Controller)
    input wire chipsel_enable,     // RAM Out to Bus (from Controller)
    input wire clk,
    output wire [7:0] data_out     // Changed to wire for Tri-state
);

    reg [7:0] memory [0:15];
    reg [7:0] internal_data;

    // Synchronous Write Logic
    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in;
        end
    end

    // Asynchronous Read (Typical for SAP-1 RAM)
    // We read internally, then use a Tri-state buffer for the Bus
    always @(*) begin
        internal_data = memory[address];
    end

    // TRUE Tri-state Buffer for the W-Bus
    // This is the part that turns into a CMOS Tri-state in Virtuoso
    assign data_out = (chipsel_enable) ? internal_data : 8'bzzzzzzzz;

endmodule