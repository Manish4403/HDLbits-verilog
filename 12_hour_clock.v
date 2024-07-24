module top_module(
    input clk,
    input reset,
    input ena,
    output  reg pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss);
    
    //seconds
    wire ena_sec1;
    wire [3:0]q_s0, q_s1;
    
    //Minute
    wire ena_m0, ena_m1;
    wire [3:0]q_m0, q_m1;
    
    //Hours
    wire ena_h0;
    wire [7:0]q_h0;
    
    //variable pm
    
    /////////////////////////////////
    
    //seconds
    assign ena_sec1 = (q_s0 == 4'h9 && ena == 1'b1);
    
    mod_10 s0(clk, reset, ena, q_s0);
    mod_6 s1(clk, reset, ena_sec1, q_s1);
    
    //minutes
    assign ena_m0 = (q_s0 == 4'h9 && q_s1 == 4'h5);
    assign ena_m1 = (q_m0 == 4'h9 && q_s0 == 4'h9 && q_s1 == 4'h5);
    
    mod_10 m0(clk, reset, ena_m0, q_m0);
    mod_6 m1(clk, reset, ena_m1, q_m1);
    
    //hours
    assign ena_h0 = (q_s0 == 4'h9 && q_s1 == 4'h5) && (q_m0 == 4'h9 && q_m1 == 4'h5);
    
    mod_12 h0(clk, reset, ena_h0, q_h0);
    
    ////////////////////////////////
    
    
    // Designing PM
    always@(posedge clk) begin
        if(reset)
            pm <= 1'b0;
        else if(hh == 8'h11 && mm == 8'h59 && ss == 8'h59)
            pm <= ~pm;
    end
    
    
    //assigning output
    assign hh = q_h0;
    assign mm = {q_m1, q_m0};
    assign ss = {q_s1, q_s0};
    
    
endmodule

module mod_10(clk, reset, enable, q);
    input clk, reset, enable;
    output [3:0] q;
    reg [3:0] q_next;
    
    always@(posedge clk) begin
        if(reset)
            q <= 4'h0;
        else if(enable) begin
            if(q == 4'h9)
                q <= 4'h0;
            else
                q <= q + 1'h1;
        end
        
        else
            q <= q_next;
    end
    
    always@(*) begin
        q_next = q;
    end
    
endmodule

module mod_6(clk, reset, enable, q);
    input clk, reset, enable;
    output [3:0] q;
    reg [3:0] q_next;
    
    always@(posedge clk) begin
        if(reset)
            q <= 4'h0;
        else if(enable) begin
            if(q == 4'h5)
            	q <= 4'd0;
        	else
                q <= q + 1'h1;
        end
        else
            q <= q_next;
    end
    
    always@(*) begin
        q_next = q;
    end
    
endmodule

module mod_12(clk, reset, enable, q); //count 0 to 9
    input clk, reset, enable;
    output [7:0] q;
    reg [7:0] q_next;
    
    always@(posedge clk) begin
        if(reset)
            q <= {4'h1, 4'h2};
        else if(enable) begin
            if(q == 8'h12)
                q <= 8'h1;
            else if(q[3:0] < 8'h9)
                q[3:0] <= q[3:0] + 4'h1; 
            else begin
                q[3:0] <= 4'h0;
                q[7:4] <= 4'h1;
            end
        end
        
        else
            q <= q_next;
    end
    
    always@(*) begin
        q_next = q;
    end
    
endmodule

