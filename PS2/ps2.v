module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

    reg[1:0] state, next_state;
    reg [23:0] out_b;
    parameter s0 = 2'b00, s1 = 2'b01, s2 = 2'b10, s3 = 2'b11;
    
    // State transition logic (combinational)
    always@(*) begin
        case(state)
            s0: next_state = in[3] ? s1 : s0;
            s1: next_state = s2; 
            s2: next_state = s3;
            s3: next_state = in[3] ? s1: s0;
            default next_state = s0;
        endcase
    end
    
    //Datapath for bytes
    always@(posedge clk) begin
        if(state == s0)
            out_b[23:16] <= in;
        else if(state == s1)
            out_b[15:8] <= in;
        else if(state == s2)
            out_b[7:0] <= in;
        else if(state == s3 && !in[3])
            out_b <= out_b;
        else
            out_b[23:16] <= in;
            
    end
    
    
    // State flip-flops (sequential)
    always@(posedge clk) begin
        if(reset)
            state <= s0;
        else 
            state <= next_state;
    end
    // Output logic
    
    assign done = (state == s3)? 1'b1 : 1'b0;
    
    assign out_bytes = done ? out_b : 24'd0;

endmodule
