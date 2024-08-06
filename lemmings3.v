module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 
    
    reg [2:0]state;
    reg [2:0]next;
    
    
    parameter WL=3'b000, WR=3'b001;
    parameter fl = 3'b010, fr = 3'b011;
    parameter digL = 3'b100, digR = 3'b101;
    
    //States  
    always@(*) begin
		case (state)
            WL: next = !ground ? fl : dig ? digL : (bump_left  ? WR : WL);
            WR: next = !ground ? fr : dig ? digR :(bump_right ? WL : WR);
            fl: next = !ground ? fl : WL;
            fr: next = !ground ? fr : WR;
            digL : next = ground ? digL : fl;
            digR : next = ground ? digR : fr;
		endcase
    end
    
    
    // FSM
    always @(posedge clk, posedge areset) begin
		if (areset) state <= WL;
        else state <= next;
	end
		
		
	// Ouptput.	
	assign walk_left = (state==WL);
	assign walk_right = (state==WR);
    assign aaah = (state == fr || state == fl);
    assign digging = (state == digL || state == digR);


endmodule
