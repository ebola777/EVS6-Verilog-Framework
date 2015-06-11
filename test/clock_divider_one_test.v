`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 13:49:53 04/14/2015
// Design Name: Test bench for clock divider.
// Module Name: clock_divider_one_test
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
module clock_divider_one_test;
   reg clk;
   reg reset_n;

   wire clk_div;

   reg clk_div_expected;

   integer pass;
   integer i;

   clock_divider_one #(
      .FREQUENCY_DIV_HALF(4),
      .FREQUENCY_DIV_HALF_BIT_WIDTH(2)
      ) cd(
      .clk_div(clk_div),
      .clk(clk),
      .reset_n(reset_n)
      );

   /*
    * Change input signals every fixed interval
    */
   initial begin
      pass = 1;

      clk = 1;
      reset_n = 0;
      #1;
      reset_n = 1;
      #9;
   end

   /*
    * Verify
    */
   initial begin
      #1;

      clk_div_expected = 0;

      verify();

      #10;

      for (i = 0; i < 16; i = i + 1) begin
         clk_div_expected = ((i / 4) % 2 == 0 ? 1 : 0);

         verify();

         #10;
      end

      #5;

      finish();
   end

   /*
    * Clock signal
    */
   always #5 clk = ~clk;

   task finish;
      begin
         if (pass) begin
            $display("OK. Test passed.");
         end
         else begin
            $display("ERROR. Please check errors.");
         end

         $finish;
      end
   endtask

   task verify;
      begin
         if (clk_div !== clk_div_expected) begin
            print_errors();
         end
      end
   endtask

   task print_errors;
      begin
         pass = 0;
         $display("@%0d Error:", $time);
         $display("Was: \t clk_div = %b",
            clk_div);
         $display("Expected: \t clk_div = %b",
            clk_div_expected);
      end
   endtask
endmodule
