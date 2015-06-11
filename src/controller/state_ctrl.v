`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 18:58:49 04/01/2015
// Design Name: State controller.
// Module Name: state_ctrl
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Enable state controller.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module state_ctrl (
   // Enable signal switched only when source signal is triggered.
   output reg enable,

   // Source enable signal.
   input src,
   // Clock signal for controller.
   input clk_ctrl,
   // Reset signal.
   input reset_n
   );

   always @(posedge clk_ctrl or negedge reset_n) begin
      if ((!reset_n)) begin
         enable <= 1;
      end
      else begin
         if (src == 1'b0) begin
            enable <= (~enable);
         end
      end
   end
endmodule
