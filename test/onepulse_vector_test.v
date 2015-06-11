`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 17:46:32 03/25/2015
// Design Name: Test bench for one-pulsed pushbuttons signals.
// Module Name: onepulse_vector_test
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
module onepulse_vector_test;
   reg clk;
   reg reset_n;

   wire [7:0] pushbutton_onepulsed_n;
   reg [7:0] pushbutton;

   reg [7:0] pushbutton_onepulsed_n_expected;

   integer pass;

   onepulse_vector #(
      .SIGNAL_BIT_WIDTH(8)
      ) op_vec(
      .signals_onepulsed_n(pushbutton_onepulsed_n),
      .signals_n(pushbutton),
      .clk_op(clk),
      .reset_n(reset_n)
      );

   /*
    * Change input signals every fixed interval
    */
   initial begin
      pass = 1;

      pushbutton = 8'b1111_1111;

      clk = 1;
      reset_n = 0;
      #1;
      reset_n = 1;
      #9;

      pushbutton = 8'b1111_1111;
      #10;
      pushbutton = 8'b1111_1110;
      #10;
      pushbutton = 8'b1111_1111;
      #10;
      pushbutton = 8'b1111_1110;
      #10;
      pushbutton = 8'b1111_1110;
      #10;
      pushbutton = 8'b1111_1110;
      #10;
      pushbutton = 8'b1111_1111;
   end

   /*
    * Verify
    */
   initial begin
      #1;

      pushbutton_onepulsed_n_expected = 8'b1111_1111;

      verify();

      #10;

      pushbutton_onepulsed_n_expected = 8'b1111_1111;

      verify();

      #10;

      pushbutton_onepulsed_n_expected = 8'b1111_1110;

      verify();

      #10;

      pushbutton_onepulsed_n_expected = 8'b1111_1111;

      verify();

      #10;

      pushbutton_onepulsed_n_expected = 8'b1111_1110;

      verify();

      #10;

      pushbutton_onepulsed_n_expected = 8'b1111_1111;

      verify();

      #10;

      pushbutton_onepulsed_n_expected = 8'b1111_1111;

      verify();

      #10;

      pushbutton_onepulsed_n_expected = 8'b1111_1111;

      verify();

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
         if (pushbutton_onepulsed_n !== pushbutton_onepulsed_n_expected) begin
            print_errors();
         end
      end
   endtask

   task print_errors;
      begin
         pass = 0;
         $display("@%0d Error:", $time);
         $display("Was: \t pushbutton_onepulsed_n = %b",
            pushbutton_onepulsed_n);
         $display("Expected: \t pushbutton_onepulsed_n = %b",
            pushbutton_onepulsed_n_expected);
      end
   endtask
endmodule
