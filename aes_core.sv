//////////////////////////////////////////////////////////////////////////////////
// Company: CSU Chico
// Engineer: Sam Carter & Susie Nguyen

// Module Name: aes_core
// Project Name: EECE644_Final_Project
//////////////////////////////////////////////////////////////////////////////////

module aes_core (
    input  logic         clk,
    input  logic         reset,
    input  logic         start,
    input  logic [127:0] plaintext,
    input  logic [127:0] key,
    output logic [127:0] ciphertext,
    output logic         done
);

    // Internal
    logic [1407:0] round_keys;
    logic          key_ready;

    logic [127:0] state_reg;
    logic [4:0]   round;
    logic         start_pending;

    logic [127:0] round_out;
    logic [127:0] final_out;

    logic [127:0] rnd_key_safe;
    logic [127:0] state_for_round;
    logic [127:0] final_key_safe;
    logic [127:0] state_for_final;

    // Key Expansion
    key_expansion KE (
        .clk(clk),
        .reset(reset),
        .key(key),
        .round_keys(round_keys),
        .key_ready(key_ready)
    );

    function automatic logic [127:0] get_round_key(input int r);
        get_round_key = round_keys[(1407 - 128*r) -: 128];
    endfunction

    // Guards
    always_comb begin
        // defaults
        rnd_key_safe    = 128'h0;
        state_for_round = 128'h0;
        final_key_safe  = 128'h0;
        state_for_final = 128'h0;

        // rounds 1–9
        if (round >= 1 && round <= 9) begin
            rnd_key_safe    = get_round_key(round);
            state_for_round = state_reg;
        end

        // final round ONLY
        if (round == 10) begin
            final_key_safe  = get_round_key(10);
            state_for_final = state_reg;
        end
    end

    // Datapath
    aes_round RND (
        .state_in(state_for_round),
        .round_key(rnd_key_safe),
        .state_out(round_out)
    );

    aes_final_round FRND (
        .state_in(state_for_final),
        .round_key(final_key_safe),
        .state_out(final_out)
    );

    // FSM
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            round         <= 0;
            state_reg     <= 0;
            ciphertext    <= 0;
            done          <= 0;
            start_pending <= 0;
        end else begin

            if (start)
                start_pending <= 1'b1;

            case (round)

                // Idle / Round 0
                5'd0: begin
                    done <= 1'b0;
                    if (start_pending && key_ready) begin
                        state_reg <= plaintext ^ get_round_key(0);
                        round <= 5'd1;
                        start_pending <= 1'b0;
                    end
                end

                // Rounds 1–9
                5'd1,5'd2,5'd3,5'd4,5'd5,
                5'd6,5'd7,5'd8,5'd9: begin
                    state_reg <= round_out;
                    round <= round + 5'd1;
                end

                // Final Round
                5'd10: begin
                    state_reg <= final_out;
                    round <= 5'd11;
                end

                // Done (HOLD)
                5'd11: begin
                    ciphertext <= state_reg;
                    done <= 1'b1;
                    round <= 5'd12;
                end

                // Return to Idle
                5'd12: begin
                    round <= 5'd0;
                end

            endcase
        end
    end
endmodule
