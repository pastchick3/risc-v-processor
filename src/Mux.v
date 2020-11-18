module Mux (
    input select,
    input [7:0] in_1,
    input [7:0] in_2,
    output [7:0] out
);
    assign out = (~{8{select}} & in_1) | ({8{select}} & in_2);
endmodule
