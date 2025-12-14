//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: aes_round
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module aes_round(
    input  logic [127:0] state_in,
    input  logic [127:0] round_key,
    output logic [127:0] state_out
);
    logic [127:0] sb, sr, mc;

    sub_bytes u1 (.state_in(state_in), .state_out(sb));
    shift_rows u2 (.state_in(sb),      .state_out(sr));
    mix_columns u3 (.state_in(sr),     .state_out(mc));
    add_round_key u4 (.state_in(mc), .round_key(round_key), .state_out(state_out));
endmodule
