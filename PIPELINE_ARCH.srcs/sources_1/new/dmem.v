module dmem (
    input wire clk,
    input wire we,
    input wire [7:0] a,
    input wire [31:0] wd,
    output reg [31:0] rd
);

  reg [31:0] RAM[0:255];

  integer i;
  initial begin
    for (i = 0; i < 256; i = i + 1) begin
      RAM[i] = 32'h00000000;
    end
  end

  always @(posedge clk) begin
    if (we) RAM[a] <= wd;
    rd <= RAM[a];
  end
endmodule
