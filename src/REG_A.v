module REG_A (
    input clk,
    input clr,
    input load,
    input en_out, // Enable output to alu
    input [7:0] data_in,
    output [7:0] data_out
);

reg [7:0] internal_reg;

always @(posedge clk or posedge clr) begin
    if (clr) begin
        internal_reg <= 8'h00;
    end else if (load) begin // Added 'else' to prevent reset/load race
        internal_reg <= data_in;
    end
end


assign data_out = en_out ? internal_reg : 8'bz;

endmodule