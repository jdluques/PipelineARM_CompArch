module controller (
    clk,
    reset,
    InstrD,
    ALUFlagsE,
    RegSrcD,
    ImmSrcD,
    ALUSrcE,
    BranchTakenE,
    ALUControlE,
    MemWriteM,
    MemtoRegW,
    PCSrcW,
    RegWriteW,
    RegWriteM,
    MemtoRegE,
    PCWrPendingF,
    FlushE,
    shE
);
  input wire clk;
  input wire reset;
  input wire [31:0] InstrD;
  input wire [3:0] ALUFlagsE;
  output wire [1:0] RegSrcD;
  output wire [1:0] ImmSrcD;
  output wire ALUSrcE;
  output wire BranchTakenE;
  output wire [4:0] ALUControlE;
  output wire MemWriteM;
  output wire MemtoRegW;
  output wire PCSrcW;
  output wire RegWriteW;
  output wire RegWriteM;
  output wire MemtoRegE;
  output wire PCWrPendingF;
  input wire FlushE;
  reg [10:0] controlsD;
  wire CondExE;
  wire ALUOpD;
  reg [4:0] ALUControlD;
  wire ALUSrcD;
  wire MemtoRegD;
  wire MemtoRegM;
  wire RegWriteD;
  wire RegWriteE;
  wire RegWriteGatedE;
  wire MemWriteD;
  wire MemWriteE;
  wire MemWriteGatedE;
  wire BranchD;
  wire BranchE;
  reg [1:0] FlagWriteD;
  wire [1:0] FlagWriteE;
  wire PCSrcD;
  wire PCSrcE;
  wire PCSrcM;
  wire [3:0] FlagsE;
  wire [3:0] FlagsNextE;
  wire [3:0] CondE;
  // shift  //
  wire sh;
  output wire shE;

  always @(*) begin
    casex (InstrD[27:26])
      2'b00:
      case (InstrD[25])
        1'b1: controlsD = 11'b00001010010;
        1'b0:
        if (InstrD[24:21] == 4'b1101) controlsD = 11'b00000011011;
        else controlsD = 11'b00000010010;
      endcase
      2'b01:
      if (InstrD[20]) controlsD = 11'b00011110000;
      else controlsD = 11'b10011101000;
      2'b10: controlsD = 11'b01101000100;
      default: controlsD = 11'bxxxxxxxxxxx;
    endcase
  end
  assign {RegSrcD, ImmSrcD, ALUSrcD, MemtoRegD, RegWriteD, MemWriteD, BranchD, ALUOpD, sh} = controlsD;
  always @(*) begin
    if (ALUOpD) begin
      case (InstrD[24:21])
        4'b0100: ALUControlD = 5'b00000;
        4'b0010: ALUControlD = 5'b00001;
        4'b0000: ALUControlD = 5'b00010;
        4'b1100: ALUControlD = 5'b00011;
        4'b1101: ALUControlD = 5'b00100;
        4'b1000: ALUControlD = 5'b01001;
        4'b1001: ALUControlD = 5'b01010;
        default: ALUControlD = 5'bxxxxx;
      endcase
      FlagWriteD[1] = InstrD[20];
      FlagWriteD[0] = InstrD[20] & ((ALUControlD == 5'b00000) | (ALUControlD == 5'b00001));
    end else begin
      ALUControlD = 5'b00000;
      FlagWriteD  = 2'b00;
    end
  end
  assign PCSrcD = ((InstrD[15:12] == 4'b1111) & RegWriteD) | BranchD;
  floprc #(
      .WIDTH(8)
  ) flushedregsE (
      .clk(clk),
      .reset(reset),
      .clear(FlushE),
      .d({FlagWriteD, BranchD, MemWriteD, RegWriteD, PCSrcD, MemtoRegD, sh}),
      .q({FlagWriteE, BranchE, MemWriteE, RegWriteE, PCSrcE, MemtoRegE, shE})
  );
  flopr #(
      .WIDTH(6)
  ) regsE (
      .clk(clk),
      .reset(reset),
      .d({ALUSrcD, ALUControlD}),
      .q({ALUSrcE, ALUControlE})
  );
  flopr #(
      .WIDTH(4)
  ) condregE (
      .clk(clk),
      .reset(reset),
      .d(InstrD[31:28]),
      .q(CondE)
  );
  flopr #(
      .WIDTH(4)
  ) flagsreg (
      .clk(clk),
      .reset(reset),
      .d(FlagsNextE),
      .q(FlagsE)
  );
  conditional Cond (
      .Cond(CondE),
      .Flags(FlagsE),
      .ALUFlags(ALUFlagsE),
      .FlagsWrite(FlagWriteE),
      .CondEx(CondExE),
      .FlagsNext(FlagsNextE)
  );
  assign BranchTakenE   = BranchE & CondExE;
  assign RegWriteGatedE = RegWriteE & CondExE;
  assign MemWriteGatedE = MemWriteE & CondExE;
  wire PCSrcGatedE;
  assign PCSrcGatedE = PCSrcE & CondExE;
  flopr #(
      .WIDTH(4)
  ) regsM (
      .clk(clk),
      .reset(reset),
      .d({MemWriteGatedE, MemtoRegE, RegWriteGatedE, PCSrcGatedE}),
      .q({MemWriteM, MemtoRegM, RegWriteM, PCSrcM})
  );
  flopr #(
      .WIDTH(3)
  ) regsW (
      .clk(clk),
      .reset(reset),
      .d({MemtoRegM, RegWriteM, PCSrcM}),
      .q({MemtoRegW, RegWriteW, PCSrcW})
  );
  assign PCWrPendingF = (PCSrcD | PCSrcE) | PCSrcM;
endmodule
