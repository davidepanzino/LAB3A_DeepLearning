`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 15:04:40
// Design Name: 
// Module Name: FSMD_NN_para
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


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/28 23:43:38
// Design Name: 
// Module Name: FSMD_serial
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


module FSMD_NN_para #(parameter inte_width = 2, parameter sign_bit = 1, parameter frac_width = 5,parameter N = 8,parameter unit_num = 5,parameter M_layer = 3)(
    input logic signed [inte_width + sign_bit + frac_width - 1 : 0] x1 [N-1:0],   
    input logic signed [inte_width + sign_bit + frac_width - 1 : 0] b1,
    input logic clk,
    input logic rst_n,
    input logic start,
    //input N inte_width + sign_bit + frac_width bits weights and inputs,one inte_width + sign_bit + frac_width bits bias

    output logic signed [inte_width + sign_bit + frac_width - 1 : 0] result[unit_num-1:0] 
    //output one inte_width + sign_bit + frac_width bits result 
    );
logic signed [inte_width + sign_bit + frac_width - 1 : 0] w1 [unit_num-1:0][N-1:0];
logic control; //use to stop 
logic comp;
logic o_done; //use to output
logic [15:0] count;
//input logic start,input logic clk,input logic rst_n,output control,output comp
FSM #(.M_layer(M_layer)) fsm1(.start(start),.clk(clk),.rst_n(rst_n),.control(control),.o_done(o_done),.comp(comp),.count(count));

weight_memory #(.inte_width(inte_width),.sign_bit(sign_bit),.frac_width(frac_width),.N(N),.M_layer(M_layer),.unit_num(unit_num)) mem1(.read_enable(comp),.count(count),.DATAOUT(w1));

datapath #(.inte_width(inte_width),.sign_bit(sign_bit),.frac_width(frac_width),.N(N),.unit_num(unit_num),.M_layer(M_layer)) dp1
(
.x1(x1),
.w1(w1),
.b1(b1),
.clk(clk),
.rst_n(rst_n),
.comp(comp),
.o_done(o_done),
.count(count),
.control(control),
.result(result)
);
endmodule
