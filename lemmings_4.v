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
    
    
    reg [3:0]state;
    reg [3:0]next;
    reg [31:0] count;
    
    
    parameter WL=4'b0000, WR=4'b0001;
    parameter digL = 4'b0100, digR = 4'b0101;
    parameter splat_l = 4'b0110, splat_r = 4'b0111;
    parameter idle = 4'b1000;
    
    //States  
    always@(*) begin
		case (state)
            WL: next = !ground ? splat_l : dig ? digL : (bump_left  ? WR : WL);
            WR: next = !ground ? splat_r : dig ? digR :(bump_right ? WL : WR);
            digL : next = ground ? digL : splat_l;
            digR : next = ground ? digR : splat_r;
            splat_l: next = ground ? ((count > 19) ? idle : WL) : splat_l; // Because initially count is so that is also 1 cycle.(0 to 19)
            splat_r: next = ground ? ((count > 19) ? idle : WR) : splat_r;
            idle: next = idle;
            default: next = idle;
		endcase
    end
    
    
    // FSM
    always @(posedge clk, posedge areset) begin
        if (areset)
            state <= WL;
        else if(state == splat_l || state == splat_r) begin
            count <= count + 1;
            state <= next;
        end
        else begin 
            state <= next;
            count <= 0;   // Because when you change state in between then counter should be reset to zero again.
        end
	end
		
		
	// Ouptput.	
	assign walk_left = (state==WL);
	assign walk_right = (state==WR);
    assign aaah = (state == splat_l || state == splat_r);
    assign digging = (state == digL || state == digR);

endmodule

//module counter_20();
    
//endmodule
