`timescale 1ns / 1ps

`include "../directive/io.vh"
`include "../directive/data_type.vh"
`include "../directive/characters.vh"

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 13:11:16 04/14/2015
// Design Name: Keyboard controller.
// Module Name: keyboard_ctrl
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Output ASCII code representing keyboard vector.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module keyboard_ctrl (
   // ASCII code of keyboard vector.
   output reg [(`ASCII_BIT_WIDTH - 1):0] kb_char,

   // Decoded keyboard vector.
   input [(`KEYBOARD_COUNT - 1):0] keys,
   // Clock signal for controller.
   input clk_ctrl,
   // Reset signal.
   input reset_n
   );

   reg [(`ASCII_BIT_WIDTH - 1):0] next_kb_char;

   always @(posedge clk_ctrl or negedge reset_n) begin
      if ((!reset_n)) begin
         kb_char <= "";
      end
      else begin
         kb_char <= next_kb_char;
      end
   end

   always @(keys) begin
      case (keys)
      16'b1111_1111_1111_1110: next_kb_char <= "F";
      16'b1111_1111_1111_1101: next_kb_char <= "E";
      16'b1111_1111_1111_1011: next_kb_char <= "D";
      16'b1111_1111_1111_0111: next_kb_char <= "C";
      16'b1111_1111_1110_1111: next_kb_char <= "B";
      16'b1111_1111_1101_1111: next_kb_char <= "3";
      16'b1111_1111_1011_1111: next_kb_char <= "6";
      16'b1111_1111_0111_1111: next_kb_char <= "9";
      16'b1111_1110_1111_1111: next_kb_char <= "A";
      16'b1111_1101_1111_1111: next_kb_char <= "2";
      16'b1111_1011_1111_1111: next_kb_char <= "5";
      16'b1111_0111_1111_1111: next_kb_char <= "8";
      16'b1110_1111_1111_1111: next_kb_char <= "0";
      16'b1101_1111_1111_1111: next_kb_char <= "1";
      16'b1011_1111_1111_1111: next_kb_char <= "4";
      16'b0111_1111_1111_1111: next_kb_char <= "7";

      // Press all keyboard buttons in one diagonal line
      16'b0111_1011_1101_1110: next_kb_char <= "W";
      16'b1110_1101_1011_0111: next_kb_char <= "X";
      // Cannot show because of hardware limitation
      16'b0111_0111_0111_0111: next_kb_char <= "Y";
      // Press all keyboard buttons in the bottommost row
      16'b0000_1111_1111_1111: next_kb_char <= "Z";

      // Used to suppress unused leftmost bit.
      default: next_kb_char <= `CHAR_FILLED;
      endcase
   end
endmodule
