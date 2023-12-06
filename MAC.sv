module MAC #(parameter int_part=3, fract_part=5)(
    input logic signed [int_part+fract_part-1:0] a,
    input logic signed [int_part+fract_part-1:0] b,
    input logic signed [int_part+fract_part-1:0] c,
    output logic signed [int_part+fract_part-1:0] mac
);
     
    logic signed [2*(int_part+fract_part)-1:0] mult; //for avoiding overflow we need double size
    logic signed [2*(int_part+fract_part) : 0] temp_mac, temp_c; //for avoiding overflow we need one more bit for the int_part

    
    assign mult = a*b;
    assign temp_c = c<<fract_part;
    assign temp_mac = mult + temp_c;
    assign mac = {temp_mac[2*(int_part+fract_part)], temp_mac[int_part+2*fract_part-2:fract_part]};    
    
    //assign mac = a*b + c; //for fast check of the results in the test bench
    
endmodule
