module t_initial;
    reg A, B, C, D, E, F;
    parameter
        S0 = 1'b0,
        S1 = 1'b1;
    initial 
        fork
            #0 A = S1; B = S0; C = S0; D = S0; E = S1; F = S1;
            #10 A = ~A; B = ~B; C = ~C;
            #20 A = ~A; B = ~B; D = ~D; E = ~E;
            #30 B = ~B; E = ~E; F = ~F;
            #40 B = ~B; D = ~D; F = ~F;
            #50 B = ~B;
            #60 B = ~B; D = ~D;
            #70 B = ~B;
        join
endmodule