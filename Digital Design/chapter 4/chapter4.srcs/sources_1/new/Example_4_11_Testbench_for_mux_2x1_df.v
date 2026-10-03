`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/04/06 20:14:55
// Design Name: Example_4_11_Testbench_for_mux_2x1_df
// Module Name: 
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Testbench for two-to-one line multiplexer
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


// Testbench with stimulus for mux_2x1_df
module t_mux_2x1_df;
    wire t_mux_out;
    reg t_A, t_B, t_sel;
    parameter stop_time = 50;
    mux_2x1_df M1(t_mux_out, t_A, t_B, t_sel); // Instantiation of circuit to be tested
    // Alternative association of ports by name: mux_2x1_df M1(.m_out(t_mux_out), .A(t_A), .B(t_B), .select(t_sel));

    initial begin  // Stimulus generator
        t_sel = 1;t_A = 0; t_B = 1; 
        #10 t_A = 1; t_B = 0;
        #10 t_sel = 0;
        #10 t_A = 1; t_B = 1;
    end
    initial begin
        // $display(" time Sel A B m_out");
        // $monitor($time,," %b %b %b %b", t_sel, t_A, t_B, t_mux_out);
        $monitor(" time=", $time,,"t_sel=%b t_A=%b t_B=%b t_mux_out=%b", t_sel, t_A, t_B, t_mux_out);
        //쉼표 두 개 사이에 아무 인자도 넣지 않고 비워두면(Null argument) "공백(Space) 한 칸을 출력하라"는 뜻
    end
endmodule

// Dataflow description of two-to-one line multiplexer

module mux_2x1_df
(
    output m_out,
    input A, B, sel
);
    assign m_out = (sel) ? A : B; // Alternative: assign m_out = sel ? A : B;
endmodule

