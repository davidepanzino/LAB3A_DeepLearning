module Data #(parameter Width = 8, N = 4) (
	input logic clk,
	input logic rst_n, 
	input logic signed [Width-1:0] input_values[N-1:0],
	output logic signed [Width-1:0] output_values[N-1:0]
);

always_ff @(posedge clk, negedge rst_n) begin 
	if(!rst_n) begin
		output_values <= 0;
	end else begin
		output_values <= input_values;
	end
end

endmodule