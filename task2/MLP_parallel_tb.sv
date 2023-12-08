module MLP_parallel_tb;
	logic clk, rstn;
	parameter N = 4; // number of neurons per layer
	parameter M = 3; // number of layers
  	parameter Width = 8;

  	logic signed [Width-1:0] initial_inputs[N-1:0];
	logic signed [Width-1:0] final_outputs[N-1:0];


  	MLP_parallel#(Width, N, M) dtu(clk, rstn, initial_inputs, final_outputs);

  	always #5 clk = !clk;


  	initial begin
	    clk = 1'b1;
	    rstn = 1'b0;
	    foreach(initial_inputs[i]) initial_inputs[i] = 8'b001_00000;
	    #10;
	    rstn = 1'b1;
	end

endmodule