module REG_B (
    input wire clk,
    input wire clr,
    input wire load,        
    input wire en_out,      // Usually 0 in SAP-1, but good for debugging
    input wire [7:0] data_in, // Connected to W-Bus
    output wire [7:0] data_out, // Connected to W-Bus (Tri-state)
    output wire [7:0] out_to_alu // Private wire to ALU input
);

    reg [7:0] internal_data;

    // 1. Sequential: Load data from W-Bus
    always @(posedge clk or posedge clr) begin
        if (clr)
            internal_data <= 8'b0;
        else if (load)
            internal_data <= data_in;
    end

    // 2. Combinational: Tri-state to W-Bus
    // In a standard SAP-1, Reg B doesn't drive the bus, but 
    // keeping this lets you "see" Reg B during testing.
    assign data_out = en_out ? internal_data : 8'bz;

    // 3. Combinational: Dedicated "Listening" port for the ALU
    // This makes the current value of B always available to the ALU logic.
    assign out_to_alu = internal_data;

endmodule