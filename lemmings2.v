module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah );
    
    parameter WL=2'b00, WR=2'b01;
    reg [1:0]state;
    reg [1:0]next;
    parameter fl = 2'b10, fr = 2'b11;
    
    
    // Combinational always block for state transition logic. Given the current state and inputs,
    // what should be next state be?
    // Combinational always block: Use blocking assignments.    
    always@(*) begin
		case (state)
            WL: next = !ground ? fl : (bump_left  ? WR : WL);
            WR: next = !ground ? fr : (bump_right ? WL : WR);
            fl: next = !ground ? fl : WL;
            fr: next = !ground ? fr : WR;
		endcase
    end
    
    
    // Combinational always block for state transition logic. Given the current state and inputs,
    // what should be next state be?
    // Combinational always block: Use blocking assignments.    
    always @(posedge clk, posedge areset) begin
		if (areset) state <= WL;
        else state <= next;
	end
		
		
	// Combinational output logic. In this problem, an assign statement are the simplest.
	// In more complex circuits, a combinational always block may be more suitable.		
	assign walk_left = (state==WL);
	assign walk_right = (state==WR);
    assign aaah = (state == fr || state == fl);

endmodule
