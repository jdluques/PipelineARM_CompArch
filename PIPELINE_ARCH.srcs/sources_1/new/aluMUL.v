module aluMUL (
    input wire [31:0] RD,
    input wire [31:0] RA,
    input wire [31:0] RM,
    input wire [31:0] RN,
    input wire [2:0] ALUControlM,
    output reg [31:0] Result1,
    output reg [31:0] Result2,
    output wire [1:0] Flags
);
    reg [63:0] Result64;
    wire [63:0] Extra;
    assign Extra[31:0] = RA[31:0];
    assign Extra[63:32] = RD[31:0];

    wire neg;
    wire zero;

    always @(*) begin
        case (ALUControlM)
            3'b000: begin
                Result1 = RN * RM;
                Result2 = 32'b0;
            end
            3'b001: begin
                Result1 = (RN * RM) + RA;
                Result2 = 32'b0;
            end
            3'b100: begin
                Result64 = RN * RM;
                Result1 = Result64[31:0];
                Result2 = Result64[63:32];
            end
            3'b101: begin
                Result64 = (RN * RM) + Extra;
                Result1 = Result64[31:0];
                Result2 = Result64[63:32];
            end
            3'b110: begin
                Result64 = RN * RM;
                Result1 = Result64[31:0];
                Result2 = Result64[63:32];
            end
            3'b111: begin
                Result64 = (RN * RM) + Extra;
                Result1 = Result64[31:0];
                Result2 = Result64[63:32];
            end
            default: begin
                Result1 = 32'b0;
                Result2 = 32'b0;
            end
        endcase
    end

    assign neg = Result1[31];
    assign zero = (Result1 == 32'b0);

    assign Flags = {neg, zero};
endmodule
