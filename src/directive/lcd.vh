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
`ifndef _lcd_vh_
`define _lcd_vh_

/*
 * Signal
 */

`define LCD_INSTRUCTION 1'b0
`define LCD_DATA 1'b1

`define LCD_WRITE 1'b0
`define LCD_READ 1'b1

`define LCD_DATA_INDEX_RESET 4
`define LCD_DATA_INDEX_DISPLAY_SWITCH 5
`define LCD_DATA_INDEX_BUSY 7

`define LCD_DATA_PREFIX_WRITE_DISPLAY_ON 7'b001_1111
`define LCD_DATA_PREFIX_WRITE_Y_ADDRESS 2'b01
`define LCD_DATA_PREFIX_WRITE_X_ADDRESS 5'b1_0111
`define LCD_DATA_PREFIX_WRITE_DISPLAY_START_LINE 2'b11

/*
 * State
 */

// Instruction actions
`define LCD_INSTR_ACTION_ENABLE_RESET 0
`define LCD_INSTR_ACTION_DISABLE_RESET 1
`define LCD_INSTR_ACTION_WRITE_DISPLAY_ON 2
`define LCD_INSTR_ACTION_WRITE_Y_ADDRESS 3
`define LCD_INSTR_ACTION_WRITE_X_ADDRESS 4
`define LCD_INSTR_ACTION_WRITE_DISPLAY_START_LINE 5
`define LCD_INSTR_ACTION_WRITE_DATA 6
`define LCD_INSTR_ACTION_NULL 7

// Data actions
`define LCD_DATA_ACTION_WRITE_DATA 0
`define LCD_DATA_ACTION_WRITE_DISPLAY_START_LINE 1

`define LCD_INSTR_ACTION_COUNT_BIT_WIDTH 3
`define LCD_DATA_ACTION_COUNT_BIT_WIDTH 1

/*
 * Delay
 */

// Ceiling[7000/25] - 1
// (Delay divided by LCD encoder clock cycle time)
// (Guessing: Enable signal must hold for long enough so that LCD driver
// register won't go to meta-stability state.)
// (Discovery: 6475ns is the critical value, it would not function properly
// if the value is less than it.)
`define LCD_DELAY_ENABLE 279
// Ceiling[200/25] - 1
// (Delay divided by LCD encoder clock cycle time)
// (Discovery: It must wait long enough to make sure display is set on
// properly, otherwise it won't turn on.)
// (Discovery: 100ns is the critical value, it would not function properly
// if the value is less than it.)
`define LCD_DELAY_WRITE_DISPLAY_ON 7

// Ceiling[Log[2, 279 + 1]]
`define LCD_DELAY_ENABLE_BIT_WIDTH 9
// Ceiling[Log[2, 7 + 1]]
`define LCD_DELAY_WRITE_DISPLAY_ON_BIT_WIDTH 3

`endif
