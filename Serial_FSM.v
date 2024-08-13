module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output done
); 
    
    reg [2:0] state, next_state;
    parameter [2:0] s0 = 0, s1 = 1, s2 = 2, s3= 3, s4= 4;
    reg[4:0] count;
    
    //FSM Login
    always@(*) begin
        case(state)
            s0: next_state = in ? s0 : s1;
            s1: next_state = s2;
            s2: next_state = count == 4'd7 ? (in ? s3 : s4) : s2;
            s3: next_state = in ? s0: s1;
            s4: next_state = in ? s0 : s4;
            default next_state = 2'd0;
        endcase
    end
    
    //State Logic
    always@(posedge clk) begin
        if(reset) begin
            state <= s0;
        	count <= 4'd0;
        end
        else if(state == s2) begin
            count <= count + 4'd1;
            state <= next_state;
        end
        else begin
            count <= 4'd0;
            state <= next_state;
        end
    end
    
    //Output logic
    assign done = (state == s3) ? 1'b1 : 1'b0;

endmodule
