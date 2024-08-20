module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input [3:1] r,   // request
    output [3:1] g   // grant
); 
    reg [1:0] state, next;
    parameter [1:0] s0=0, s1=1, s2=2, s3=3;
    
    
    always@(*) begin
        case(state)
            s0 : begin 
                    if(!r) begin
                        next = s0;
                    end
                    else if(r[1])
                        next = s1;
                	else if(r[2] && !r[1])
                        next = s2;
                	else if(r[3] && !r[1] && !r[2])
                        next = s3;
                	else 
                        next = s0;
            	end
            s1: next = r[1] ? s1 : s0;
            s2: next = r[2] ? s2 : s0;
            s3: next = r[3] ? s3 : s0;
            
            default next = s0;
        endcase
    end
    
    always@(posedge clk) begin
        if(!resetn)
            state <= s0;
        else
            state <= next;
    end
    
    assign g = {state == s3, state == s2, state == s1};

endmodule
