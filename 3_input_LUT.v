module top_module (
    input clk,
    input enable,
    input S,
    input A, B, C,
    output Z );
    
    reg [7:0] Q;
    
    shift_reg S1(S, clk, enable, Q);
    always@(*) begin
        case({A,B,C})
            3'b000: Z = Q[0];
            3'b001: Z = Q[1];
            3'b010: Z = Q[2];
            3'b011: Z = Q[3];
            3'b100: Z = Q[4];
            3'b101: Z = Q[5];
            3'b110: Z = Q[6];
            3'b111: Z = Q[7];
            default:
                Z = 1'b0;
        endcase
    end

endmodule

module shift_reg(input in, clk, enable,
                 output [7:0]Q);
    reg [7:0]Q_next;
    
    always@(posedge clk) begin
        if(enable) begin
            Q <= {Q[6:0],in};
        end
        else
            Q <= Q_next;
    end
    
    always@(*) begin
        Q_next = Q;
    end
endmodule
