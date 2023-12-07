module activation_function #(parameter int_part=3, fract_part=5, N=4)(
    input logic signed [int_part+fract_part-1:0] y,
    input logic [1:0] chosen_function,
    output logic signed [int_part+fract_part-1:0] out
);

    enum logic [1:0] {step_function = 2'b00, ReLU = 2'b01, sigmoid = 2'b10} act_funct;
    
    //for the sigmoid, 8bit (int_part=3, fract_part=5), minimum value is 100.00000 = -4, maximum value is 011.11111 = 3.96875. piecewise interpolation using 16 segments
    logic [7:0] xi_LUT [16:0] = {8'b01111111, 8'b01101111, 8'b01011111, 8'b01001111, 8'b00111111, 8'b00101111, 8'b00011111, 8'b00001111, 8'b00000000, 8'b11110000, 8'b11100000, 8'b11010000, 8'b11000000, 8'b10110000, 8'b10100000, 8'b10010000, 8'b10000000};
    logic [7:0] m_LUT [7:0] = {8'b00001000, 8'b00000111, 8'b00000110, 8'b00000100, 8'b00000011, 8'b00000010, 8'b00000001, 8'b00000001};
    logic [7:0] q_LUT [15:0] = {8'b00011100, 8'b00011011, 8'b00011001, 8'b00010111, 8'b00010100, 8'b00010010, 8'b00010000, 8'b00010000, 8'b00010000, 8'b00010000, 8'b00001110, 8'b00001100, 8'b00001001, 8'b00000111, 8'b00000101, 8'b00000011};
    logic signed [2*(int_part+fract_part)-1:0] mult;
    logic signed [2*(int_part+fract_part) : 0] temp_out, temp_q;
    
    
    always_comb begin
        case(chosen_function)
            step_function : begin
                                out = 0;
                                if(y[int_part+fract_part-1]) begin //negative value
                                    out[int_part+fract_part-1:fract_part] = '1;
                                end else begin
                                    out[fract_part] = 1;                                
                                end
                            end
            ReLU: out = (y[int_part+fract_part-1]) ? 0 : y; 
            sigmoid : begin 
                        for(int i=0; i<16; i++) begin
                            if(y>=$signed(xi_LUT[i]) && y<$signed(xi_LUT[i+1]) && i<8) begin
                                temp_q = q_LUT[i]<<fract_part;
                                mult = $signed(m_LUT[i])*y;
                            end else if (y>=$signed(xi_LUT[i]) && y<$signed(xi_LUT[i+1]) && i>=8) begin
                                temp_q = q_LUT[i]<<fract_part;
                                mult = $signed(m_LUT[15-i])*y;
                            end else begin
                                temp_out = 0;
                            end
                        end
                        temp_out = temp_q + mult;
                        out = {temp_out[2*(int_part+fract_part)], temp_out[int_part+2*fract_part-2:fract_part]}; 
                      end 
            default : out = 0;           
        endcase
    end

endmodule
