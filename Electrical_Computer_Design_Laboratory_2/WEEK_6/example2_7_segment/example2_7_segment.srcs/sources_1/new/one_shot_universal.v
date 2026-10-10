`timescale 1ns / 1ps

// one_shot_universal: WIDTH-bit one-shot trigger
// each bit of btn_trig goes high for exactly one clock on the rising edge of the matching btn bit
module one_shot_universal(clk, rst, btn, btn_trig);

parameter WIDTH = 1; // Default Value of Width = 1
// Width must be modified by using one_shot_universal #(.Width(number)) instance_name(clk, rst, btn, btn_trig)
input clk, rst, btn;
// [BUG] btn is declared as 1-bit, not [WIDTH-1:0]
//   -> when WIDTH > 1, only btn[0] of the connected bus enters this module
//      and btn_trig[WIDTH-1:1] never goes high
//   fix: input clk, rst;
//        input [WIDTH-1:0] btn;
reg [WIDTH-1:0] btn_reg;          // btn value of the previous clock
output reg [WIDTH-1:0] btn_trig;  // one-shot output

always @(negedge rst or posedge clk) begin
    if(!rst) begin // asynchronous active-low reset
        btn_reg <= {WIDTH{1'b0}};
        btn_trig <= {WIDTH{1'b0}};
    end
    else begin
        btn_reg <= btn;                // store current btn
        btn_trig <= btn & ~btn_reg;    // 1 only when btn: 0 -> 1 (rising edge)
    end
end

endmodule
