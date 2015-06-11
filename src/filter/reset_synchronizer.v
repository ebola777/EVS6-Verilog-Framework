`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 04:36:41 04/16/2015
// Design Name: Reset signal synchronizer.
// Module Name: reset_synchronizer
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    "Two flip-flops are required to synchronize the reset signal to the
//       clock pulse where the second flip-flop is used to remove any
//       metastability that might be caused by the reset signal being removed
//       asynchronously and too close to the rising clock edge."
//       - Asynchronous & Synchronous Reset Design Techniques - Part Deux
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module reset_synchronizer (
   // Synchronized reset signal.
   output reg reset_sync_n,

   // Clock signal for synchronizing.
   input clk_sync,
   // Asynchronous reset signal.
   input reset_async_n
   );

   reg reset_buffer_n;

   always @(posedge clk_sync or negedge reset_async_n) begin
      if ((!reset_async_n)) begin
         reset_sync_n <= 0;
         reset_buffer_n <= 0;
      end
      else begin
         reset_sync_n <= reset_buffer_n;
         reset_buffer_n <= 1;
      end
   end
endmodule
