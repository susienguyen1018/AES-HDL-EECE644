//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: aes_tb_NIST_ExampleKey
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module aes_tb;

    logic clk = 0;
    logic reset = 1;
    logic start = 0;

    logic [127:0] plaintext;
    logic [127:0] key;
    logic [127:0] ciphertext;
    logic done;

    aes128_top DUT (
        .clk(clk),
        .reset(reset),
        .start(start),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );

    always #5 clk = ~clk;

    initial begin
        plaintext = 128'h00112233445566778899aabbccddeeff;
        key       = 128'h000102030405060708090a0b0c0d0e0f;

        repeat (4) @(posedge clk);
        reset = 0;

        wait (DUT.CORE.key_ready);

        @(posedge clk);
        start = 1;
        @(posedge clk);
        start = 0;

        wait (done);
        @(posedge clk);   // allow ciphertext to latch
        @(posedge clk);  

        $display("==============================================");
        $display("PLAINTEXT  = %032h", plaintext);
        $display("KEY        = %032h", key);
        $display("CIPHERTEXT = %032h", ciphertext);
        $display("EXPECTED   = 69c4e0d86a7b0430d8cdb78070b4c55a");
        $display("==============================================");

        if (ciphertext !== 128'h69c4e0d86a7b0430d8cdb78070b4c55a)
            $error("AES FAILED");
        else
            $display("AES PASSED");

        $finish;
    end
endmodule
