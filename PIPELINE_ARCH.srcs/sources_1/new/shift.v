module Shift (
    input wire [31:0] RS,
    input wire [31:0] RM,
    input wire [6:0] paquete,
    output reg [31:0] res 
);
    wire [1:0]sh;
    wire [4:0]shamt5;
    assign sh = paquete[1:0];
    assign shamt5 = paquete[6:2];
  
    always @(*) begin
               
        case (sh[1:0])
            2'b00: res = RM << shamt5;    // LSL
            2'b01: res = RM >> shamt5;    // LSR
            2'b10: res = RM >>> shamt5;   // ASR
            2'b11: res = (RM >> shamt5) | (RM << (32 - shamt5)); // ROR
        endcase
               
    end
endmodule
