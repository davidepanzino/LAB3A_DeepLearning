`timescale 1ns / 1ps

module test_bench #(parameter int_part=3, fract_part=5, N=4, M=3)();
    
    logic clk;
    logic rst_n;
    logic start; //tells to start the computation
    logic signed [int_part+fract_part-1:0] in_values [N-1:0];
    logic signed [int_part+fract_part-1:0] weight [M-1:0][N-1:0][N-1:0]; //we have as many matrixes as many layers pair we have 
    logic signed [int_part+fract_part-1:0] bias;
    logic signed [int_part+fract_part-1:0] out_values [N-1:0];
    
    initial begin
        clk = 0;
        rst_n = 1;
        start = 0;
        for(int i=0; i<N; i++) begin
            in_values[i] = $random;
        end
        for(int i=0; i<M; i++) begin
            for(int j=0; j<N; j++) begin
                for(int k=0; k<N; k++) begin
                    weight[i][j][k] = $random;
                end
            end
        end
        bias = $random;
        #7;
        rst_n = 0;
        #5
        rst_n = 1;
        #1
        start = 1; 
        #10
        start = 0;      
    end
    
    FSM inst(clk, rst_n, start, in_values, weight, bias, out_values);    
    
    always begin
        #5 clk = ~clk;
    end


endmodule

