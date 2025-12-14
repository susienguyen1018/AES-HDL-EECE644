//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: inv_sub_bytes
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module inv_sub_bytes (
    input  logic [127:0] state_in,
    output logic [127:0] state_out
);

    import aes_pkg::*;

    always_comb begin
        for (int i = 0; i < 16; i++)
            state_out[i*8 +: 8] = INV_SBOX[state_in[i*8 +: 8]];
    end

endmodule
