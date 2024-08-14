module top_module(
    input clk,
    input reset,    // Synchronous reset
    input in,
    output disc,
    output flag,
    output err);
    
    reg [3:0] state, next_state;
    
    parameter [3:0] s0 = 0, s1= 1, s2 = 2, s3 = 3, s4 = 4, s5 = 5, s6 = 6, discard = 7, flag_s = 8, error = 9;
    
    //State Logic
    always@(*) begin
        case(state)
            s0: next_state = in ? s1 : s0;
            s1: next_state = in ? s2 : s0;
            s2: next_state = in ? s3 : s0;
            s3: next_state = in ? s4 : s0;
            s4: next_state = in ? s5 : s0;
            s5: next_state = in ? s6 : discard;
            s6: next_state = in ? error : flag_s;
            discard: next_state = s1;
            flag_s: next_state = s1;
            error: next_state = in ? error : s0;
            default next_state = s0;
        endcase
    end
    
    
    //Sequential logic
    always@(posedge clk) begin
        if(reset)
            state <= s0;
        else
            state <= next_state;
    end
    
    //Output Logic
    assign disc = (state == discard) ? 1'b1:1'b0;
    assign flag = (state == flag_s)? 1'b1:1'b0;
    assign err = (state == error)? 1'b1:1'b0;

endmodule
