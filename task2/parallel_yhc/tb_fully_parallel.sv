`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/26 19:08:23
// Design Name: 
// Module Name: tb
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


module tb #(parameter inte_width = 2,parameter sign_bit = 1,parameter frac_width = 5,parameter N = 4,parameter unit_num = 3,parameter M_layer =3)(
 );
logic signed [inte_width + sign_bit + frac_width - 1 : 0] x1 [N-1:0];
//logic signed [inte_width + sign_bit + frac_width - 1 : 0] w1 [unit_num-1:0][N-1:0];
logic signed [inte_width + sign_bit + frac_width - 1 : 0] b1;
logic clk;
logic rst_n;
logic start;
logic signed [inte_width + sign_bit + frac_width - 1 : 0] result[unit_num-1:0];

logic signed [inte_width + sign_bit + frac_width - 1:0] temp_result_middle [unit_num - 1:0];
//logic signed [inte_width + sign_bit + frac_width - 1 : 0] DATAOUT[unit_num-1:0][N-1:0];
logic o_done;
logic comp;
logic control;
logic [15:0] count ;
logic [1:0] state;
logic [1:0] next;
logic signed [inte_width + sign_bit + frac_width - 1 : 0] inputw1 [unit_num-1:0][N-1:0];
logic signed [inte_width + sign_bit + frac_width - 1 : 0] inputx1 [N-1:0];

assign state = dut.fsm1.state;
assign next = dut.fsm1.next;
assign count = dut.fsm1.count;
assign o_done = dut.fsm1.o_done;
assign comp = dut.fsm1.comp;
assign control = dut.fsm1.control;
assign temp_result_middle = dut.dp1.temp_result_middle;
//assign DATAOUT = dut.mem1.DATAOUT;
//assign w1 = dut.dp1.w1;
assign inputw1 = dut.dp1.inputw1;
assign inputx1 = dut.dp1.inputx1;
    //input N inte_width + sign_bit + frac_width bits weights and inputs,one inte_width + sign_bit + frac_width bits bias
FSMD_NN_para #(.inte_width(inte_width),.sign_bit(sign_bit),.frac_width(frac_width),.N(N),.unit_num(unit_num),.M_layer(M_layer)) dut(
    .x1(x1),
    .b1(b1),
    .clk(clk),
    .rst_n(rst_n),
    .start(start),
    .result(result) 
    //output one inte_width + sign_bit + frac_width bits result 
    );
initial begin
    clk = 0;
    #1
    forever begin
    clk = ~clk;
    #1;
    end
end

initial begin
    rst_n = 1'b0;
    start = 1'b1;
    #1;
    rst_n = 1'b1;
    b1 = 8'b00000000;
    for(int k = 0;k < N;k++)begin
        if( k >= N/2) begin
            x1[k] = 8'b00110000;
        end else begin
            x1[k] = 0;
        end
    end
end


endmodule
