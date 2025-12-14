//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: aes_tb
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

    // Dataset memories
    logic [127:0] pt_mem  [0:1023];
    logic [127:0] ct_mem  [0:1023];

    integer i;

    aes128_top DUT (
        .clk(clk),
        .reset(reset),
        .start(start),
        .plaintext(plaintext),
        .key(key),
        .ciphertext(ciphertext),
        .done(done)
    );

    // 10 time-unit clock
    always #5 clk = ~clk;

    initial begin
        // ---------------- Load dataset ----------------
        $readmemh("plaintext_risk.hex",  pt_mem);
        $readmemh("ciphertext_ref.hex", ct_mem);

        // ---------------- AES key ----------------
        key = 128'h00112233445566778899aabbccddeeff;

        // ---------------- Reset ----------------
        repeat (4) @(posedge clk);
        reset = 0;

        // Wait for key expansion
        wait (DUT.CORE.key_ready);

        // ---------------- Test all vectors ----------------
        for (i = 0; i < 1024; i++) begin
            plaintext = pt_mem[i];

            // Start AES
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;

            // Wait for completion
            wait (done);
            @(posedge clk);
            @(posedge clk);  // allow ciphertext to settle

            // Compare result
            if (ciphertext !== ct_mem[i]) begin
                $error("=================================");
                $error("AES MISMATCH AT VECTOR %0d", i);
                $error("PLAINTEXT  = %032h", plaintext);
                $error("EXPECTED   = %032h", ct_mem[i]);
                $error("GOT        = %032h", ciphertext);
                $error("=================================");
                $finish;
            end
            else begin
                $display("Vector %0d PASSED", i);
            end
        end

        $display("=================================");
        $display("ALL DATASET VECTORS PASSED");
        $display("=================================");
        $finish;
    end
endmodule
