`timescale 1ns/1ps

module final_cpu_tb;
    reg clk;
    reg reset;
    wire [7:0] out_display;

    // Instantiate CPU
    CPU_top uut (
        .clk(clk),
        .reset(reset),
        .out_display(out_display)
    );

    // 100MHz Clock (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Unified Simulation Control
    initial begin
        $dumpfile("cpu_tb.vcd");
        $dumpvars(0, final_cpu_tb);

        // --- 1. Global Reset ---
        reset = 1; 
        #25 reset = 0; // Release reset slightly off-edge for stability
        
        $display("-------------------------------------------");
        $display("Time | PC | IR | Acc | Out_Reg");
        $display("-------------------------------------------");

        // --- 2. Run Duration ---
        // 5 instructions * 6 T-states * 10ns = 300ns. 
        // We run for 500ns to be safe.
        #500;

        // --- 3. Final Verification ---
        $display("-------------------------------------------");
        if (out_display == 8'h0E) 
            $display(">>> TEST PASSED: Result is 0E (Decimal 14) <<<");
        else
            $display(">>> TEST FAILED: Expected 0E, Got %h <<<", out_display);
        $display("-------------------------------------------");
        
        $finish;
    end

    // Terminal Monitor
    initial begin
        $monitor("Time:%0t | PC:%h | IR:%h | Acc:%h | Out:%h", 
                $time, uut.program_counter.data_out, uut.instr_reg.ir_reg, uut.accumulator.internal_reg, out_display);
    end

endmodule