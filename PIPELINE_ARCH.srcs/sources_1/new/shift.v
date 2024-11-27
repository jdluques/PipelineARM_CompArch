module Shift (
    input wire [31:0] RS,
    input wire [31:0] RM,
    input wire [7:0] paquete,
    output reg [31:0] res 
);
    wire [1:0]sh;
    wire [4:0]shamt5;
    wire rs ;
    assign sh = paquete[2:1];
    assign shamt5 = paquete[7:3];
    assign rs = paquete[0];
    always @(*) begin
        case(rs) 
            1'b1: begin
                case (sh[1:0])
                    2'b00: res = RM << shamt5;         // LSL
                    2'b01: res = RM >> shamt5;         // LSR
                    2'b10: res = RM >>> shamt5;        // ASR
                    2'b11: res = (RM >> shamt5) | (RM << (32 - shamt5)); // ROR
                endcase
            end
            1'b0: begin
                case (sh[1:0])
                    2'b00: res = RM << RS;    // LSL
                    2'b01: res = RM >> RS;    // LSR
                    2'b10: res = RM >>> RS;   // ASR
                    2'b11: res = (RM >> RS) | (RM << (32 - RS)); // ROR
                endcase
            end
            default: res = 32'b0; // Valor por defecto si `rs` no coincide
        endcase
    end
endmodule
