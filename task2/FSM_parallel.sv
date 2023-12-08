module FSM_parallel #(parameter Width = 8, N = 4, M = 3)(
	input logic clk,    
	input logic rst_n,
	output logic [$clog2(M)-1:0] cnt_out
);

logic [$clog2(M)-1:0] cnt, next_cnt;
enum logic [1:0] {idle = 2'b00, computing = 2'b01, done = 2'b10} current_state, next_state;

always_ff @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		cnt <= 0;
		current_state <= idle;
	end else begin
		cnt <= next_cnt;
		current_state <= next_state;
	end
end

always_comb begin 
	case (current_state)
		idle: next_state = computing;
		computing: next_state = (cnt < M) ? computing : done;
		done: next_state = idle;
		default : next_state = idle;
	endcase
end

always_comb begin 
	next_cnt = (next_state == computing)? cnt + 1 : 0;
end

assign cnt_out = cnt;

endmodule