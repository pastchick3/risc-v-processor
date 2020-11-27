module Mux2 (
    input select,
    input [7:0] in_1,
    input [7:0] in_2,
    output reg [7:0] out
);
    always @(*) begin
        case (select)
            0: out = in_1;
            1: out = in_2;
        endcase
    end
endmodule
