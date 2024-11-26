module mux3 (
    d0,
    d1,
    d2,
    s,
    y
);
  parameter WIDTH = 8;               // Tamaño de las entradas y salida
  input wire [WIDTH - 1:0] d0;       // Entrada 0
  input wire [WIDTH - 1:0] d1;       // Entrada 1
  input wire [WIDTH - 1:0] d2;       // Entrada 2
  input wire [1:0] s;                // Selector (2 bits)
  output wire [WIDTH - 1:0] y;       // Salida
  assign y = (s[1] ? d2 : (s[0] ? d1 : d0)); // Selección basada en el selector
endmodule
