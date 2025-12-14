//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: aes128_top
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module aes128_top (
    input  logic        clk,
    input  logic        reset,
    input  logic        start,
    input  logic [127:0] plaintext,
    input  logic [127:0] key,
    output logic [127:0] ciphertext,
    output logic        done
);

    aes_core CORE (
        .clk(clk),
        .reset(reset),
        .start(start),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );

endmodule
