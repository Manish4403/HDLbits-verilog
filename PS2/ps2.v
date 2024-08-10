module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output done); //
	
    reg [1:0]count;
    reg[1:0] state, next_state;
    parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10;
    // State transition logic (combinational)
    always@(*) begin
        case(state)
            s0: next_state = in[3] ? s1 : s0;
	    s1: next_state = (count < 2'd1) ? s1 : s2; \\counter should count only one state.
            s2: next_state = in[3] ? s1: s0;
            default next_state = s0;
        endcase
    end
    
    
    // State flip-flops (sequential)
    always@(posedge clk) begin
        if(reset) begin
            state <= s0;
        end
        else if(state == s1) begin
            count <= count + 1'b1;
            state <= next_state;
        end
        else begin
            count <= 1'b0;
            state <= next_state;
        end
    end
    // Output logic
    
    assign done = (state == s2)? 1'b1 : 1'b0;

endmodule
