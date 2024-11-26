module mux2 (
    d0,
    d1,
    s,
    y
);
  parameter WIDTH = 8;         // Tamaño de las entradas y la salida
  input wire [WIDTH - 1:0] d0; // Entrada 0
  input wire [WIDTH - 1:0] d1; // Entrada 1
  input wire s;                // Selector
  output wire [WIDTH - 1:0] y; // Salida
  assign y = (s ? d1 : d0);    // Selección basada en el selector
endmodule
