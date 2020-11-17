module ALU (
    input clk,
    input ctrl,
    input [63:0] in_1,
    input [63:0] in_2,
    output reg [63:0] out
);
    assign zero = (out == 0);
    
    // always @(control, in_1, in_2) begin
    //     case (control)
    //         0: out <= in_1 & in_2;
    //         1: out <= in_1 | in_2;
    //         2: out <= in_1 + in_2;
    //         6: out <= in_1 - in_2;
    //         7: out <= in_1 < in_2 ? 1 : 0;
    //         12: out <= ~(in_1 | in_2);
    //         default: out <= 0;
    //     endcase
    // end

    always @(posedge clk) begin
        case (ctrl)
            0: out <= 1+1;//in_1 + in_2;
            1: out <= 2-1;//in_1 - in_2;
            default: out <= 0;
        endcase
    end
endmodule
