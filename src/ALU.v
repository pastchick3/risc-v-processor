module ALU (
    input [1:0] ctrl,
    input [7:0] in_1,
    input [7:0] in_2,
    output reg [7:0] out,
    output zero
);
    assign zero = (out == 0);
    
    always @(ctrl, in_1, in_2) begin
        case (ctrl)
            0: out = in_1 & in_2;
            1: out = in_1 | in_2;
            2: out = in_1 + in_2;
            3: out = in_1 - in_2;
            default: out = 0;
        endcase
    end
endmodule
