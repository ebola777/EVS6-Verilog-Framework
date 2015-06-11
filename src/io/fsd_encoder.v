`timescale 1ns / 1ps

`include "../directive/io.vh"
`include "../directive/data_type.vh"

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 12:28:38 03/25/2015
// Design Name: Fourteen-segment display (FSD) encoder.
// Module Name: fsd_encoder
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Encode ASCII characters to FSD digit segments.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module fsd_encoder (
   // Segment map.
   output [(`FSD_SEGMENT_COUNT - 1):0] seg,
   // Which digit to show.
   output [(`FSD_DIGIT_COUNT - 1):0] dig,

   // ASCII code character vector.
   input [(`FSD_DIGIT_COUNT * `ASCII_BIT_WIDTH - 1):0] chars,
   // Whether to show decimal point.
   input [(`FSD_DIGIT_COUNT - 1):0] dp,
   // Clock signal.
   input clk_dig,
   // Reset signal.
   input reset_n
   );

   wire [(`FSD_SEGMENT_COUNT - 2):0] seg_without_dp;

   reg [(`FSD_DIGIT_COUNT_BIT_WIDTH - 1):0] digit_index;

   wire [(`FSD_DIGIT_COUNT * `ASCII_BIT_WIDTH - 1):0] chars_shift;
   wire [(`ASCII_BIT_WIDTH - 1):0] single_char;

   fsd_one_digit_encoder one_digit_encoder(
      .seg(seg_without_dp),

      .char(single_char)
      );

   always @(posedge clk_dig or negedge reset_n) begin
      if ((!reset_n)) begin
         digit_index <= (`FSD_DIGIT_COUNT - 1);
      end
      else begin
         digit_index <= digit_index + 1'b1;
      end
   end

   assign seg = ((!reset_n) ? (~1'b0) : {dp[digit_index], seg_without_dp});
   assign dig = ((!reset_n) ? (~1'b0) : ~(1'b1 << digit_index));

   assign chars_shift = (chars >> (digit_index * `ASCII_BIT_WIDTH));
   assign single_char = chars_shift[(`ASCII_BIT_WIDTH - 1):0];
endmodule
