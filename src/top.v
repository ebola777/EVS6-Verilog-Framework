`timescale 1ns / 1ps

`include "directive/directives.vh"

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 16:25:28 03/25/2015
// Design Name: Top module.
// Module Name: top
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Demo application for EVS6 board.
//    Press push-button S1 to reset.
//    Press push-button S2 to switch LEDs and beep sound.
//    Press any keyboard button to show character on fourteen segment display
//       and beep.
//    The first LED will turn on if any of DIP switch is on.
//    The second LED will blink if any of the push-button is pressed.
//    The third LED will blink if any of keyboard button is pressed.
//    The other LEDS will turn on based on the enable state switched by
//       push-button S2.
//    The LCD screen will show triangle pattern scrolling up.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module top (
   // LCD
   inout [(`LCD_DATA_BIT_WIDTH - 1):0] lcd_data,

   // LED
   output [(`LED_COUNT - 1):0] led,
   // Fourteen-segment display
   output [(`FSD_SEGMENT_COUNT - 1):0] fsd_segment,
   output [(`FSD_DIGIT_COUNT - 1):0] fsd_digit,
   // LCD
   output [(`LCD_COL_SELECT_COUNT - 1):0] lcd_cs,
   output lcd_io,
   output lcd_wr,
   output lcd_en,
   output lcd_reset_n,
   // Audio
   output audio_data,
   output audio_ws,
   output audio_bck,
   output audio_clk,
   output audio_appsel,
   // Keyboard
   output [(`KEYBOARD_ROW_COUNT - 1):0] keyboard_row,

   // DIP switch
   input [(`DIP_COUNT - 1):0] dip,
   // Push-button
   input [(`PUSHBUTTON_COUNT - 1):0] pushbutton,
   // Keyboard
   input [(`KEYBOARD_COL_COUNT - 1):0] keyboard_col,
   // Clock
   input clk
   );

   // Fourteen-segment display signals (Output)
   wire [(`FSD_DIGIT_COUNT * `ASCII_BIT_WIDTH - 1):0] fsd_chars;

   // Audio signals (Output)
   wire [(`AUDIO_BIT_WIDTH_VOLUME - 1):0] audio_vol;

   // Push-button signals (Input)
   wire [(`PUSHBUTTON_COUNT - 1):0] pushbutton_onepulsed_n;

   // Keyboard signals (Input)
   wire [(`ASCII_BIT_WIDTH - 1):0] kb_char;
   wire [(`KEYBOARD_COUNT - 1):0] keys_debounced_n;
   wire [(`KEYBOARD_COUNT - 1):0] keys_onepulsed_n;

   // Clock signals (Input)
   wire clk_fsd_dig;
   wire clk_audio_sys;
   wire clk_audio_bit;
   wire clk_audio_vol;
   wire clk_kb_decoding;
   wire clk_pb_kb_db;
   wire clk_pb_kb_op;
   wire clk_lcd_ctrl;

   // Reset signals (Input)
   wire reset_n;

   // Controller signals (Input)
   wire [(`LCD_DATA_BIT_WIDTH - 1):0] lcd_data_write;
   wire [(`LCD_ROW_COUNT_BIT_WIDTH - 1):0] lcd_start_line_write;
   wire [(`LCD_ADDR_Y_COUNT_BIT_WIDTH - 1):0] lcd_addr_y;
   wire [(`LCD_ADDR_X_COUNT_BIT_WIDTH - 1):0] lcd_addr_x;
   wire [(`LCD_DATA_ACTION_COUNT_BIT_WIDTH - 1):0] lcd_data_action;
   wire lcd_instr_busy;
   wire lcd_data_busy;
   wire enable;

   /*
    * Fourteen-segment display encoder (Output)
    */

   wire [(`FSD_DIGIT_COUNT - 1):0] dp;

   fsd_encoder fsd_encoder(
      .seg(fsd_segment),
      .dig(fsd_digit),

      .chars(fsd_chars),
      .dp(dp),
      .clk_dig(clk_fsd_dig),
      .reset_n(reset_n)
      );

   assign dp = 4'b0000;

   /*
    * LCD encoder (Output)
    */

   lcd_encoder lcd_encoder(
      .lcd_data(lcd_data),

      .lcd_cs(lcd_cs),
      .lcd_io(lcd_io),
      .lcd_wr(lcd_wr),
      .lcd_en(lcd_en),
      .lcd_reset_n(lcd_reset_n),
      .instr_busy(lcd_instr_busy),

      .data_write(lcd_data_write),
      .start_line_write(lcd_start_line_write),
      .addr_y(lcd_addr_y),
      .addr_x(lcd_addr_x),
      .data_action(lcd_data_action),
      .data_busy(lcd_data_busy),
      .clk_lcd(clk),
      .reset_n(reset_n)
      );

   /*
    * Audio encoder (Output)
    */

   audio_encoder audio_encoder(
      .audio_data(audio_data),
      .audio_ws(audio_ws),

      .vol(audio_vol),
      .clk_audio_bit(clk_audio_bit),
      .reset_n(reset_n)
      );

   assign audio_bck = clk_audio_bit;
   assign audio_clk = clk_audio_sys;
   assign audio_appsel = 1;

   /*
    * Pushbutton (Input)
    */

   wire [(`PUSHBUTTON_COUNT - 1):0] pushbutton_debounced_n;

   debounce_vector #(
      .SIGNAL_BIT_WIDTH(`PUSHBUTTON_COUNT),
      .DEBOUNCE_LENGTH(`DEBOUNCE_LENGTH_PUSHBUTTON),
      .DEBOUNCE_LENGTH_BIT_WIDTH(`DEBOUNCE_LENGTH_PUSHBUTTON_BIT_WIDTH)
      ) db_vec_pb(
      .signals_debounced_n(pushbutton_debounced_n),

      .signals_n(pushbutton),
      .clk_db(clk_pb_kb_db),
      .reset_n(reset_n)
      );

   onepulse_vector #(
      .SIGNAL_BIT_WIDTH(`PUSHBUTTON_COUNT)
      ) op_vec_pb(
      .signals_onepulsed_n(pushbutton_onepulsed_n),

      .signals_n(pushbutton_debounced_n),
      .clk_op(clk_pb_kb_op),
      .reset_n(reset_n)
      );

   /*
    * Keyboard (Input)
    */

   wire [(`KEYBOARD_COUNT - 1):0] keys;

   keyboard_decoder kb_decoder(
      .keys(keys),
      .kb_row(keyboard_row),

      .kb_col(keyboard_col),
      .clk_kb(clk_kb_decoding),
      .reset_n(reset_n)
      );

   debounce_vector #(
      .SIGNAL_BIT_WIDTH(`KEYBOARD_COUNT),
      .DEBOUNCE_LENGTH(`DEBOUNCE_LENGTH_KEYBOARD),
      .DEBOUNCE_LENGTH_BIT_WIDTH(`DEBOUNCE_LENGTH_KEYBOARD_BIT_WIDTH)
      ) db_vec_kb(
      .signals_debounced_n(keys_debounced_n),

      .signals_n(keys),
      .clk_db(clk_pb_kb_db),
      .reset_n(reset_n)
      );

   onepulse_vector #(
      .SIGNAL_BIT_WIDTH(`KEYBOARD_COUNT)
      ) op_vec_kb(
      .signals_onepulsed_n(keys_onepulsed_n),

      .signals_n(keys_debounced_n),
      .clk_op(clk_pb_kb_op),
      .reset_n(reset_n)
      );

   /*
    * Clock dividers (Input)
    */

   clock_dividers cds(
      .clk_fsd_dig(clk_fsd_dig),
      .clk_audio_sys(clk_audio_sys),
      .clk_audio_bit(clk_audio_bit),
      .clk_audio_vol(clk_audio_vol),
      .clk_kb_decoding(clk_kb_decoding),
      .clk_pb_kb_db(clk_pb_kb_db),
      .clk_pb_kb_op(clk_pb_kb_op),
      .clk_lcd_ctrl(clk_lcd_ctrl),

      .clk(clk),
      .reset_n(reset_n)
      );

   /*
    * Reset signal (Input)
    */

   reset_synchronizer reset_sync(
      .reset_sync_n(reset_n),

      .clk_sync(clk),
      .reset_async_n(pushbutton[0])
      );

   /*
    * LED controller (Input)
    */

   // The 1st LED is on when reset is off and any of the DIP switch is on
   assign led[0] = reset_n & (| (~dip));

   // The 2nd LED blinks when reset is off and any of the push-button is
   // pressed
   assign led[1] = reset_n & (| (~pushbutton_onepulsed_n));

   // The 3rd LED blinks when reset is off and any of the keyboard button is
   // pressed
   assign led[2] = reset_n & (| (~keys_onepulsed_n));

   // The other LEDs switch on/off when reset is off and the enable state is
   // on
   generate
      genvar led_index;

      for (led_index = 3; led_index < `LED_COUNT;
            led_index = led_index + 1) begin: each_following_led
         assign led[led_index] = reset_n & enable;
      end
   endgenerate

   /*
    * Fourteen-segment display controller (Input)
    */

   wire [(`ASCII_BIT_WIDTH - 1):0] char [0:(`FSD_DIGIT_COUNT - 1)];

   generate
      genvar fsd_char_index;

      for (fsd_char_index = 0; fsd_char_index < `FSD_DIGIT_COUNT;
            fsd_char_index = fsd_char_index + 1) begin: each_fsd_char
         assign fsd_chars[(fsd_char_index * `ASCII_BIT_WIDTH) +:
               `ASCII_BIT_WIDTH] = char[fsd_char_index];
      end
   endgenerate

   assign char[0] = kb_char;
   assign char[1] = kb_char;
   assign char[2] = kb_char;
   assign char[3] = kb_char;

   /*
    * LCD controller (Input)
    */

   lcd_ctrl lcd_ctrl(
      .data(lcd_data_write),
      .start_line(lcd_start_line_write),
      .addr_y(lcd_addr_y),
      .addr_x(lcd_addr_x),
      .data_action(lcd_data_action),
      .data_busy(lcd_data_busy),

      .instr_busy(lcd_instr_busy),
      .clk_ctrl(clk_lcd_ctrl),
      .reset_n(reset_n)
      );

   /*
    * Audio controller (Synthesizer) (Input)
    */

   audio_synth_ctrl audio_synth_ctrl(
      .vol(audio_vol),

      .kb_char(kb_char),
      .enable(enable),
      .clk_audio_vol(clk_audio_vol),
      .reset_n(reset_n)
      );

   /*
    * Audio controller (File) (Input)
    */

//   wire audio_replay;
//
//   audio_file_ctrl audio_file_ctrl(
//      .vol(audio_vol),
//
//      .enable(enable),
//      .replay(audio_replay),
//      .clk_audio_vol(clk_audio_vol),
//      .reset_n(reset_n)
//      );
//
//   assign audio_replay = (| (~keys_onepulsed_n));

   /*
    * Keyboard controller (Input)
    */

   keyboard_ctrl kb_ctrl(
      .kb_char(kb_char),

      .keys(keys_debounced_n),
      .clk_ctrl(clk_pb_kb_db),
      .reset_n(reset_n)
      );

   /*
    * State controller (Input)
    */

   state_ctrl state_ctrl(
      .enable(enable),

      .src(pushbutton_onepulsed_n[1]),
      .clk_ctrl(clk_pb_kb_op),
      .reset_n(reset_n)
      );
endmodule
