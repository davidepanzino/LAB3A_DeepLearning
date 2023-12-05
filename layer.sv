module layer #(parameter int_part=3, fract_part=5, N=8)( 
    input logic clk,
    input logic [$clog2(N)-1:0] count_neuron, 
    input logic signed [int_part+fract_part-1:0] prev_lay_out [N-1:0],
    input logic signed [int_part+fract_part-1:0] weight [N-1][N-1], //i refers to the neuron , j moves through the weights to that neuron
    output logic signed [int_part+fract_part-1:0] curr_lay_out [N-1:0]
);
        
    logic signed [int_part+fract_part-1:0] curr_weight [N-1];
    
    always_comb begin
        for(int i=0; i<$clog2(N); i++) begin
            curr_weight[i] = weight[count_neuron][i];
        end
    end
    
    single_neuron inst(prev_lay_out, curr_weight, 8'b00100000, curr_lay_out[count_neuron]); 
      
endmodule
