// ============================================================================
// GFX Buffer - 3 bitplane bitmap layer for the ESC g graphics protocol
//
// 640x256 = 163840 pixels, one bit per plane.  Three planes give an 8-colour
// (3bpp) palette index per pixel; the index selects a palette entry in the
// renderer (see text_controller.v). Stored as one packed 3-bit memory so all
// colour bits share the same dual-port RAM read/write path.
//
// Port A: read  (pix_clk domain, text_controller),  3 bits out
// Port B: write (system clock domain, gfx_engine),   3 bits in
//
// Address = y * 640 + x  (0 .. 163839).
// ============================================================================

module gfx_buffer #(
    parameter DEPTH = 163840
) (
    input             clk_rd,      // pixel clock
    input      [17:0] rd_addr,
    output reg [2:0]  rd_data,     // {plane2, plane1, plane0}

    input             clk_wr,      // system clock
    input      [2:0]  we,
    input      [17:0] wr_addr,
    input      [2:0]  wr_data
);

    reg [2:0] mem [0:DEPTH-1];

    always @(posedge clk_rd) begin
        rd_data <= mem[rd_addr];
    end

    always @(posedge clk_wr) begin
        // gfx_engine writes all three planes for every pixel.
        if (|we) mem[wr_addr] <= wr_data;
    end

endmodule
