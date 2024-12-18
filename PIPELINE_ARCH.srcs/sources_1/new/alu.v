module alu (
    a,
    b,
    ALUControl,
    Result,
    Flags
);
  input wire [31:0] a;
  input wire [31:0] b;
  input wire [4:0] ALUControl;
  output reg [31:0] Result;
  output wire [3:0] Flags;
  wire neg;
  wire zero;
  wire carry;
  wire overflow;
  wire [31:0] condinvb;
  wire [32:0] sum;
  assign condinvb = (ALUControl[0] ? ~b : b);
  assign sum = (a + condinvb) + ALUControl[0];
  always @(*) begin
    casex (ALUControl[1:0])
      5'b0000x: Result = sum;
      5'b00010: Result = a & b;
      5'b00011: Result = a | b;
      5'b00100: Result = b;
    endcase
  end
  assign neg = Result[31];
  assign zero = (Result == 32'b0);
  assign carry = (ALUControl[1] == 1'b0) & sum[32];
  assign overflow = ((ALUControl[1] == 1'b0) & ~((a[31] ^ b[31]) ^ ALUControl[0])) & (a[31] ^ sum[31]);
  assign Flags = {neg, zero, carry, overflow};
endmodule