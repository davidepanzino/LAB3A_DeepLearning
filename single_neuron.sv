module single_neuron #(parameter int_part=3, fract_part=5, N=4)(
    input logic signed [int_part+fract_part-1:0] x1 [N-1:0],
    input logic signed [int_part+fract_part-1:0] w1 [N-1:0],
    input logic signed [int_part+fract_part-1:0] b1,
    output logic signed [int_part+fract_part-1:0] out
);

    logic signed [int_part+fract_part-1:0] results [N:0];

    genvar i;
    generate
        for(i=0; i<=N; i++) begin
            if(i==0) begin
                MAC inst1(8'b00100000,b1,0, results[i]);
            end else begin
                MAC inst1(x1[i-1],w1[i-1],results[i-1],results[i]);
            end
        end        
    endgenerate
    
    activation_function inst2(results[N],2'b01,out);
    
endmodule