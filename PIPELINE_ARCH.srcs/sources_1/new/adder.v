module adder (
    a,
    b,
    y
);
  parameter WIDTH = 8;  // Tamaño de los datos (por defecto 8 bits)
  input wire [WIDTH - 1:0] a; // Entrada A
  input wire [WIDTH - 1:0] b; // Entrada B
  output wire [WIDTH - 1:0] y; // Resultado
  assign y = a + b; // Operación de suma
endmodule
