`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 01:17:07 04/09/2015
// Design Name: Debounce vector signals.
// Module Name: debounce_vector
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Debounce each signal in a vector.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module debounce_vector #(
   // Signal vector length.
   parameter SIGNAL_BIT_WIDTH = 1,
   // Debounce length.
   parameter DEBOUNCE_LENGTH = 4,
   // Debounce length bit width.
   parameter DEBOUNCE_LENGTH_BIT_WIDTH = 2
   )(
   // Debounced signal vector.
   output [(SIGNAL_BIT_WIDTH - 1):0] signals_debounced_n,

   // Source signal vector.
   input [(SIGNAL_BIT_WIDTH - 1):0] signals_n,
   // Clock signal for debouncing.
   input clk_db,
   // Reset signal.
   input reset_n
   );

   generate
      genvar i;

      for (i = 0; i < SIGNAL_BIT_WIDTH; i = i + 1) begin: each_bit
         debounce #(
            .DEBOUNCE_LENGTH(DEBOUNCE_LENGTH),
            .DEBOUNCE_LENGTH_BIT_WIDTH(DEBOUNCE_LENGTH_BIT_WIDTH)
            ) db(
            .signal_debounced_n(signals_debounced_n[i]),

            .signal_n(signals_n[i]),
            .clk_db(clk_db),
            .reset_n(reset_n)
            );
      end
   endgenerate
endmodule
