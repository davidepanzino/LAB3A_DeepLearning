module Weight #(parameter Width = 8, N = 4, M = 3) (
	input logic [$clog2(M)-1:0] cnt,
	output logic signed [Width-1:0] out_weights [N-1:0][N-1:0]
);

logic signed [Width-1:0] weights [M-1:0][N-1:0][N-1:0];
logic signed [Width-1:0] bias;

initial begin
	 
	foreach(weights[i,j,k]) weights[i][j][k] = $rand;
	
	bias = $rand;
end

always_comb begin 
	out_weights = weights [cnt];
end

endmodule