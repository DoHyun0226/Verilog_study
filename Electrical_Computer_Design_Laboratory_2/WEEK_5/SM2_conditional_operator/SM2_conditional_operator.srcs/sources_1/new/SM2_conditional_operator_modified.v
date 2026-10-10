module SM2_conditional_operator_modified(clk, rst, A, B, C, state, y);

input clk, rst;
input A, B, C;
// A: 50원, B:100원, C: 자판기 음료 구매버튼 누르는 동작
wire A_reg, B_reg, C_reg;
wire A_trig, B_trig, C_trig;
output reg [2:0] state;
output y;

parameter S0 = 3'b000;
parameter S50 = 3'b001;
parameter S100 = 3'b010;
parameter S150 = 3'b011;
parameter S200 = 3'b100;
parameter HOLD = 28'd250_000_000; // 5 s at 50 MHz

reg [27:0] y_cnt;

SM2_one_shot one_shot_trigger(rst, clk, {A, B, C}, {A_reg, B_reg, C_reg}, {A_trig, B_trig, C_trig});
//(rst, clk, SM_in, SM2_reg, SM2_trig)

always @(negedge rst or posedge clk) begin
    if(!rst) state <= S0;
    else begin
        case(state)
            S0 : state <= A_trig ? S50 : B_trig ? S100 : S0;
            S50 : state <= A_trig ? S100 : B_trig ? S150 : S50;
            S100 : state <= A_trig ? S150 : B_trig ? S200 : S100;
            S150 : state <= A_trig ? S200 : B_trig ? S200 : S150;
            S200 : state <= A_trig ? S200 : B_trig ? S200 : C_trig ? S0 : S200;
            default : state <= S0;
        endcase
    end
end

// S200에서 C_trig가 1이 되면 HOLD clock 동안 y = 1 유지
always @(negedge rst or posedge clk) begin
    if(!rst) y_cnt <= 28'd0;
    else if((state == S200) & C_trig) y_cnt <= HOLD;
    else if(y_cnt != 28'd0) y_cnt <= y_cnt - 28'd1;
end

assign y = (y_cnt != 28'd0);

endmodule