module DisplayController (
    input wire clk,
    input wire [15:0] display_value_1,
    input wire [15:0] display_value_2,
    output reg [3:0] an,
    output reg [6:0] seg
);
  reg  [ 3:0] digit;
  reg  [19:0] refresh_counter = 0;
  wire [ 1:0] active_digit;

  always @(posedge clk) begin
    refresh_counter <= refresh_counter + 1;
  end

  assign active_digit = refresh_counter[19:18];

  always @(*) begin
    case (active_digit)
      2'b00:   digit = display_value_1[3:0];
      2'b01:   digit = display_value_1[7:4];
      2'b10:   digit = display_value_2[3:0];
      2'b11:   digit = display_value_2[7:4];
      default: digit = display_value_1[3:0];
    endcase
  end

  always @(*) begin
    case (active_digit)
      2'b00:   an = 4'b1110;
      2'b01:   an = 4'b1101;
      2'b10:   an = 4'b1011;
      2'b11:   an = 4'b0111;
      default: an = 4'b1110;
    endcase
  end
  
  always @(*) begin
    case (digit)
      4'h0: seg = 7'b1000000;  // '0'
      4'h1: seg = 7'b1111001;  // '1'
      4'h2: seg = 7'b0100100;  // '2'
      4'h3: seg = 7'b0110000;  // '3'
      4'h4: seg = 7'b0011001;  // '4'
      4'h5: seg = 7'b0010010;  // '5'
      4'h6: seg = 7'b0000010;  // '6'
      4'h7: seg = 7'b1111000;  // '7'
      4'h8: seg = 7'b0000000;  // '8'
      4'h9: seg = 7'b0010000;  // '9'
      4'hA: seg = 7'b0001000;  // 'A'
      4'hB: seg = 7'b0000011;  // 'b'
      4'hC: seg = 7'b1000110;  // 'C'
      4'hD: seg = 7'b0100001;  // 'd'
      4'hE: seg = 7'b0000110;  // 'E'
      4'hF: seg = 7'b0001110;  // 'F'
      default: seg = 7'b1000000;  // '0'
    endcase
  end

endmodule