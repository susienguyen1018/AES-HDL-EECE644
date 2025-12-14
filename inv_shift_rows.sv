//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: inv_shift_rows
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module inv_shift_rows(
    input  logic [127:0] state_in,
    output logic [127:0] state_out
);

    function automatic logic [7:0] get(int r, int c);
        return state_in[(c*32)+(r*8) +: 8];
    endfunction

    function automatic void put(int r, int c, logic [7:0] v);
        state_out[(c*32)+(r*8) +: 8] = v;
    endfunction

    always_comb begin
        for (int r = 0; r < 4; r++)
            for (int c = 0; c < 4; c++)
                put(r, c, get(r, (c - r + 4) % 4));  // RIGHT SHIFT
    end

endmodule
