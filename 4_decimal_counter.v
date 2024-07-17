module top_module (
    input clk,
    input reset,   // Synchronous active-high reset
    output [3:1] ena,
    output [15:0] q);
    
    
    
    assign ena[1] = (q[3:0] == 4'd9);
    assign ena[2] = (q[7:4] == 4'd9) && (q[3:0] == 4'd9);
    assign ena[3] = (q[11:8] == 4'd9) && (q[7:4] == 4'd9) && (q[3:0] == 4'd9);
    
    mod_10 counter1(clk, reset, 1'b1, q[3:0]);
    mod_10 counter2(clk, reset, ena[1], q[7:4]);
    mod_10 counter3(clk, reset, ena[2], q[11:8]);
    mod_10 counter4(clk, reset, ena[3], q[15:12]);

endmodule





module mod_10(
	input clk,
	input reset, enable,
	output reg [3:0] q);
    reg [3:0]q_next;
	
    always @(posedge clk) begin
        if (reset || (q == 4'd9 && enable != 1'b0))	// Count to 10 requires rolling over 9->0 instead of the more natural 15->0
			q <= 0;
    	else if(enable == 1'b1)
			q <= q + 4'd1;
        else
            q <= q_next;
    end
    
    always@(*) begin
        q_next = q;
    end
	
endmodule
