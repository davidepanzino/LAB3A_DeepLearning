`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/11/26 18:37:27
// Design Name: 
// Module Name: fully_Parallel
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


module fully_Parallel #(parameter inte_width = 2, parameter sign_bit = 1, parameter frac_width = 5,parameter N = 8)(
    input logic signed [inte_width + sign_bit + frac_width - 1 : 0] x1 [N-1:0],
    input logic signed [inte_width + sign_bit + frac_width - 1 : 0] w1 [N-1:0],
    input logic signed [inte_width + sign_bit + frac_width - 1 : 0] b1,
    //input N inte_width + sign_bit + frac_width bits weights and inputs,one inte_width + sign_bit + frac_width bits bias

    output logic signed [inte_width + sign_bit + frac_width - 1 : 0] result
    
    //output one inte_width + sign_bit + frac_width bits result 


    );
logic signed [inte_width + sign_bit + frac_width - 1 : 0] temp_result [N:0];
logic signed [inte_width + sign_bit + frac_width - 1 : 0] one ;
logic signed [inte_width + sign_bit + frac_width - 1 : 0] zero;

always_comb begin
    for(int j = 0;j < inte_width + sign_bit + frac_width ;j++)begin
        if(j == frac_width)begin
            one[j] = 1'b1;
        end else begin
            one[j] = 1'b0; 
        end
    end
    
    
end

assign zero = 0;
genvar i;
generate
    for( i = 0; i <= N ; i ++ ) begin//we have to use N MACS to cacluate 
        if(!i)begin
            MAC #(.inte_width(inte_width),.sign_bit(sign_bit),.frac_width(frac_width)) MAC1 (.x1(one),.w1(b1),.b1(zero),.result(temp_result[0]));
        end else begin
            MAC #(.inte_width(inte_width),.sign_bit(sign_bit),.frac_width(frac_width)) MAC1 (.x1(x1[i-1]),.w1(w1[i-1]),.b1(temp_result[i-1]),.result(temp_result[i]));
        end
    end
endgenerate

activation_function #(.int_part(3),.fract_part(5),.N(8)) activation_function_1 (.y(temp_result[N]),.chosen_function(2'b01), .out(result));


endmodule