`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 20:05:34 04/26/2015
// Design Name: Test bench for audio encoder.
// Module Name: audio_encoder_test
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
module audio_encoder_test;
   reg clk;
   reg reset_n;

   wire audio_data;
   wire audio_ws;
   reg [5:0] vol;

   reg audio_data_expected;
   reg audio_ws_expected;

   integer pass;
   integer i;

   audio_encoder audio_encoder(
      .audio_data(audio_data),
      .audio_ws(audio_ws),
      .vol(vol),
      .clk_audio_bit(clk),
      .reset_n(reset_n)
      );

   /*
    * Change input signals every fixed interval
    */
   initial begin
      pass = 1;

      vol = 6'b11_1111;

      clk = 1;
      reset_n = 0;
      #1;
      reset_n = 1;
      #9;

      vol = 6'b11_1111;

      #80;

      vol = 6'b00_0000;

      #80;

      vol = 6'b10_1010;
   end

   /*
    * Verify
    */
   initial begin
      #1;

      audio_data_expected = 0;
      audio_ws_expected = 0;

      verify();

      #10;

      audio_ws_expected = 1;

      for (i = 0; i < 8; i = i + 1) begin
         audio_data_expected = 8'b0011_1111 >> (7 - i);

         verify();

         #10;
      end

      audio_ws_expected = 0;

      for (i = 0; i < 8; i = i + 1) begin
         audio_data_expected = 8'b0000_0000 >> (7 - i);

         verify();

         #10;
      end

      audio_ws_expected = 1;

      for (i = 0; i < 8; i = i + 1) begin
         audio_data_expected = 8'b0010_1010 >> (7 - i);

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
         if (audio_data != audio_data_expected ||
               audio_ws != audio_ws_expected) begin
            print_errors();
         end
      end
   endtask

   task print_errors;
      begin
         pass = 0;
         $display("@%0d Error:", $time);
         $display("Was: \t audio_data = %b, audio_ws = %b",
            audio_data, audio_ws);
         $display("Expected: \t audio_data = %b, audio_ws = %b",
            audio_data_expected, audio_ws_expected);
      end
   endtask
endmodule
