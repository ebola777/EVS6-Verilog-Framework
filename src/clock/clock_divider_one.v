`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 16:21:58 03/25/2015
// Design Name: Clock divider of one output.
// Module Name: clock_divider_one
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Divide clock signal using fractional-n division method.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module clock_divider_one #(
   // How many times new clock signal frequency will be slower than original.
   // Note that this is half times.
   parameter FREQUENCY_DIV_HALF = 1,
   // Frequency division bit width.
   parameter FREQUENCY_DIV_HALF_BIT_WIDTH = 1
   )(
   // Divided clock signal.
   output reg clk_div,

   // Clock signal.
   input clk,
   // Reset signal.
   input reset_n
   );

   reg [(FREQUENCY_DIV_HALF_BIT_WIDTH - 1):0] num;
   wire [(FREQUENCY_DIV_HALF_BIT_WIDTH - 1):0] next_num;

   always @(posedge clk or negedge reset_n) begin
      if ((!reset_n)) begin
         clk_div <= 0;
         num <= FREQUENCY_DIV_HALF - 1'b1;
      end
      else begin
         if (num == (FREQUENCY_DIV_HALF - 1)) begin
            clk_div <= (~clk_div);
            num <= 0;
         end
         else begin
            num <= next_num;
         end
      end
   end

   assign next_num = num + 1'b1;
endmodule
