`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 20:17:28
// Design Name: 
// Module Name: weight_memory
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


module weight_memory#(parameter inte_width =2 ,parameter sign_bit = 1,parameter frac_width = 5, parameter N = 8,parameter M_layer = 5,parameter unit_num = 5)
(
    input logic read_enable,
    input logic [15:0] count,//count infers to layer number
    //input logic write_enable,
    //input N inte_width + sign_bit + frac_width bits weights and inputs,one inte_width + sign_bit + frac_width bits bias
    output logic signed [inte_width + sign_bit + frac_width - 1 : 0] DATAOUT[unit_num-1:0][N-1:0] 
    );

    logic signed [inte_width + sign_bit + frac_width - 1 : 0] rom[M_layer-1:0][unit_num-1:0][N-1:0];

    initial begin
        for(int i = 0; i < M_layer; i++) begin
            for(int j = 0; j < unit_num;j++)begin
                for(int k = 0;k < N;k++)begin
                    rom[i][j][k] = $random;
                end
            end
        end
    end
    
    always_comb begin
        if(read_enable)begin
            for(int i = 0; i < unit_num; i++)begin
                for(int j = 0;j < N;j++)begin
                    DATAOUT[i][j] = rom[count][i][j];
                end
            end
    end
   end
endmodule
