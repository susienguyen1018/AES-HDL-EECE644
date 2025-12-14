//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: add_round_key
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module add_round_key(
    input  logic [127:0] state_in,
    input  logic [127:0] round_key,
    output logic [127:0] state_out
);
    assign state_out = state_in ^ round_key;
endmodule
