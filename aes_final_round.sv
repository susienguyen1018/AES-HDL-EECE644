//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: aes_final_round
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module aes_final_round(
    input  logic [127:0] state_in,
    input  logic [127:0] round_key,
    output logic [127:0] state_out
);
    logic [127:0] sb, sr;

    sub_bytes u1 (.state_in(state_in), .state_out(sb));
    shift_rows u2 (.state_in(sb),      .state_out(sr));
    add_round_key u3 (.state_in(sr), .round_key(round_key), .state_out(state_out));
endmodule
