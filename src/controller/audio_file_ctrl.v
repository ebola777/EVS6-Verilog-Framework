`timescale 1ns / 1ps

`include "../directive/io.vh"
`include "../directive/audio.vh"

// Sample data file
`define SAMPLE_FILE "../../data/c4_click.bin"
// Sample data count
`define SAMPLE_COUNT 5532
// Sample data count bit width
`define SAMPLE_COUNT_BIT_WIDTH $clog2(`SAMPLE_COUNT)

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 22:40:25 04/23/2015
// Design Name: Audio file controller.
// Module Name: audio_file_ctrl
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Output single audio sample data as buffer for audio encoder.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module audio_file_ctrl (
   // Output volume.
   output reg [(`AUDIO_BIT_WIDTH_VOLUME - 1):0] vol,

   // Enable switch.
   input enable,
   // Replay signal.
   input replay,
   // Clock signal for controller.
   input clk_audio_vol,
   // Reset signal.
   input reset_n
   );

   reg [(`AUDIO_BIT_WIDTH_VOLUME - 1):0] audio_file [0:(`SAMPLE_COUNT - 1)];

   reg [(`SAMPLE_COUNT_BIT_WIDTH - 1):0] index;

   initial begin
      $readmemb(`SAMPLE_FILE, audio_file);
   end

   always @(posedge clk_audio_vol or negedge reset_n) begin
      if ((!reset_n)) begin
         vol <= `AUDIO_INITIAL_VOLUME;

         index <= `SAMPLE_COUNT;
      end
      else begin
         if ((!enable)) begin
            vol <= `AUDIO_INITIAL_VOLUME;

            index <= `SAMPLE_COUNT;
         end
         else begin
            // Replay is set
            if (replay) begin
               index <= 0;
            end
            // Has finished playing
            else if (index == `SAMPLE_COUNT) begin
               vol <= `AUDIO_INITIAL_VOLUME;
            end
            // Play
            else begin
               vol <= audio_file[index];

               index <= index + 1'b1;
            end
         end
      end
   end
endmodule
