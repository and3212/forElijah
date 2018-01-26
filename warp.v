`timescale 1ns / 1ps
`default_nettype none

module warpModule(
    input wire clk,
    input wire [9:0] j,
    input wire [9:0] i,
    output reg [20:0] out);
    
    reg [25:0] x;
    reg [25:0] y;
    
    always @(posedge clk) begin
        x = ((4096 * j) + (59 * i) + 250828) >> 12;
        y = ((-54 * j) + (4096 * i) + -57869) >> 12;
		
        if (x < 640 && y < 480 && x >= 0 && y >= 0) begin
            out <= (y * 640) + x;
        end
		
    end    
	
endmodule
