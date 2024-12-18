module shift (
    input wire [31:0] RS,
    input wire [31:0] RM,
    input wire [7:0] paquete,
    output reg [31:0] res 
);
    wire [1:0]sh;
    wire [4:0]shamt5;
    wire rs ;
    wire [31:0] extSHAMT5;
    assign sh = paquete[2:1];
    assign shamt5 = paquete[7:3];
    assign rs = paquete[0];
    assign extSHAMT5 = {27'b0, shamt5};
    always @(*) begin
        case(rs) 
            1'b1: begin
                case (sh[1:0])
                    2'b00: res = RM << RS;         // LSL
                    2'b01: res = RM >> RS;         // LSR
                    2'b10: res = RM >>> RS;        // ASR
                    2'b11: res = (RM >> RS) | (RM << (32 - RS)); // ROR
                endcase
            end
            1'b0: begin
                case (sh[1:0])
                    2'b00: res = RM << extSHAMT5;    // LSL
                    2'b01: res = RM >> extSHAMT5;    // LSR
                    2'b10: res = RM >>> extSHAMT5;   // ASR
                    2'b11: res = (RM >> extSHAMT5) | (RM << (32 - extSHAMT5)); // ROR
                endcase
            end
            default: res = 32'b0; // Valor por defecto si `rs` no coincide
        endcase
    end
endmodule
