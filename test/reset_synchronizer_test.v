`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 04:46:49 04/16/2015
// Design Name: Test bench for reset synchronizer.
// Module Name: reset_synchronizer_test
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
///////////////////////////////////////////////////////////////////////////////
module reset_synchronizer_test;
   reg clk;
   reg reset_async_n;

   wire reset_sync_n;

   reg reset_sync_n_expected;

   integer duration;
   integer pass;

   reset_synchronizer reset_sync(
      .reset_sync_n(reset_sync_n),
      .clk_sync(clk),
      .reset_async_n(reset_async_n)
      );

   /*
    * Change input signals every fixed interval
    */
   initial begin
      pass = 1;

      clk = 1;
      reset_async_n = 0;
      #1;
      reset_async_n = 1;
      #9;

      #20;

      #5;
      reset_async_n = 0;
      #3;
      reset_async_n = 1;
      #2;

      #20;

      #2;
      reset_async_n = 0;
      #2;
      reset_async_n = 1;
      #2;
      reset_async_n = 0;
      #2;
      reset_async_n = 1;
      #2;

      #20;

      reset_async_n = 0;

      #30;

      #5;

      finish();
   end

   /*
    * Verify synchronized reset signal
    */
   always @(reset_sync_n) begin
      duration = $time - 0;

      if (duration >= 0 && duration < 20) begin
         reset_sync_n_expected = 0;

         verify();
      end
      else if (duration >= 20 && duration < 35) begin
         reset_sync_n_expected = 1;

         verify();
      end
      else if (duration >= 35 && duration < 50) begin
         reset_sync_n_expected = 0;

         verify();
      end
      else if (duration >= 50 && duration < 62) begin
         reset_sync_n_expected = 1;

         verify();
      end
      else if (duration >= 62 && duration < 80) begin
         reset_sync_n_expected = 0;

         verify();
      end
      else if (duration >= 80 && duration < 90) begin
         reset_sync_n_expected = 1;

         verify();
      end
      else if (duration >= 90 && duration < 120) begin
         reset_sync_n_expected = 0;

         verify();
      end
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
         if (reset_sync_n !== reset_sync_n_expected) begin
            print_errors();
         end
      end
   endtask

   task print_errors;
      begin
         pass = 0;
         $display("@%0d Error:", $time);
         $display("Was: \t reset_sync_n = %b",
            reset_sync_n);
         $display("Expected: \t reset_sync_n = %b",
            reset_sync_n_expected);
      end
   endtask
endmodule
