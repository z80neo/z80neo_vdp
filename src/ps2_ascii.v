// ============================================================================
// ps2_ascii - scan code set 2 -> CP437 ASCII (EN / ES(Spain) layouts)
//
// Tracks the shift keys (12/59) and maps make codes to ASCII.  `layout_es`
// selects Spanish (Spain) instead of US English.  `enter_mode` selects what the
// Enter key sends: 0 = CR, 1 = LF, 2 = CR+LF (two console bytes).
//
// Caps Lock (58) toggles a sticky SHIFT so keyboards that do not report the
// shift keys can still type shifted symbols like ':'.
// ============================================================================
module ps2_ascii (
    input        clk,
    input        rst_n,
    input        layout_es,         // 0 = US English, 1 = Spanish (Spain)
    input  [1:0] enter_mode,        // 0 = CR, 1 = LF, 2 = CR+LF
    input  [7:0] scancode,
    input        sc_valid,
    input        sc_break,
    input        sc_ext,
    output reg [7:0] ascii_data,
    output reg       ascii_valid,
    output reg       shift,         // physical shift state (debug / LED0)
    output reg       shift_lock     // sticky shift latch   (debug / LED1)
);
    wire eff_shift = shift | shift_lock;

    reg [7:0] c_en;
    always @(*) begin
        case (scancode)
        8'h0E: c_en = eff_shift ? 8'h7E : 8'h60;
        8'h16: c_en = eff_shift ? 8'h21 : 8'h31;
        8'h1E: c_en = eff_shift ? 8'h40 : 8'h32;
        8'h26: c_en = eff_shift ? 8'h23 : 8'h33;
        8'h25: c_en = eff_shift ? 8'h24 : 8'h34;
        8'h2E: c_en = eff_shift ? 8'h25 : 8'h35;
        8'h36: c_en = eff_shift ? 8'h5E : 8'h36;
        8'h3D: c_en = eff_shift ? 8'h26 : 8'h37;
        8'h3E: c_en = eff_shift ? 8'h2A : 8'h38;
        8'h46: c_en = eff_shift ? 8'h28 : 8'h39;
        8'h45: c_en = eff_shift ? 8'h29 : 8'h30;
        8'h4E: c_en = eff_shift ? 8'h5F : 8'h2D;
        8'h55: c_en = eff_shift ? 8'h2B : 8'h3D;
        8'h15: c_en = eff_shift ? 8'h51 : 8'h71;
        8'h1D: c_en = eff_shift ? 8'h57 : 8'h77;
        8'h24: c_en = eff_shift ? 8'h45 : 8'h65;
        8'h2D: c_en = eff_shift ? 8'h52 : 8'h72;
        8'h2C: c_en = eff_shift ? 8'h54 : 8'h74;
        8'h35: c_en = eff_shift ? 8'h59 : 8'h79;
        8'h3C: c_en = eff_shift ? 8'h55 : 8'h75;
        8'h43: c_en = eff_shift ? 8'h49 : 8'h69;
        8'h44: c_en = eff_shift ? 8'h4F : 8'h6F;
        8'h4D: c_en = eff_shift ? 8'h50 : 8'h70;
        8'h54: c_en = eff_shift ? 8'h7B : 8'h5B;
        8'h5B: c_en = eff_shift ? 8'h7D : 8'h5D;
        8'h1C: c_en = eff_shift ? 8'h41 : 8'h61;
        8'h1B: c_en = eff_shift ? 8'h53 : 8'h73;
        8'h23: c_en = eff_shift ? 8'h44 : 8'h64;
        8'h2B: c_en = eff_shift ? 8'h46 : 8'h66;
        8'h34: c_en = eff_shift ? 8'h47 : 8'h67;
        8'h33: c_en = eff_shift ? 8'h48 : 8'h68;
        8'h3B: c_en = eff_shift ? 8'h4A : 8'h6A;
        8'h42: c_en = eff_shift ? 8'h4B : 8'h6B;
        8'h4B: c_en = eff_shift ? 8'h4C : 8'h6C;
        8'h4C: c_en = eff_shift ? 8'h3A : 8'h3B;
        8'h52: c_en = eff_shift ? 8'h22 : 8'h27;
        8'h5D: c_en = eff_shift ? 8'h7C : 8'h5C;
        8'h1A: c_en = eff_shift ? 8'h5A : 8'h7A;
        8'h22: c_en = eff_shift ? 8'h58 : 8'h78;
        8'h21: c_en = eff_shift ? 8'h43 : 8'h63;
        8'h2A: c_en = eff_shift ? 8'h56 : 8'h76;
        8'h32: c_en = eff_shift ? 8'h42 : 8'h62;
        8'h31: c_en = eff_shift ? 8'h4E : 8'h6E;
        8'h3A: c_en = eff_shift ? 8'h4D : 8'h6D;
        8'h41: c_en = eff_shift ? 8'h3C : 8'h2C;
        8'h49: c_en = eff_shift ? 8'h3E : 8'h2E;
        8'h4A: c_en = eff_shift ? 8'h3F : 8'h2F;
        8'h29: c_en = 8'h20;
        8'h0D: c_en = 8'h09;
        8'h66: c_en = 8'h08;
        8'h76: c_en = 8'h1B;
        default: c_en = 8'h00;
        endcase
    end

    reg [7:0] c_es;
    always @(*) begin
        case (scancode)
        8'h0E: c_es = eff_shift ? 8'hA6 : 8'hA7;
        8'h16: c_es = eff_shift ? 8'h21 : 8'h31;
        8'h1E: c_es = eff_shift ? 8'h22 : 8'h32;
        8'h26: c_es = eff_shift ? 8'hFA : 8'h33;
        8'h25: c_es = eff_shift ? 8'h24 : 8'h34;
        8'h2E: c_es = eff_shift ? 8'h25 : 8'h35;
        8'h36: c_es = eff_shift ? 8'h26 : 8'h36;
        8'h3D: c_es = eff_shift ? 8'h2F : 8'h37;
        8'h3E: c_es = eff_shift ? 8'h28 : 8'h38;
        8'h46: c_es = eff_shift ? 8'h29 : 8'h39;
        8'h45: c_es = eff_shift ? 8'h3D : 8'h30;
        8'h4E: c_es = eff_shift ? 8'h3F : 8'h27;
        8'h55: c_es = eff_shift ? 8'hA8 : 8'hAD;
        8'h15: c_es = eff_shift ? 8'h51 : 8'h71;
        8'h1D: c_es = eff_shift ? 8'h57 : 8'h77;
        8'h24: c_es = eff_shift ? 8'h45 : 8'h65;
        8'h2D: c_es = eff_shift ? 8'h52 : 8'h72;
        8'h2C: c_es = eff_shift ? 8'h54 : 8'h74;
        8'h35: c_es = eff_shift ? 8'h59 : 8'h79;
        8'h3C: c_es = eff_shift ? 8'h55 : 8'h75;
        8'h43: c_es = eff_shift ? 8'h49 : 8'h69;
        8'h44: c_es = eff_shift ? 8'h4F : 8'h6F;
        8'h4D: c_es = eff_shift ? 8'h50 : 8'h70;
        8'h54: c_es = eff_shift ? 8'h5E : 8'h60;
        8'h5B: c_es = eff_shift ? 8'h2A : 8'h2B;
        8'h1C: c_es = eff_shift ? 8'h41 : 8'h61;
        8'h1B: c_es = eff_shift ? 8'h53 : 8'h73;
        8'h23: c_es = eff_shift ? 8'h44 : 8'h64;
        8'h2B: c_es = eff_shift ? 8'h46 : 8'h66;
        8'h34: c_es = eff_shift ? 8'h47 : 8'h67;
        8'h33: c_es = eff_shift ? 8'h48 : 8'h68;
        8'h3B: c_es = eff_shift ? 8'h4A : 8'h6A;
        8'h42: c_es = eff_shift ? 8'h4B : 8'h6B;
        8'h4B: c_es = eff_shift ? 8'h4C : 8'h6C;
        8'h4C: c_es = eff_shift ? 8'hA5 : 8'hA4;
        8'h52: c_es = eff_shift ? 8'h22 : 8'h27;
        8'h5D: c_es = eff_shift ? 8'h80 : 8'h87;
        8'h56: c_es = eff_shift ? 8'h3E : 8'h3C;
        8'h1A: c_es = eff_shift ? 8'h5A : 8'h7A;
        8'h22: c_es = eff_shift ? 8'h58 : 8'h78;
        8'h21: c_es = eff_shift ? 8'h43 : 8'h63;
        8'h2A: c_es = eff_shift ? 8'h56 : 8'h76;
        8'h32: c_es = eff_shift ? 8'h42 : 8'h62;
        8'h31: c_es = eff_shift ? 8'h4E : 8'h6E;
        8'h3A: c_es = eff_shift ? 8'h4D : 8'h6D;
        8'h41: c_es = eff_shift ? 8'h3B : 8'h2C;
        8'h49: c_es = eff_shift ? 8'h3A : 8'h2E;
        8'h4A: c_es = eff_shift ? 8'h5F : 8'h2D;
        8'h29: c_es = 8'h20;
        8'h0D: c_es = 8'h09;
        8'h66: c_es = 8'h08;
        8'h76: c_es = 8'h1B;
        default: c_es = 8'h00;
        endcase
    end

    wire [7:0] c = layout_es ? c_es : c_en;

    reg       pend_valid;
    reg [7:0] pend_byte;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift <= 1'b0; shift_lock <= 1'b0;
            ascii_data <= 8'd0; ascii_valid <= 1'b0;
            pend_valid <= 1'b0; pend_byte <= 8'd0;
        end else begin
            ascii_valid <= 1'b0;
            if (pend_valid) begin
                ascii_data  <= pend_byte;      // second byte of CR+LF
                ascii_valid <= 1'b1;
                pend_valid  <= 1'b0;
            end else if (sc_valid) begin
                if (scancode == 8'h12 || scancode == 8'h59)
                    shift <= ~sc_break;
                else if (scancode == 8'h58 && !sc_break)
                    shift_lock <= ~shift_lock;
                else if (sc_break || sc_ext)
                    ;
                else if (scancode == 8'h5A) begin
                    if (enter_mode == 2'd2) begin
                        ascii_data <= 8'h0D; ascii_valid <= 1'b1;
                        pend_byte  <= 8'h0A; pend_valid  <= 1'b1;
                    end else if (enter_mode == 2'd1) begin
                        ascii_data <= 8'h0A; ascii_valid <= 1'b1;
                    end else begin
                        ascii_data <= 8'h0D; ascii_valid <= 1'b1;
                    end
                end else if (c != 8'h00) begin
                    ascii_data  <= c;
                    ascii_valid <= 1'b1;
                end
            end
        end
    end
endmodule
