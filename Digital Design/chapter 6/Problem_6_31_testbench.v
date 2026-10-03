`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/06/08 21:55:09
// Design Name: Testbench for Four-bit register with parallel load and asynchronous reset
// Module Name: t_FB_Reg_Parallel
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

module t_FB_Reg_Parallel;

    reg  [3:0] I;
    reg        clk;
    reg        rst;
    wire [3:0] A;

    // Device under test
    FB_Reg_Parallel UUT (
        .A   (A),
        .I   (I),
        .clk (clk),
        .rst (rst)
    );

    // 10 ns period clock
    initial clk = 0;
    always #5 clk = ~clk;

    // Check that A matches expected value, report pass/fail
    task check (input [3:0] expected);
        begin
            if (A !== expected)
                $display("[%0t] FAIL: I=%b rst=%b -> A=%b (expected %b)", $time, I, rst, A, expected);
            else
                $display("[%0t] PASS: I=%b rst=%b -> A=%b", $time, I, rst, A);
        end
    endtask

    initial begin
        $display("time\tclk\trst\tI\t\tA");
        $monitor("%0t\t%b\t%b\t%b\t%b", $time, clk, rst, I, A);

        // Asynchronous reset asserted before any clock edge
        rst = 0;
        I   = 4'b1010;
        #3;
        check(4'b0000);

        // Hold reset through a couple of clock edges: A must stay 0
        @(posedge clk);
        #1; check(4'b0000);
        @(posedge clk);
        #1; check(4'b0000);

        // Release reset, then verify parallel load on each posedge clk
        rst = 1;
        I   = 4'b1010;
        @(posedge clk);
        #1; check(4'b1010);

        I = 4'b0101;
        @(posedge clk);
        #1; check(4'b0101);

        I = 4'b1111;
        @(posedge clk);
        #1; check(4'b1111);

        I = 4'b0000;
        @(posedge clk);
        #1; check(4'b0000);

        // Assert asynchronous reset mid-cycle (not aligned to clock edge)
        I = 4'b1100;
        @(posedge clk);
        #1; check(4'b1100);
        #2 rst = 0;            // async reset asserted between clock edges
        #1; check(4'b0000);

        // Release reset and confirm normal loading resumes
        rst = 1;
        I   = 4'b0110;
        @(posedge clk);
        #1; check(4'b0110);

        #10 $finish;
    end

endmodule