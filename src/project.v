/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    wire oe = ui_in[1];

    prog_counter counter_inst (
        .clk (clk),
        .reset (rst_n),
        .load (ui_in[0]),
        .data_in (uio_in),
        .data_out (uo_out)
    );

    assign uio_out = uo_out;
    assign uio_oe = {8{oe}};

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, ui_in[7:2], 1'b0};

endmodule

module prog_counter (
    input wire clk,
    input wire reset,        // async reset
    input wire load,         // sync load
    input wire [7:0] data_in,
    output wire [7:0] data_out
);

reg [7:0] count;

// Sequential logic
    always @(posedge clk or negedge reset) begin
    if (reset)
        count <= 8'b00000000;
        else if (load)
        count <= data_in;
    else 
        count <= count + 1;
end

// Tri-state output
assign data_out = count;

endmodule
