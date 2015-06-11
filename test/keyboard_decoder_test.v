`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 17:46:32 03/25/2015
// Design Name: Test bench for keyboard decoder.
// Module Name: keyboard_decoder_test
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
module keyboard_decoder_test;
   reg clk;
   reg reset_n;

   wire [15:0] keys;
   reg [3:0] kb_col;
   wire [3:0] kb_row;

   reg [15:0] keys_expected;
   reg [3:0] kb_row_expected;

   integer duration;
   integer pass;
   integer i;
   integer j;
   integer k;

   keyboard_decoder kb_decoder(
      .keys(keys),
      .kb_row(kb_row),
      .kb_col(kb_col),
      .clk_kb(clk),
      .reset_n(reset_n)
      );

   /*
    * Change input signals every fixed interval
    */
   initial begin
      pass = 1;

      kb_col = 4'b1111;

      clk = 1;
      reset_n = 0;
      #1;
      reset_n = 1;
      #9;

      kb_col = 4'b1111;
   end

   /*
    * Verify keys
    */
   initial begin
      #1;

      keys_expected = 16'b1111_1111_1111_1111;

      if (keys !== keys_expected) begin
         print_keys_errors();
      end

      #10;

      for (i = 0; i < 36; i = i + 1) begin
         if (keys !== keys_expected) begin
            print_keys_errors();
         end

         #10;
      end

      #5;

      finish();
   end

   /*
    * Verify keyboard row output
    */
   initial begin
      #11;

      for (j = 0; j < 9; j = j + 1) begin
         for (k = 0; k < 4; k = k + 1) begin
            kb_row_expected = ~(1'b1 << k);

            if (kb_row !== kb_row_expected) begin
               print_kb_row_errors();
            end

            #10;
         end
      end
   end

   /*
    * Change keyboard col input upon row output changes
    */
   always @(kb_row) begin
      duration = $time - 10;

      // Row 1, Column 1
      if (duration >= 0 && duration < 40) begin
         if (kb_row === 4'b1110) begin
            kb_col <= 4'b1110;
         end
         else begin
            kb_col <= 4'b1111;
         end

         keys_expected <= 16'b1111_1111_1111_1111;
      end
      // Row 2, Column 1
      else if (duration >= 40 && duration < 80) begin
         if (kb_row === 4'b1101) begin
            kb_col <= 4'b1110;
         end
         else begin
            kb_col <= 4'b1111;
         end

         keys_expected <= 16'b1111_1111_1111_1110;
      end
      // Row 3, Column 1
      else if (duration >= 80 && duration < 120) begin
         if (kb_row === 4'b1011) begin
            kb_col <= 4'b1110;
         end
         else begin
            kb_col <= 4'b1111;
         end

         keys_expected <= 16'b1111_1111_1110_1111;
      end
      // Row 4, Column 1
      else if (duration >= 120 && duration < 160) begin
         if (kb_row === 4'b0111) begin
            kb_col <= 4'b1110;
         end
         else begin
            kb_col <= 4'b1111;
         end

         keys_expected <= 16'b1111_1110_1111_1111;
      end
      // Row 2, Column 2, 3
      // Row 3, Column 2, 3
      else if (duration >= 160 && duration < 200) begin
         if (kb_row === 4'b1101 || kb_row === 4'b1011) begin
            kb_col <= 4'b1001;
         end
         else begin
            kb_col <= 4'b1111;
         end

         keys_expected <= 16'b1110_1111_1111_1111;
      end
      // Row 1, Column 4
      // Row 4, Column 1
      else if (duration >= 200 && duration < 240) begin
         if (kb_row === 4'b1110) begin
            kb_col <= 4'b0111;
         end
         else if (kb_row === 4'b0111) begin
            kb_col <= 4'b1110;
         end
         else begin
            kb_col <= 4'b1111;
         end

         keys_expected <= 16'b1111_1001_1001_1111;
      end
      // All pressed
      else if (duration >= 240 && duration < 280) begin
         kb_col <= 4'b0000;

         keys_expected <= 16'b1110_1111_1111_0111;
      end
      // None pressed
      else if (duration >= 280 && duration < 320) begin
         kb_col <= 4'b1111;

         keys_expected <= 16'b0000_0000_0000_0000;
      end
      else if (duration >= 320 && duration < 360) begin
         keys_expected <= 16'b1111_1111_1111_1111;
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

   task print_keys_errors;
      begin
         pass = 0;
         $display("@%0d Error:", $time);
         $display("Was: \t keys = %b",
            keys);
         $display("Expected: \t keys = %b",
            keys_expected);
      end
   endtask

   task print_kb_row_errors;
      begin
         pass = 0;
         $display("@%0d Error:", $time);
         $display("Was: \t kb_row = %b",
            kb_row);
         $display("Expected: \t kb_row = %b",
            kb_row_expected);
      end
   endtask
endmodule
