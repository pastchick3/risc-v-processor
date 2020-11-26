module Mux3 (
    input [1:0] select,
    input [7:0] in_1,
    input [7:0] in_2,
    input [7:0] in_3,
    output reg [7:0] out
);
    always @(*) begin
        case (select)
            2'b00: out = in_1;
            2'b01: out = in_2;
            2'b10: out = in_3;
            2'b11: out = in_1;
        endcase
    end
endmodule
