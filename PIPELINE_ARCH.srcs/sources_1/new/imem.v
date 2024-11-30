module imem (
    input  wire [ 7:0] a,
    output reg  [31:0] rd
);
  reg [31:0] RAM[0:255];

  integer i;

  initial begin
    RAM[0] = 32'hE04F000F;  // Instruccion 0
    RAM[1] = 32'hE2801005;  // Instruccion 1
    RAM[2] = 32'hE2411001;  // Instruccion 2
    RAM[3] = 32'hE2511000;  // Instruccion 3
    RAM[4] = 32'hCAFFFFFC;  // Instruccion 4
    RAM[5] = 32'hE2802002;  // Instruccion 5
    RAM[6] = 32'hE280000C;  // Instruccion 6
    RAM[7] = 32'hE5802004;  // Instruccion 7
    RAM[8] = 32'hE5903004;  // Instruccion 8
    RAM[9] = 32'hEAFFFFFE;  // BUCLE INFINITO
    for (i = 10; i < 256; i = i + 1) begin
      RAM[i] = 32'h00000000;
    end
  end

  always @(*) begin
    rd = RAM[a];
  end
endmodule
