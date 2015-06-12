///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 20:01:00 04/07/2015
// Design Name:
// Module Name:
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
`ifndef _io_vh_
`define _io_vh_

// LED
`define LED_COUNT 16

// Fourteen-segment display
`define FSD_SEGMENT_COUNT 15
`define FSD_DIGIT_COUNT 4

`define FSD_DIGIT_COUNT_BIT_WIDTH 2

// LCD
`define LCD_DATA_BIT_WIDTH 8
`define LCD_COL_SELECT_COUNT 2
`define LCD_ADDR_Y_COUNT 128
`define LCD_ADDR_X_COUNT 8
`define LCD_DRIVER_ADDR_Y_COUNT 64
`define LCD_COL_COUNT `LCD_ADDR_Y_COUNT
`define LCD_ROW_COUNT (`LCD_ADDR_X_COUNT * `LCD_DATA_BIT_WIDTH)

`define LCD_DATA_BIT_WIDTH_BIT_WIDTH 3
`define LCD_COL_SELECT_COUNT_BIT_WIDTH 1
`define LCD_ADDR_Y_COUNT_BIT_WIDTH 7
`define LCD_ADDR_X_COUNT_BIT_WIDTH 3
`define LCD_DRIVER_ADDR_Y_COUNT_BIT_WIDTH 6
`define LCD_COL_COUNT_BIT_WIDTH 7
`define LCD_ROW_COUNT_BIT_WIDTH 6

// Audio
`define AUDIO_BIT_WIDTH_DATA 8

`define AUDIO_BIT_DEPTH 3

// Keyboard
`define KEYBOARD_COL_COUNT 4
`define KEYBOARD_ROW_COUNT 4
`define KEYBOARD_COUNT (`KEYBOARD_COL_COUNT * `KEYBOARD_ROW_COUNT)

`define KEYBOARD_ROW_COUNT_BIT_WIDTH 2

// DIP switch
`define DIP_COUNT 8

// Push-button
`define PUSHBUTTON_COUNT 8

`endif
