`timescale 1ns / 1ps

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 17:46:32 03/25/2015
// Design Name: Test bench for fourteen-segment display encoder.
// Module Name: fsd_encoder_test
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
module fsd_encoder_test;
   reg clk;
   reg reset_n;

   wire [14:0] seg;
   wire [3:0] dig;
   wire [31:0] chars;
   reg [3:0] dp;

   reg [7:0] char1;
   reg [7:0] char2;
   reg [7:0] char3;
   reg [7:0] char4;

   reg [14:0] seg_expected;
   reg [3:0] dig_expected;

   integer pass;
   integer i;

   fsd_encoder fsd_encoder(
      .seg(seg),
      .dig(dig),
      .chars(chars),
      .dp(dp),
      .clk_dig(clk),
      .reset_n(reset_n)
      );

   /*
    * Change input signals every fixed interval
    */
   initial begin
      pass = 1;

      char1 = "0";
      char2 = "0";
      char3 = "0";
      char4 = "0";
      dp = 4'b1111;

      clk = 1;
      reset_n = 0;
      #1;
      reset_n = 1;
      #9;

      char1 = "0";
      char2 = "0";
      char3 = "0";
      char4 = "0";
      dp = 4'b1111;

      #40;

      char1 = "1";
      char2 = "1";
      char3 = "1";
      char4 = "1";
      dp = 4'b0000;
   end

   /*
    * Verify
    */
   initial begin
      #1;

      seg_expected = 15'b111_1111_1111_1111;
      dig_expected = 4'b1111;

      verify();

      #10;

      for (i = 0; i < 8; i = i + 1) begin
         dig_expected = ~(1 << (i % 4));

         if (i < 4) begin
            seg_expected = 15'b111_1111_1100_0000;
         end
         else begin
            seg_expected = 15'b011_1011_1111_1001;
         end

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

   assign chars[7:0] = char1;
   assign chars[15:8] = char2;
   assign chars[23:16] = char3;
   assign chars[31:24] = char4;

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
         if (seg !== seg_expected || dig !== dig_expected) begin
            print_errors();
         end
      end
   endtask

   task print_errors;
      begin
         pass = 0;
         $display("@%0d Error:", $time);
         $display("Was: \t seg = %b, dig = %b",
            seg, dig);
         $display("Expected: \t seg = %b, dig = %b",
            seg_expected, dig_expected);
         $display("Details: \t chars = %b %b %b %b, dp = %b",
            char1, char2, char3, char4, dp);
      end
   endtask
endmodule
