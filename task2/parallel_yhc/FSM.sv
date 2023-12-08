`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/08 14:03:41
// Design Name: 
// Module Name: FSM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module FSM #(parameter M_layer = 8)(
input logic start,
input logic clk,
input logic rst_n,
input logic control,
output logic comp,
output logic o_done,
output logic [15:0] count
);
//state
enum logic[1:0]  { idle = 2'b00,compute = 2'b01,done =2'b10} state,next;

logic [15:0] count_next;

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        state <= idle;
    end else begin
        state <= next;
    end
end

always_ff @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        count <= 0;
    end else begin
        count <= count_next;
    end
end

//change the state 
always_comb begin
    case (state)
        idle : 
            if(start) begin
                next = compute;
            end else begin
                next = idle;
            end
        compute : 
            if(control == 1) begin
                next = done;
            end else begin
                next = compute;
            end
        done :
            next = idle;
        default :
            next = idle;
    endcase
end

always_comb begin
    case (state)
        idle : begin 
            comp = 1'b0; 
            count_next = 0;
            o_done = 1'b0;
            end
        compute : begin 
            comp = 1'b1;
            count_next = count + 1;
            o_done = 1'b0;
        end
        done : begin 
            comp = 1'b0; 
            count_next = 0;
            o_done= 1'b1;
        end
        default :begin 
            comp = 1'b0; 
            count_next = 0;
            o_done = 1'b0;
        end
    endcase
end

endmodule