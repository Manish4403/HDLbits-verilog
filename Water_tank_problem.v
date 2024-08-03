module top_module (
    input clk,
    input reset,
    input [3:1] s,
    output reg fr3,
    output reg fr2,
    output reg fr1,
    output reg dfr
); 
    
    
    // One-hot encoding is used.
    reg [5:0]below_s1 = 6'b000001, s1tos2 = 6'b000010, s2tos3 = 6'b000100, above_s3 = 6'b001000,
    		s3tos2 = 6'b010000, s2tos1 = 6'b100000;
    reg[5:0] state , next_state;
    //state logic
    always@(*) begin
        case(state)
            below_s1: next_state = s[1] ? s1tos2 : below_s1;
            s1tos2: next_state = s[1] ? (s[2] ? s2tos3 : s1tos2) : below_s1;
            s2tos3: next_state = (&s[2:1]) ? (s[3] ? above_s3 : s2tos3) : s2tos1;
            above_s3: next_state = (&s) ? above_s3 : s3tos2;
            s3tos2 : next_state = (&s[2:1]) ? (s[3] ? above_s3 : s3tos2) : s2tos1;
            s2tos1 : next_state = s[1] ? (s[2] ? s2tos3 : s2tos1) : below_s1;
                
            default: next_state = below_s1;
        endcase
    end
    // fsm
    always@(posedge clk) begin
        if(reset)
            state <= below_s1;
        else
            state <= next_state;
            
    end
    
    //Output logic
    always@(*) begin
        case(state)
            below_s1: {fr3, fr2, fr1, dfr} = 4'b1111;
            s1tos2: {fr3, fr2, fr1, dfr} = 4'b0110;
            s2tos3: {fr3, fr2, fr1, dfr} = 4'b0010;
            above_s3: {fr3, fr2, fr1, dfr} = 4'b0000;
            s3tos2: {fr3, fr2, fr1, dfr} = 4'b0011;
            s2tos1: {fr3, fr2, fr1, dfr} = 4'b0111;
            default: {fr3, fr2, fr1, dfr} = 4'b1111;
        endcase
    end

endmodule
