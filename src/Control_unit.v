/* OP CODE
    0000 - ADD
    0001 - SUB
    0010 - AND
    0011 - OR
    0100 - XOR
    0101 - NOT
    0110 - Logical left shift
    0111 - LOgical right shift
    1000 - LDA
    1001 - LDB
    1010 - OUT
    1011 - HLT

    1100 - NOP
    1101 - NOP
    1110 - NOP
    1111 - NOP


*/


module Control (
    input wire[7:0] IR_out,
    input wire clk,
    input wire reset,
    output reg load_A,
    output reg load_B, 
    output reg load_out,
    output reg load_IR,
    output reg en_out_A,
    output reg en_out_B,
    output reg[2:0] alu_op,
    output reg en_out_PC,
    output reg inc_PC,
    output reg load_PC,
    output reg CS_RAM,
    output reg WE_RAM,
    output reg load_MAR,
    output reg en_out_IR,
    output reg en_out_alu
);

    reg [5:0] t_state; // Internal 6-bit ring counter

    always @(posedge clk or posedge reset) begin
        if (reset)
            t_state <= 6'b000001; // Reset to T1
        else if (IR_out[7:4] == 4'b1011) // 1011 is HLT
            t_state <= t_state; // FREEZE the counter: stay in current T-state
        else
            t_state <= {t_state[4:0], t_state[5]}; // Normal Ring Counter shift
    end

always @(*) begin
    // --- 1. Default Control Signal Values (Zero out everything) ---
    load_A = 0;
    load_B = 0;
    load_out = 0;  
    load_IR = 0;
    en_out_A = 0;  
    en_out_B = 0;
    en_out_PC = 0; 
    inc_PC = 0;
    load_PC = 0;   
    CS_RAM = 0;    
    WE_RAM = 0;    
    load_MAR = 0;
    alu_op = 3'b000;
    en_out_IR = 0; 
    en_out_alu = 0; 




    // --- 2. Fixed Fetch Cycle (T1, T2, T3) ---
    if (t_state[0]) begin // T1: PC -> MAR
        en_out_PC = 1;
        load_MAR = 1;
    end
    if (t_state[1]) begin // T2: Increment PC
        inc_PC = 1;
    end
    if (t_state[2]) begin // T3: RAM -> IR
        CS_RAM = 1;   // RAM Output enable
        load_IR = 1;
    end

//execution cycle
    case(IR_out[7:4]) 

       4'b0000: begin // ADD
            // T4: IR -> MAR (Fetch the Address of the data)
            if (t_state[3]) begin 
                en_out_IR = 1;
                load_MAR = 1;
            end
            
            // T5: RAM -> Reg B (Load the number to be added)
            if (t_state[4]) begin 
                CS_RAM = 1; 
                load_B = 1;
            end

            // T6: ALU -> Reg A (INTERNAL LOAD)
            if (t_state[5]) begin 
                en_out_B = 1;
                en_out_A = 1;
                alu_op = 3'b000;  // Addition
                en_out_alu = 1;
                load_A = 1;       // Latch the result
                load_out = 1;   // Enable output to OUT reg

            end
        end

        4'b0001: begin //SUB

            // T4: IR -> MAR (Fetch the Address of the data)
            if (t_state[3]) begin 
                en_out_IR = 1;
                load_MAR = 1;
            end
            
            // T5: RAM -> Reg B (Load the number to be subtracted)
            if (t_state[4]) begin 
                CS_RAM = 1; 
                load_B = 1;
            end

            // T6: ALU -> Reg A (INTERNAL LOAD)
            if (t_state[5]) begin 
                en_out_B = 1;
                en_out_A = 1;
                alu_op = 3'b001;  // Subtraction
                load_A = 1;       // Latch the result
                en_out_alu = 1;
                load_out = 1;   // Enable output to OUT reg

            end

        end

    4'b0010: begin //AND

        // T4: IR -> MAR (Fetch the Address of the data)
        if (t_state[3]) begin 
            en_out_IR = 1;
            load_MAR = 1;
        end

        // T5: RAM -> Reg B (Load the number)
        if (t_state[4]) begin 
            CS_RAM = 1; 
            load_B = 1;
        end

        // T6: ALU -> Reg A (INTERNAL LOAD)
        if (t_state[5]) begin 
                
                en_out_B = 1;
                en_out_A = 1;
                alu_op = 3'b010;  // bitwiese AND
                
                en_out_alu = 1;

                load_A = 1;       // Latch the result
                load_out = 1;   // Enable output to OUT reg
            end
    end

    4'b0011: begin //Or

        // T4: IR -> MAR (Fetch the Address of the data)
        if (t_state[3]) begin 
            en_out_IR = 1;
            load_MAR = 1;
        end

        // T5: RAM -> Reg B (Load the number)
        if (t_state[4]) begin 
            CS_RAM = 1; 
            load_B = 1;
        end

        // T6: ALU -> Reg A (INTERNAL LOAD)
        if (t_state[5]) begin 
                
            en_out_B = 1;
            en_out_A = 1;
            alu_op = 3'b011;  // Bitwise OR

            en_out_alu = 1;

            load_A = 1;       // Latch the result
            load_out = 1;   // Enable output to OUT reg

        end
    end

    4'b0100: begin //XOR

        // T4: IR -> MAR (Fetch the Address of the data)
        if (t_state[3]) begin 
            en_out_IR = 1;
            load_MAR = 1;
        end

        // T5: RAM -> Reg B (Load the number)
        if (t_state[4]) begin 
            CS_RAM = 1; 
            load_B = 1;
        end

        // T6: ALU -> Reg A (INTERNAL LOAD)
         if (t_state[5]) begin 
                
            en_out_B = 1;
            en_out_A = 1;
            alu_op = 3'b100;  // Bitwise XOR

            en_out_alu = 1;

            load_A = 1;       // Latch the result
            load_out = 1;   // Enable output to OUT reg

        end
    end

    4'b0101: begin //NOT

        // T4: IR -> MAR (Fetch the Address of the data)
        if (t_state[3]) begin 
            en_out_IR = 1;
            load_MAR = 1;
        end

        // T5: RAM -> Reg B (Load the number)
        if (t_state[4]) begin 
            CS_RAM = 1; 
            load_B = 1;
        end

        // T6: ALU -> Reg A (INTERNAL LOAD)  if (t_state[5]) begin 
        if (t_state[5]) begin     
            en_out_B = 1;
            en_out_A = 1;
            alu_op = 3'b101;  // Bitwise NOT

            en_out_alu = 1;

            load_A = 1;       // Latch the result
            load_out = 1;   // Enable output to OUT reg

        end
        
    end

        4'b0110: begin //LSL

        // T4: IR -> MAR (Fetch the Address of the data)
        if (t_state[3]) begin 
            en_out_IR = 1;
            load_MAR = 1;
        end

        // T5: RAM -> Reg B (Load the number)
        if (t_state[4]) begin 
            CS_RAM = 1; 
            load_B = 1;
        end

        // T6: ALU -> Reg A (INTERNAL LOAD)
          if (t_state[5]) begin 
                
            en_out_B = 1;
            en_out_A = 1;
            alu_op = 3'b110;  // LSL

            en_out_alu = 1;

            load_A = 1;       // Latch the result
            load_out = 1;   // Enable output to OUT reg

        end
        
    end


    4'b0111: begin //LSR

        // T4: IR -> MAR (Fetch the Address of the data)
        if (t_state[3]) begin 
            en_out_IR = 1;
            load_MAR = 1;
        end

        // T5: RAM -> Reg B (Load the number)
        if (t_state[4]) begin 
            CS_RAM = 1; 
            load_B = 1;
        end

         if (t_state[5]) begin 
                
            en_out_B = 1;
            en_out_A = 1;
            alu_op = 3'b111;  //RSL

            en_out_alu = 1;

            load_A = 1;       // Latch the result
            load_out = 1;   // Enable output to OUT reg

        end
        
    end

    4'b1000: begin //LDA

        // T4: IR -> MAR (Fetch the Address of the data)
        if (t_state[3]) begin 
            en_out_IR = 1;
            load_MAR = 1;
        end

        // T5: RAM -> Reg A (Load the number)
        if (t_state[4]) begin 
            CS_RAM = 1; 
            load_A = 1;
        end
        
    end

    4'b1001: begin //LDB

        // T4: IR -> MAR (Fetch the Address of the data)
        if (t_state[3]) begin 
            en_out_IR = 1;
            load_MAR = 1;
        end

        // T5: RAM -> Reg B (Load the number)
        if (t_state[4]) begin 
            CS_RAM = 1; 
            load_B = 1;
        end
        
    end

    4'b1010: begin //OUT

    // T4: Reg A -> OUT
    if (t_state[3]) begin 
            en_out_A = 1;
            load_out = 1;
        end    
    end

    4'b1011: begin //HLT
        // No control signals needed, just halt the CPU
    end

    default: begin
        // For NOP and undefined opcodes, keep all control signals at their default (0)
    end

    endcase

end
    
    
endmodule