`timescale 1ns / 1ps

`include "../directive/io.vh"
`include "../directive/audio.vh"
`include "../directive/data_type.vh"

// Synthesizing amplitude depth
`define AMPLITUDE_DEPTH 5

// Synthesizing amplitude max value
`define AMPLITUDE_MAX 31

// Piano frequency cycle times
// Subscript[f, s] := 21929.8;
// Freq[n_] := 2^((n - 49)/12)*440;
// Round[Subscript[f, s]/N[Freq[{40, 42, 44, 45, 47, 49, 51}]]]
// Round[Subscript[f, s]/N[Freq[{52, 54, 56, 57, 59, 61, 63}]]]
// Round[Subscript[f, s]/N[Freq[{64, 66}]]]
`define CYCLE_TIME_C4 84
`define CYCLE_TIME_D4 75
`define CYCLE_TIME_E4 67
`define CYCLE_TIME_F4 63
`define CYCLE_TIME_G4 56
`define CYCLE_TIME_A4 50
`define CYCLE_TIME_B4 44
`define CYCLE_TIME_C5 42
`define CYCLE_TIME_D5 37
`define CYCLE_TIME_E5 33
`define CYCLE_TIME_F5 31
`define CYCLE_TIME_G5 28
`define CYCLE_TIME_A5 25
`define CYCLE_TIME_B5 22
`define CYCLE_TIME_C6 21
`define CYCLE_TIME_D6 19

// Max piano frequency cycle time bit width
`define CYCLE_TIME_MAX_BIT_WIDTH $clog2(`CYCLE_TIME_C4)

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 19:30:36 04/25/2015
// Design Name: Audio synthesizer controller.
// Module Name: audio_synth_ctrl
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Simple audio synthesizer which generates rectangle wave.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module audio_synth_ctrl (
   // Output volume.
   output reg [(`AUDIO_BIT_WIDTH_VOLUME - 1):0] vol,

   // Pressed key character.
   input [(`ASCII_BIT_WIDTH - 1):0] kb_char,
   // Enable switch.
   input enable,
   // Clock signal for controller.
   input clk_audio_vol,
   // Reset signal.
   input reset_n
   );

   // Corresponding volume to amplitude.
   reg [(`AUDIO_BIT_WIDTH_VOLUME - 1):0] next_vol;

   // Amplitude stored as integer, which represents floating-point number
   // x/(2^AMPLITUDE_DEPTH), ranging from
   // 0.0 to (2^AMPLITUDE_DEPTH - 1)/(2^AMPLITUDE_DEPTH).
   reg [(`AMPLITUDE_DEPTH - 1):0] amp;
   // Wave index, which represents time x/(CYCLE_TIME) in one cycle,
   // raning from 0.0 to 1.0.
   reg [(`CYCLE_TIME_MAX_BIT_WIDTH - 1):0] wave_index;
   // Wave cycle time, which caps wave index.
   reg [(`CYCLE_TIME_MAX_BIT_WIDTH - 1):0] wave_cycle_time;

   always @(posedge clk_audio_vol or negedge reset_n) begin
      if ((!reset_n)) begin
         vol <= `AUDIO_INITIAL_VOLUME;

         wave_index <= 0;
      end
      else begin
         if ((!enable)) begin
            vol <= `AUDIO_INITIAL_VOLUME;

            wave_index <= 0;
         end
         else begin
            vol <= next_vol;

            if (wave_index < wave_cycle_time) begin
               wave_index <= wave_index + 1'b1;
            end
            else begin
               wave_index <= 0;
            end
         end
      end
   end

   // Map pressed key to wave cycle time
   always @(kb_char) begin
      case (kb_char)
      "F": wave_cycle_time <= `CYCLE_TIME_D6;
      "B": wave_cycle_time <= `CYCLE_TIME_C6;
      "A": wave_cycle_time <= `CYCLE_TIME_B5;
      "0": wave_cycle_time <= `CYCLE_TIME_A5;

      "E": wave_cycle_time <= `CYCLE_TIME_G5;
      "3": wave_cycle_time <= `CYCLE_TIME_F5;
      "2": wave_cycle_time <= `CYCLE_TIME_E5;
      "1": wave_cycle_time <= `CYCLE_TIME_D5;

      "D": wave_cycle_time <= `CYCLE_TIME_C5;
      "6": wave_cycle_time <= `CYCLE_TIME_B4;
      "5": wave_cycle_time <= `CYCLE_TIME_A4;
      "4": wave_cycle_time <= `CYCLE_TIME_G4;

      "C": wave_cycle_time <= `CYCLE_TIME_F4;
      "9": wave_cycle_time <= `CYCLE_TIME_E4;
      "8": wave_cycle_time <= `CYCLE_TIME_D4;
      "7": wave_cycle_time <= `CYCLE_TIME_C4;

      default: wave_cycle_time <= 0;
      endcase
   end

   // Map wave index to amplitude
   always @(*) begin
      if (wave_cycle_time != 0) begin
         // Rectangle wave
         if (wave_index == 0) begin
            amp <= (`AMPLITUDE_MAX >> 1);
         end
         else if (wave_index < (wave_cycle_time >> 1)) begin
            amp <= `AMPLITUDE_MAX;
         end
         else if (wave_index == (wave_cycle_time >> 1)) begin
            amp <= (`AMPLITUDE_MAX >> 1);
         end
         else if (wave_index < wave_cycle_time - 1) begin
            amp <= 0;
         end
         else begin
            amp <= (`AMPLITUDE_MAX >> 1);
         end
      end
      else begin
         // Default amplitude
         amp <= `AMPLITUDE_MAX;
      end
   end

   // Map amplitude to volume
   always @(amp) begin
      // Decibel[amp_] := 20*Log[10, amp];
      // amplitudeDepth := 5;
      // For[i = 2^amplitudeDepth - 1, i >= 0, --i,
      //   Print[{i, Round[Decibel[i/2^amplitudeDepth]]}]];
      case (amp)
      31: next_vol <= 'b00_0000; // 0
      30: next_vol <= 'b00_0010; // -1
      29: next_vol <= 'b00_0010;
      28: next_vol <= 'b00_0010;
      27: next_vol <= 'b00_0010;
      26: next_vol <= 'b00_0011; // -2
      25: next_vol <= 'b00_0011;
      24: next_vol <= 'b00_0011;
      23: next_vol <= 'b00_0100; // -3
      22: next_vol <= 'b00_0100;
      21: next_vol <= 'b00_0101; // -4
      20: next_vol <= 'b00_0101;
      19: next_vol <= 'b00_0110; // -5
      18: next_vol <= 'b00_0110;
      17: next_vol <= 'b00_0110;
      16: next_vol <= 'b00_0111; // -6
      15: next_vol <= 'b00_1000; // -7
      14: next_vol <= 'b00_1000;
      13: next_vol <= 'b00_1001; // -8
      12: next_vol <= 'b00_1010; // -9
      11: next_vol <= 'b00_1010;
      10: next_vol <= 'b00_1011; // -10
      9: next_vol <= 'b00_1100; // -11
      8: next_vol <= 'b00_1101; // -12
      7: next_vol <= 'b00_1110; // -13
      6: next_vol <= 'b01_0000; // -15
      5: next_vol <= 'b01_0001; // -16
      4: next_vol <= 'b01_0011; // -18
      3: next_vol <= 'b01_0110; // -21
      2: next_vol <= 'b01_1000; // -24
      1: next_vol <= 'b01_1110; // -30
      0: next_vol <= 'b11_1110; // -Infinity
      default: next_vol <= 'b11_1110; // -Infinity
      endcase
   end
endmodule
