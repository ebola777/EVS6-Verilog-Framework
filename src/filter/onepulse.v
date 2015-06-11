`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 20:35:58 04/01/2015
// Design Name: One-pulse signal.
// Module Name: onepulse
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Make signal one-pulsed.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module onepulse (
   // One-pulsed signal. This signal becomes triggered when
   // source signal is triggered, and only lasts for one clock cycle.
   output reg signal_onepulsed_n,

   // Source signal.
   input signal_n,
   // Clock signal for one-pulsing.
   input clk_op,
   // Reset signal.
   input reset_n
   );

   wire next_signal_n;
   reg last_signal_n;

   always @(posedge clk_op or negedge reset_n) begin
      if ((!reset_n)) begin
         signal_onepulsed_n <= 1;
         last_signal_n <= 1;
      end
      else begin
         signal_onepulsed_n <= next_signal_n;
         last_signal_n <= signal_n;
      end
   end

   assign next_signal_n = ~(last_signal_n == 1'b1 && signal_n == 1'b0);
endmodule
