`timescale 1ns / 1ps

`include "../directive/io.vh"

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 18:27:55 04/07/2015
// Design Name: Keyboard decoder.
// Module Name: keyboard_decoder
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Decode pressed and un-pressed keyboard buttons to a single
//       vector in which each bit represents whether the button is pressed.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module keyboard_decoder (
   // Decoded keys.
   output reg [(`KEYBOARD_COUNT - 1):0] keys,
   // Keyboard row output.
   output [(`KEYBOARD_ROW_COUNT - 1):0] kb_row,

   // Keyboard column input.
   input [(`KEYBOARD_COL_COUNT - 1):0] kb_col,
   // Clock signal.
   input clk_kb,
   // Reset signal.
   input reset_n
   );

   wire [(`KEYBOARD_COUNT - 1):0] keys_buffer;
   // Partial buffer has no leftmost column because it's never used.
   reg [((`KEYBOARD_ROW_COUNT - 1) *
      `KEYBOARD_COL_COUNT - 1):0] last_keys_buffer_partial;
   wire [(`KEYBOARD_COUNT - 1):0] last_keys_buffer;

   reg [(`KEYBOARD_ROW_COUNT_BIT_WIDTH - 1):0] row_index;

   wire [(`KEYBOARD_COL_COUNT - 1):0] kb_col_rev;
   wire [(`KEYBOARD_COUNT - 1):0] kb_col_rev_shift;

   always @(posedge clk_kb or negedge reset_n) begin
      if ((!reset_n)) begin
         keys <= (~0);
         last_keys_buffer_partial <= (~0);

         row_index <= `KEYBOARD_ROW_COUNT - 1'b1;
      end
      else begin
         if (row_index == (`KEYBOARD_ROW_COUNT - 1)) begin
            keys <= keys_buffer;
            last_keys_buffer_partial <= (~0);
         end
         else begin
            last_keys_buffer_partial <=
               keys_buffer[(`KEYBOARD_COUNT - `KEYBOARD_ROW_COUNT - 1):0];
         end

         row_index <= row_index + 1'b1;
      end
   end

   assign kb_row = ~(1'b1 << row_index);

   assign keys_buffer = last_keys_buffer ^ kb_col_rev_shift;
   assign last_keys_buffer =
      {{`KEYBOARD_COL_COUNT{1'b1}}, last_keys_buffer_partial};

   assign kb_col_rev = (~kb_col);
   assign kb_col_rev_shift =
      (kb_col_rev << (row_index * `KEYBOARD_COL_COUNT));
endmodule
