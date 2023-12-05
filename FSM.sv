module FSM #(parameter int_part=3, fract_part=5, N=8, M=3)(
    input logic clk,
    input logic rst_n,
    input logic start, //tells to start the computation
    input logic signed [int_part+fract_part-1:0] in_values [N-1:0],
    input logic signed [int_part+fract_part-1:0] weight [M-1][N-1][N-1], //we have as many matrixes as many layers pair we have 
    output logic signed [int_part+fract_part-1:0] out_values [N-1:0]
    //output logic [$clog2(N)-1:0] count_neuron    
);

    logic [$clog2(M)-1:0] count_layer, count_layer_next;
    logic [$clog2(N)-1:0] count_neuron, count_neuron_next; 
    logic signed [int_part+fract_part-1:0] current_weight [N-1][N-1]; 
    logic signed [int_part+fract_part-1:0] prev_lay_out [N-1:0];
    logic signed [int_part+fract_part-1:0] curr_lay_out [N-1:0];
    
    enum logic [1:0] {idle = 2'b00, computing = 2'b01, done = 2'b10} current_state, next_state;
    
    always_ff @(posedge clk, negedge rst_n) begin
        if(!rst_n) begin
            current_state <= idle;
            count_layer <= 0;
        end else begin
            current_state <= next_state;
            count_layer <= count_layer_next;
            count_neuron <= count_neuron_next;
        end
    end

    always_comb begin
        case(current_state)
            idle : next_state = (start) ? computing : idle;
            computing : next_state = (count_layer_next == M-1) ? done : computing;
            done : next_state = idle;
        endcase
    end
    
    always_comb begin
        case(current_state)
            idle : begin
                    count_layer_next = 0;
                    count_neuron_next = 0;
                    prev_lay_out = in_values;
                   end
            computing : begin
                            if(count_neuron < N) begin
                                count_neuron_next = count_neuron + 1;
                                count_layer_next = count_layer;
                            end else begin
                                count_neuron_next = 0;
                                count_layer_next = count_layer+1;
                                prev_lay_out = curr_lay_out;
                            end
                        end
            done : begin
                    out_values = curr_lay_out;
                   end
        endcase
    end
    
    always_comb begin
        for(int i=0; i<N; i++) begin
            for(int j=0; j<N; j++) begin
                current_weight[i][j] = weight[count_neuron][i][j];
            end            
        end
    end
    
    layer inst(clk, count_neuron, prev_lay_out, current_weight, curr_lay_out);

endmodule
