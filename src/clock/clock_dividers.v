`timescale 1ns / 1ps

`include "../directive/frequency.vh"

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 12:16:02 04/10/2015
// Design Name: Clock dividers.
// Module Name: clock_dividers
// Project Name:
// Target Devices:
// Tool versions:
// Description: Output all needed divided clock signals.
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module clock_dividers (
   // Divided clock signal for fourteen-segment display digit select signal.
   output clk_fsd_dig,
   // Divided clock signal for audio system clock.
   output clk_audio_sys,
   // Divided clock signal for audio data bit clock.
   output clk_audio_bit,
   // Divided clock signal for audio volume.
   output clk_audio_vol,
   // Divided clock signal for keyboard decoding.
   output clk_kb_decoding,
   // Divided clock signal for push-button and keyboard debounce.
   output clk_pb_kb_db,
   // Divided clock signal for push-button and keyboard one-pulse.
   output clk_pb_kb_op,
   // Divided clock signal for LCD controller.
   output clk_lcd_ctrl,

   // Clock signal.
   input clk,
   // Reset signal.
   input reset_n
   );

   clock_divider_one #(
      .FREQUENCY_DIV_HALF(
         `FREQUENCY_DIV_HALF_FSD_DIGIT),
      .FREQUENCY_DIV_HALF_BIT_WIDTH(
         `FREQUENCY_DIV_HALF_FSD_DIGIT_BIT_WIDTH)
      ) cd_fsd_dig(
      .clk_div(clk_fsd_dig),

      .clk(clk),
      .reset_n(reset_n)
      );

   clock_divider_one #(
      .FREQUENCY_DIV_HALF(
         `FREQUENCY_DIV_HALF_AUDIO_SYS),
      .FREQUENCY_DIV_HALF_BIT_WIDTH(
         `FREQUENCY_DIV_HALF_AUDIO_SYS_BIT_WIDTH)
      ) cd_fsd_audio_sys(
      .clk_div(clk_audio_sys),

      .clk(clk),
      .reset_n(reset_n)
      );

   clock_divider_one #(
      .FREQUENCY_DIV_HALF(
         `FREQUENCY_DIV_HALF_AUDIO_BIT),
      .FREQUENCY_DIV_HALF_BIT_WIDTH(
         `FREQUENCY_DIV_HALF_AUDIO_BIT_BIT_WIDTH)
      ) cd_fsd_audio_bit(
      .clk_div(clk_audio_bit),

      .clk(clk),
      .reset_n(reset_n)
      );

   clock_divider_one #(
      .FREQUENCY_DIV_HALF(
         `FREQUENCY_DIV_HALF_AUDIO_VOL),
      .FREQUENCY_DIV_HALF_BIT_WIDTH(
         `FREQUENCY_DIV_HALF_AUDIO_VOL_BIT_WIDTH)
      ) cd_fsd_audio_vol(
      .clk_div(clk_audio_vol),

      .clk(clk),
      .reset_n(reset_n)
      );

   clock_divider_one #(
      .FREQUENCY_DIV_HALF(
         `FREQUENCY_DIV_HALF_KEYBOARD_DECODING),
      .FREQUENCY_DIV_HALF_BIT_WIDTH(
         `FREQUENCY_DIV_HALF_KEYBOARD_DECODING_BIT_WIDTH)
      ) cd_kb_decoding(
      .clk_div(clk_kb_decoding),

      .clk(clk),
      .reset_n(reset_n)
      );

   clock_divider_one #(
      .FREQUENCY_DIV_HALF(
         `FREQUENCY_DIV_HALF_PUSHBUTTON_KEYBOARD_DEBOUNCE),
      .FREQUENCY_DIV_HALF_BIT_WIDTH(
         `FREQUENCY_DIV_HALF_PUSHBUTTON_KEYBOARD_DEBOUNCE_BIT_WIDTH)
      ) cd_pb_kb_pb(
      .clk_div(clk_pb_kb_db),

      .clk(clk),
      .reset_n(reset_n)
      );

   clock_divider_one #(
      .FREQUENCY_DIV_HALF(
         `FREQUENCY_DIV_HALF_PUSHBUTTON_KEYBOARD_ONEPULSE),
      .FREQUENCY_DIV_HALF_BIT_WIDTH(
         `FREQUENCY_DIV_HALF_PUSHBUTTON_KEYBOARD_ONEPULSE_BIT_WIDTH)
      ) cd_pb_kb_op(
      .clk_div(clk_pb_kb_op),

      .clk(clk),
      .reset_n(reset_n)
      );

   clock_divider_one #(
      .FREQUENCY_DIV_HALF(
         `FREQUENCY_DIV_HALF_LCD_CTRL),
      .FREQUENCY_DIV_HALF_BIT_WIDTH(
         `FREQUENCY_DIV_HALF_LCD_CTRL_BIT_WIDTH)
      ) cd_lcd_ctrl(
      .clk_div(clk_lcd_ctrl),

      .clk(clk),
      .reset_n(reset_n)
      );
endmodule
