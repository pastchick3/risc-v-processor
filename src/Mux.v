module Mux (
    input select,
    input [7:0] in_1,
    input [7:0] in_2,
    output [7:0] out
);
    // When `select` is 0, `in_1` is outputted, otherwise
    // `in_2` is outputted.
    assign out = (~{8{select}} & in_1) | ({8{select}} & in_2);
endmodule
