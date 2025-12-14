//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: shift_rows
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module shift_rows (
    input  logic [127:0] state_in,
    output logic [127:0] state_out
);

    logic [7:0] s[0:3][0:3];

    always_comb begin
		  // Unpack (AES Column-Major, MSB-first
        for (int c = 0; c < 4; c++)
            for (int r = 0; r < 4; r++)
                s[r][c] = state_in[127 - (c*32 + r*8) -: 8];

        // Shift Rows
        // Row 0: no shift
        for (int c = 0; c < 4; c++)
            state_out[127 - (c*32 + 0*8) -: 8] = s[0][c];

        // Row 1: shift left by 1
        for (int c = 0; c < 4; c++)
            state_out[127 - (c*32 + 1*8) -: 8] = s[1][(c+1)%4];

        // Row 2: shift left by 2
        for (int c = 0; c < 4; c++)
            state_out[127 - (c*32 + 2*8) -: 8] = s[2][(c+2)%4];

        // Row 3: shift left by 3
        for (int c = 0; c < 4; c++)
            state_out[127 - (c*32 + 3*8) -: 8] = s[3][(c+3)%4];
    end
endmodule
