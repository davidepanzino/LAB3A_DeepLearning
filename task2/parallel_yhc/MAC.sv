`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/26 18:35:42
// Design Name: 
// Module Name: MAC
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

module  MAC #(parameter inte_width = 1,parameter sign_bit = 1,parameter frac_width = 2)
(
    input logic signed [sign_bit+inte_width+frac_width-1 : 0] x1,//inputs, now its 8bit long with 1 sign bit,2 integer bits ,5 fractional bits 
    input logic signed [sign_bit+inte_width+frac_width-1 : 0] w1,//weights
    input logic signed [sign_bit+inte_width+frac_width-1 : 0] b1,//bias 补码

    output logic signed [sign_bit+inte_width+frac_width-1 : 0] result
);


parameter MSB = sign_bit + inte_width + frac_width - 1;
parameter width = sign_bit + inte_width + frac_width;
parameter extend_width = 2*width;

logic signed [extend_width - 1 : 0] multi_result;//use twice longer bits to hold the temp result
logic signed [extend_width - 1 : 0] extend_x1;
logic signed [extend_width - 1 : 0] extend_w1;

logic signed [extend_width - 1 :0] extend_b1;

logic signed [extend_width- 1 : 0] extend_result;

//first do multiplication 
always_comb begin
    //first extend x1 and w1
    extend_x1 = x1;
    extend_w1 = w1;
   
    multi_result = extend_x1 * extend_w1; 
    //这里出来的是补码，format here is inte_width = 3,sign bit = 1,frac_width = 4 so if we want to add this result Q4.4 with bias Q2.2
    //so we have to move the bits
     extend_b1 = b1;
     extend_b1 = extend_b1 << frac_width;


    extend_result = extend_b1 + multi_result; //8位补码
   
    //extend_result = extend_result >> frac_width;
end

assign result = {extend_result[extend_width-1],extend_result[2*frac_width + inte_width-1: 2*frac_width],extend_result[2*frac_width-1:frac_width]};
//补码








endmodule
