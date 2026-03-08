//instruction register(IR)
module IR(
    input wire[7:0] Data_in, 
    input wire clk,
    input wire load,
    output reg[7:0] Data_out
);


always @(posedge clk) begin
    if(load) begin
        Data_out <= Data_in;
    end

end
    
endmodule