module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input x,
    input y,
    output f,
    output g
); 
    
    reg[3:0] state, next;
    parameter [3:0] s0 = 0, s1 = 1, s2 = 2, s3 = 3, s4 = 4, s5 = 5, s6 = 6, s7 = 7, s8 = 8, s9 = 9;

    
    //State Logic
    always@(*) begin
        case(state)
            s0: next = !resetn ? s0 : s1;
            s1: next = s2;    // f == 1
            s2: next = x ? s3 : s2;  
            s3: next = x ? s3 : s4;
            s4: next = x ? s5 : s2;
            s5: next = y ? s6 : s7; // g == 1
            s6: next = s6; //g == 1
            s7: next = y ? s8 : s9; //g == 1
            s8: next = s8;  // g == 1
            s9: next = s9; // g== 0
            default next = s0;
        endcase
    end
                
   //counter logic
//   always
    
    
    //Sequential logic
    always@(posedge clk) begin
        if(!resetn) begin
            state <= s0;
        end
        else begin
            //count <= 1'b0;
            state <= next;
        end
    end
    
    //Output logic
    assign f = (state == s1);
    assign g = (state == s6 || state == s8 || state == s7 || state == s5);

endmodule
