module top (
    input wire clk,
    input wire reset,
    output wire [3:0] an,
    output wire [6:0] seg
);

  wire [31:0] PCF;
  wire [31:0] InstrF;
  wire MemWriteM;
  wire [31:0] DataAdrM;
  wire [31:0] WriteDataM;
  wire [31:0] ReadDataM;
  wire slow_clk;

  // Clock divider sencillo
  reg [31:0] clk_div_counter = 0;
  always @(posedge clk or posedge reset) begin
    if (reset) clk_div_counter <= 0;
    else clk_div_counter <= clk_div_counter + 1;
  end

  assign slow_clk = clk_div_counter[26];  //Un valor mas alto == mas lento

  arm arm_inst (
      .clk(slow_clk),
      .reset(reset),
      .PCF(PCF),
      .InstrF(InstrF),
      .MemWriteM(MemWriteM),
      .ALUOutM(DataAdrM),
      .WriteDataM(WriteDataM),
      .ReadDataM(ReadDataM)
  );

  imem imem_inst (
      .a (PCF[9:2]),
      .rd(InstrF)
  );


  dmem dmem_inst (
      .clk(slow_clk),
      .we (MemWriteM),
      .a  (DataAdrM[9:2]),
      .wd (WriteDataM),
      .rd (ReadDataM)
  );

  DisplayController display_inst (
      .clk(clk),
      .display_value(PCF[15:0]),
      .an(an),
      .seg(seg)
  );
endmodule
