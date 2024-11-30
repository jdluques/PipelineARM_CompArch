module branchP (
    BTE,
    point,
    clk,
    rst
);
  input wire BTE;
  output wire point;
  input wire clk, rst;
  reg [1:0] state, nextstate;

  parameter s0 = 2'b00;  //Strong Not Taken
  parameter s1 = 2'b01;  //Weakly Not Taken
  parameter s2 = 2'b10;  //Weakly Taken
  parameter s3 = 2'b11;  //Strong Taken

  always @(posedge clk, posedge rst) begin
    if (rst) state <= s0;
    else state <= nextstate;
  end

  always @(*) begin
    case (state)
      s0: nextstate = BTE ? s1 : s0;
      s1: nextstate = BTE ? s2 : s0;
      s2: nextstate = BTE ? s3 : s1;
      s3: nextstate = BTE ? s3 : s2;
      default: nextstate = s0;
    endcase
  end
  assign point = (state == s2 || state == s3);
endmodule
