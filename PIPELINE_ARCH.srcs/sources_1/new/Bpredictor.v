module branchP (
    BTE,
    point,
    clk,
    rst
);
input wire BTE;
output wire point;
input wire clk,rst;
reg [1:0] state,nextstate;

parameter s0 = 2'b00; //Strong Taken
parameter s1 = 2'b01; //Weakly Taken
parameter s2 = 2'b10; //Weakly No Taken
parameter s3 = 2'b11; //Strong No Taken

always @(posedge clk,posedge rst) begin
    if (rst) state <= s0;
    else state <= nextstate;
end

always @(*) begin
    case (state)
    s0: if(BTE) nextstate = s1; 
    else nextstate = s0;
    s1: if(BTE) nextstate = s2;
    else nextstate = s0;
    s2: if(BTE) nextstate = s3;
    else nextstate = s1;
    s3: if(BTE) nextstate = s0;
    else nextstate = s2;
    endcase
end
assign point = (state == (s0 | s1));
endmodule