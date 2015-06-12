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
`ifndef _frequency_vh_
`define _frequency_vh_

// The following equations are solved by Mathematica 8.

// Round[N[Solve[x*2/(4*10^7) == 1/60/4, {x}][[1, 1, 2]]]]
// (40 MHz, 60 Hz, 4 digits)
`define FREQUENCY_DIV_HALF_FSD_DIGIT 83333
// Ceiling[Log[2, %]]
`define FREQUENCY_DIV_HALF_FSD_DIGIT_BIT_WIDTH 17

// Subscript[f, s] := N[Solve[4*2/(4*10^7) == 1/(256*x), {x}][[1, 1, 2]]]
// N[Reduce[x*2/(4*10^7) >= (71 * 10^-9) &&
//    x*2/(4*10^7) <= (488 * 10^-9), {x}]]
// (System clock cycle time min 71 ns, max 488 ns, f_sys = 256 * f_s)
`define FREQUENCY_DIV_HALF_AUDIO_SYS 4
// Ceiling[Log[2, %]]
`define FREQUENCY_DIV_HALF_AUDIO_SYS_BIT_WIDTH 2

// N[Solve[x*2/(4*10^7) == 1/19531.3/2/8, {x}][[1, 1, 2]]]
// N[Reduce[x*2/(4*10^7) >= 1/(64*19531.3), {x}]]
// (19531.3 Hz, approx. 22.05 kHz, 2 channels, 8 bit data, f_bck <= 64 * f_s)
`define FREQUENCY_DIV_HALF_AUDIO_BIT 64
// Ceiling[Log[2, %]]
`define FREQUENCY_DIV_HALF_AUDIO_BIT_BIT_WIDTH 6

// N[Solve[x*2/(4*10^7) == 1/19531.3/2, {x}][[1, 1, 2]]]
// (19531.3 Hz, 2 channels)
// (Audio bit frequency multiplied by 8)
`define FREQUENCY_DIV_HALF_AUDIO_VOL 512
// Ceiling[Log[2, %]]
`define FREQUENCY_DIV_HALF_AUDIO_VOL_BIT_WIDTH 9

// Round[N[Solve[x*2/(4*10^7) == 1/30/6/4, {x}][[1, 1, 2]]]]
// (40 MHz, 30 Hz, 6 debounce length, 4 rows)
`define FREQUENCY_DIV_HALF_KEYBOARD_DECODING 27778
// Ceiling[Log[2, %]]
`define FREQUENCY_DIV_HALF_KEYBOARD_DECODING_BIT_WIDTH 15

// Round[N[Solve[x*2/(4*10^7) == 1/30/6, {x}][[1, 1, 2]]]]
// (40 MHz, 30 Hz, 6 debounce length)
`define FREQUENCY_DIV_HALF_PUSHBUTTON_KEYBOARD_DEBOUNCE 111111
// Ceiling[Log[2, %]]
`define FREQUENCY_DIV_HALF_PUSHBUTTON_KEYBOARD_DEBOUNCE_BIT_WIDTH 17

// Round[N[Solve[x*2/(4*10^7) == 1/30, {x}][[1, 1, 2]]]]
// (40 MHz, 30 Hz)
`define FREQUENCY_DIV_HALF_PUSHBUTTON_KEYBOARD_ONEPULSE 666667
// Ceiling[Log[2, %]]
`define FREQUENCY_DIV_HALF_PUSHBUTTON_KEYBOARD_ONEPULSE_BIT_WIDTH 20

// N[Solve[128*8*(3*7000 + x)*10^-9 == 1/30, {x}]]
// Subscript[t, cyc] = %[[1, 1, 2]]
// Round[N[Solve[x*2/(4*10^7) == Subscript[t, cyc]*10^-9, {x}][[1, 1, 2]]]]
// (128x8 addresses, 3(y, x, data) x LCD enable delay time
// + controller cycle time, 30 Hz)
`define FREQUENCY_DIV_HALF_LCD_CTRL 231
// Ceiling[Log[2, %]]
`define FREQUENCY_DIV_HALF_LCD_CTRL_BIT_WIDTH 8

`endif
