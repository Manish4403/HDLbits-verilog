module top_module (
    input [6:1] y,
    input w,
    output Y2,
    output Y4);
    
    wire [6:1] next;
    
    assign next[1] = w && y[1] || w && y[4];
    assign next[2] = !w && y[1];
    assign next[3] = !w && y[2] || !w && y[6];
    assign next[4] = w && y[2] || w && y[3] || w && y[5] || w && y[6];
    assign next[5] = !w && y[3] || !w && y[5];
    assign next[6] = !w && y[4];
    
    assign Y2 = next[2];
    assign Y4 = next[4];
    

endmodule
