`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 14:13:17
// Design Name: 
// Module Name: datapath
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

//N is the input numbers and K is the NN unit numbers M_layer is the number of layers ,here we suppose N > unit_num 
module datapath #(parameter inte_width = 2, parameter sign_bit = 1, parameter frac_width = 5, parameter N = 8, parameter unit_num = 5, parameter M_layer = 5)(
input logic signed [inte_width + sign_bit + frac_width - 1 : 0] x1 [N-1:0],
input logic signed [inte_width + sign_bit + frac_width - 1 : 0] w1 [unit_num-1:0][N-1:0],
input logic signed [inte_width + sign_bit + frac_width - 1 : 0] b1,
input logic clk,
input logic rst_n,
input logic [15:0] count,
input logic comp,
input o_done,
output logic control,
output logic signed [inte_width + sign_bit + frac_width - 1 : 0] result[unit_num - 1:0]
);

logic signed [inte_width + sign_bit + frac_width - 1:0] temp_result_middle [unit_num - 1:0];
logic signed [inte_width + sign_bit + frac_width - 1:0] temp_result [unit_num - 1:0];  //we store the temp_result here and to add them
logic signed [inte_width + sign_bit + frac_width - 1 : 0] inputx1 [N-1:0];
logic signed [inte_width + sign_bit + frac_width - 1 : 0] inputw1 [unit_num-1:0][N-1:0];


//generate the N neruon units 
genvar i;
generate 
    for(i = 0; i< unit_num; i++)begin
        NN_unit_para #(.inte_width(inte_width),.sign_bit(sign_bit),.frac_width(frac_width),.N(N)) NN_unit(
        .x1(inputx1),
        .w1(inputw1[i]),
        .b1(b1),
        .result(temp_result[i])
    );
    end
endgenerate
/*
logic signed [inte_width + sign_bit + frac_width - 1 : 0] zero_array [N-1:0];
//set zero
always_comb begin
    for(int p = 0;p <N;p++) begin
        zero_array[p] = 0;
    end
end
*/

//avoid combintional loop
always_ff @(posedge clk) begin
    if(count < M_layer) begin
        temp_result_middle <= temp_result;
    end else begin 
        for(int i = 0;i< unit_num;i++)begin
            temp_result_middle[i] <= 0; 
        end
    end
end
// computation logic 
always_comb begin
    if(comp) begin //do the computation 
        if(count == 0)begin // the first layer
            inputx1 = x1;
            inputw1 = w1;
        end else begin
            for(int j = 0; j < N; j++) begin //the rest of the layers 
                if(j < unit_num) begin
                    inputx1[j] = temp_result_middle[j]; //把多余的输入设为0
                end else begin
                    inputx1[j] = 0;
                end
            end
           for(int i = 0;i < unit_num; i++)begin
                for(int j = 0;j < N; j++)begin
                    if(j < unit_num)begin                
                        inputw1[i][j] = w1[i][j]; 
                    end else begin
                        inputw1[i][j] = 0;
                    end
                end
           end       
        end
    end else begin
       // inputx1 = zero_array;
        //inputw1 = zero_array;
    end
end

//control Logic
always_comb begin
    if(comp) begin
        if(count == M_layer-1) begin
            control = 1'b1;
        end else begin
            control = 1'b0;
        end   
    end else begin
        control = 1'b0;
    end
end


// reset and output logic
always_ff @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        for(int k = 0; k < unit_num;k++) begin
            result[k] = 0;
        end
    end else begin 
        if(count == M_layer-1) begin
            for(int num = 0; num < unit_num; num++) begin
                result[num] <= temp_result_middle[num];
            end
        end
    end
end
endmodule
