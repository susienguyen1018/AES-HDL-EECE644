//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: sub_bytes
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module sub_bytes(
    input  logic [127:0] state_in,
    output logic [127:0] state_out
);

    import aes_pkg::*;

    logic [7:0] s[0:3][0:3];   // [row][col]
    logic [7:0] sb[0:3][0:3];

    always_comb begin
	 
		  // Unpack Column-Major = Matrix
        for (int c = 0; c < 4; c++)
            for (int r = 0; r < 4; r++)
                s[r][c] = state_in[(c*32)+(r*8) +: 8];

		  // Apply SBOX
        for (int c = 0; c < 4; c++)
            for (int r = 0; r < 4; r++)
                sb[r][c] = SBOX[s[r][c]];

		  // Pack back Column-Major
        for (int c = 0; c < 4; c++)
            for (int r = 0; r < 4; r++)
                state_out[(c*32)+(r*8) +: 8] = sb[r][c];

    end
endmodule
