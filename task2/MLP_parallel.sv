module MLP_parallel  #(parameter Width = 8, N = 4, M = 3)(
	input logic clk,    
	input logic rst_n,
	input logic signed [Width-1:0] initial_inputs[N-1:0],
	output logic signed [Width-1:0] final_outputs[N-1:0]
);
	
parameter INT_WIDTH  = Width * 3 / 8;
parameter FRAC_WIDTH = Width * 5 / 8;

logic [$clog2(M)-1:0] cnt;
logic signed [Width-1:0] data_inputs[N-1:0];
logic signed [Width-1:0] data_outputs[N-1:0];
logic signed [Width-1:0] weights [N-1:0][N-1:0];


FSM_parallel#(Width, N, M) fsm(clk, rst_n, cnt);
Data#(Width, N) data_reg(clk, rst_n, data_inputs, data_outputs);
Weight#(Width, N, M) weight_mem(cnt, weights);

genvar i;
generate
    for(i=0; i<N; i++) begin
    	single_neuron#(INT_WIDTH, FRAC_WIDTH, N) neuron(data_outputs, weights[i], weight_mem.bias, data_inputs[i]);
    end        
endgenerate
	
endmodule