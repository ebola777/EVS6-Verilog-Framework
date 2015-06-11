`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 16:04:06 03/25/2011
// Design Name: Debounce signal.
// Module Name: debounce
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Debounce signal.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module debounce #(
   // Debounce length. The length of continuous triggered input signal cycles
   // plus one triggered output signal cycle.
   parameter DEBOUNCE_LENGTH = 4,
   // Debounce length bit width.
   parameter DEBOUNCE_LENGTH_BIT_WIDTH = 2
   )(
   // Debounced signal.
   output reg signal_debounced_n,

   // Source signal.
   input signal_n,
   // Clock signal for debouncing.
   input clk_db,
   // Reset signal.
   input reset_n
   );

   // Store un-debounced continuous signals
   reg [(DEBOUNCE_LENGTH_BIT_WIDTH - 1):0] count;

   always @(posedge clk_db or negedge reset_n) begin
      if ((!reset_n) || signal_n == 1'b1) begin
         signal_debounced_n <= 1;
         count <= 0;
      end
      else if (count != (DEBOUNCE_LENGTH - 1)) begin
         signal_debounced_n <= 1;
         count <= count + 1'b1;
      end
      else begin
         signal_debounced_n <= 0;
      end
   end
endmodule
