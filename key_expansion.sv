//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: key_expansion
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module key_expansion (
    input  logic        clk,
    input  logic        reset,
    input  logic [127:0] key,
    output logic [1407:0] round_keys,
    output logic        key_ready
);

    import aes_pkg::*;

    logic [31:0] w [0:43];
    logic [31:0] temp;

    logic key_ready_int;   // internal, used to delay key_ready

    localparam logic [31:0] RCON [0:9] = '{
        32'h01000000, 32'h02000000, 32'h04000000, 32'h08000000,
        32'h10000000, 32'h20000000, 32'h40000000, 32'h80000000,
        32'h1B000000, 32'h36000000
    };

    function automatic logic [31:0] rot_word(input logic [31:0] x);
        rot_word = {x[23:0], x[31:24]};
    endfunction

    function automatic logic [31:0] sub_word(input logic [31:0] x);
        sub_word = {
            SBOX[x[31:24]],
            SBOX[x[23:16]],
            SBOX[x[15:8]],
            SBOX[x[7:0]]
        };
    endfunction

    integer i, r;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            round_keys    <= '0;
            key_ready_int <= 1'b0;
            key_ready     <= 1'b0;
        end else begin
		  
            // Load initial key
            w[0] = key[127:96];
            w[1] = key[95:64];
            w[2] = key[63:32];
            w[3] = key[31:0];

            // Key expansion
            for (i = 4; i < 44; i++) begin
                temp = w[i-1];
                if (i % 4 == 0)
                    temp = sub_word(rot_word(temp)) ^ RCON[(i/4)-1];
                w[i] = w[i-4] ^ temp;
            end

            // Pack round keys (11 × 128 bits)
            for (r = 0; r < 11; r++) begin
                round_keys[(1407 - r*128) -: 128] =
                    { w[r*4], w[r*4+1], w[r*4+2], w[r*4+3] };
            end

            // Valid Flag (delayed by 1 cycle)
            key_ready_int <= 1'b1;
            key_ready     <= key_ready_int;
        end
    end

endmodule
