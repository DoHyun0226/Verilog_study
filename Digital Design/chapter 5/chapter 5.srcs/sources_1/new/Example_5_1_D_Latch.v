`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/04 21:55:09
// Design Name: D Latch
// Module Name: D_Latch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module D_Latch(Q, D, enable);
    output reg Q;
    input D, enable; // enable: trigger signal for the latch 
    
    /*
    enable / D / Q
    0      / X / Q (hold)
    1      / 0 / 0
    1      / 1 / 1
    */

    always @ (enable, D)
        if (enable) Q <= D; // Same as: if(enable == 1) Q <= D;
        //Output Q is updated only when enable is 1. When enable is 0, output Q holds its previous value.
endmodule
