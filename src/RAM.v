module RAM (
    input wire clk,
    input wire [7:0] data_in,
    input wire [3:0] address,      // From MAR
    input wire write_enable,       // From Controller
    input wire chipsel_enable,     // From Controller
    output wire [7:0] data_out 
);

    reg [7:0] memory [0:15];
    integer i;

    initial begin
        // 1. Clear memory
        for (i = 0; i < 16; i = i + 1) begin
            memory[i] = 8'h00;
        end

        // 2. Load from BIOS.txt
        $readmemh("src/BIOS.txt", memory);

        // // 3. Hard-coded values (Backup in case file fails)
        // memory[0]  = 8'h8A; // LDA 10
        // memory[1]  = 8'h0B; // ADD 11
        // memory[2]  = 8'hA0; // OUT
        // memory[3]  = 8'hB0; // HLT
        // memory[10] = 8'h05; // Value to add
        // memory[11] = 8'h02; // Value to add

        $display("RAM: BIOS loaded. Check: Addr 0=%h, Addr 10=%h", memory[0], memory[10]);
    end

    // Synchronous Write
    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in;
        end
    end

    // TRUE Tri-state output to Bus
    assign data_out = (chipsel_enable) ? memory[address] : 8'bz;

endmodule