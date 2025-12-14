//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: mix_columns
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module mix_columns(
    input  logic [127:0] state_in,
    output logic [127:0] state_out
);

    // xtime: multiply by 2 in GF(2^8)
    function automatic logic [7:0] xtime(input logic [7:0] x);
        logic [7:0] shifted;
        begin
            shifted = (x << 1) & 8'hFF;
            if (x[7])
                xtime = shifted ^ 8'h1B;
            else
                xtime = shifted;
        end
    endfunction
	 
    // multiply by 3
    function automatic logic [7:0] mul3(input logic [7:0] x);
        begin
            mul3 = xtime(x) ^ x;
        end
    endfunction

    logic [7:0] col [0:3][0:3];
    logic [7:0] outc[0:3][0:3];

    always_comb begin
        // Unpack (AES COlumn-Major, MSB-first)
        for (int c = 0; c < 4; c = c + 1)
            for (int r = 0; r < 4; r = r + 1)
                col[r][c] = state_in[127 - (c*32 + r*8) -: 8];

		  // MixColumns
        for (int c = 0; c < 4; c = c + 1) begin
            outc[0][c] = xtime(col[0][c]) ^ mul3(col[1][c]) ^ col[2][c] ^ col[3][c];
            outc[1][c] = col[0][c] ^ xtime(col[1][c]) ^ mul3(col[2][c]) ^ col[3][c];
            outc[2][c] = col[0][c] ^ col[1][c] ^ xtime(col[2][c]) ^ mul3(col[3][c]);
            outc[3][c] = mul3(col[0][c]) ^ col[1][c] ^ col[2][c] ^ xtime(col[3][c]);
        end

        // Pack back
        for (int c = 0; c < 4; c = c + 1)
            for (int r = 0; r < 4; r = r + 1)
                state_out[127 - (c*32 + r*8) -: 8] = outc[r][c];
    end

endmodule
