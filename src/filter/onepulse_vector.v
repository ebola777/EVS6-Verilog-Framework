`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 01:17:07 04/09/2015
// Design Name: Make vector signals one-pulsed.
// Module Name: onepulse_vector
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Make each signal in a vector one-pulsed.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module onepulse_vector #(
   // Signal vector length.
   parameter SIGNAL_BIT_WIDTH = 1
   )(
   // One-pulsed signal vector.
   output [(SIGNAL_BIT_WIDTH - 1):0] signals_onepulsed_n,

   // Source signal vector.
   input [(SIGNAL_BIT_WIDTH - 1):0] signals_n,
   // Clock signal for one-pulse.
   input clk_op,
   // Reset signal.
   input reset_n
   );

   generate
      genvar i;

      for (i = 0; i < SIGNAL_BIT_WIDTH; i = i + 1) begin: each_bit
         onepulse op(
            .signal_onepulsed_n(signals_onepulsed_n[i]),

            .signal_n(signals_n[i]),
            .clk_op(clk_op),
            .reset_n(reset_n)
            );
      end
   endgenerate
endmodule
