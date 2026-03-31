
module CPU_top (
    input wire clk,
    input wire reset,
    output wire [7:0] out_display // To see your 'OUT' results
);

    //W-Bus
    reg [7:0] w_bus;

    wire load_A, load_B, load_out, load_IR, load_MAR, load_PC; //all load pins
    wire en_out_A, en_out_B, en_out_PC, en_out_IR, en_out_alu;      //all enable pins
    wire CS_RAM, WE_RAM, inc_PC;   
    wire [2:0] alu_op; //op code for alu operations
    wire [7:0] ir_to_cu, a_to_alu, b_to_alu, a_to_out; // Internal buses for control signals and data paths
    wire [3:0] ram_addr; // Address bus for RAM from mar
    wire [7:0] PC_out , RAM_out , IR_out, ALU_out; // output of modules 
    wire idle ; //bus idle flag
    assign idle = ~(en_out_PC | en_out_alu | CS_RAM | en_out_IR) ;


    always@ (*) begin //enableing priority encoder logic    
        if(en_out_PC)           w_bus = PC_out;
        else if (CS_RAM)        w_bus = RAM_out;
        else if (en_out_IR)     w_bus = IR_out;
        else if (en_out_alu)    w_bus = ALU_out;
        else                    w_bus = 8'b0;   // idle bus 
    end

   


    Control CU(
        .clk(clk),
        .IR_out(ir_to_cu),
        .reset(reset),
        .load_A(load_A),
        .load_B(load_B),
        .load_out(load_out),
        .load_IR(load_IR),
        .en_out_A(en_out_A),
        .en_out_B(en_out_B),
        .alu_op(alu_op),
        .en_out_PC(en_out_PC),
        .load_PC(load_PC),
        .inc_PC(inc_PC),
        .CS_RAM(CS_RAM),
        .WE_RAM(WE_RAM),
        .load_MAR(load_MAR),
        .en_out_IR(en_out_IR),
        .en_out_alu(en_out_alu)
    );


    PC program_counter (
        .clk(clk),
        .rst(reset),
        .inc(inc_PC),
        .load(load_PC),
        .bus(PC_out)
    );

    MAR addr_reg (
        .clk(clk), 
        .load_MAR(load_MAR),   // From CU: High during T1
        .bus(w_bus),           // Connect to the 8-bit W-Bus
        .addr_to_ram(ram_addr) // 4-bit private line to RAM
    );

    RAM memory (
        .clk(clk),
        .address(ram_addr),    // Driven by MAR
        .data_in(w_bus),       // For STA instructions
        .data_out(RAM_out),      //Drives the bus during T3 and T5
        .write_enable(WE_RAM)
    );

    IR instr_reg(
        .bus_in(w_bus),
        .clk(clk),
        .reset(reset),
        .load(load_IR),
        .bus_out(IR_out),
        .out_to_cu(ir_to_cu)
    );

    REG_A accumulator(
        .clk(clk),
        .clr(reset),
        .load(load_A),
        .en_out(en_out_A),
        .data_in(w_bus),
        .data_out(a_to_alu)
    );

    REG_B buffer_reg(
        .clk(clk),
        .clr(reset),
        .load(load_B),
        .en_out(en_out_B),
        .data_in(w_bus),
        .data_out(b_to_alu)
    );

    ALU arithmetic_unit(
        .A(a_to_alu),
        .B(b_to_alu),
        .sel(alu_op),
        .data_out(ALU_out),
        .rst(reset)
    );

    Output_Reg out_reg(
        .clk(clk),
        .reset(reset),
        .load_out(load_out),
        .bus(w_bus),
        .out_port(out_display)
    );

endmodule
