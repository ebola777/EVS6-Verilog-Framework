`timescale 1ns / 1ps

`include "../directive/io.vh"
`include "../directive/audio.vh"

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 22:47:36 04/23/2015
// Design Name: Audio encoder.
// Module Name: audio_encoder
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Encode sample volume and output one bit data of a time.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module audio_encoder (
   // Bit data.
   output reg audio_data,
   // Channel signal.
   output reg audio_ws,

   // Input volume.
   input [(`AUDIO_BIT_WIDTH_VOLUME - 1):0] vol,
   // Clock signal.
   input clk_audio_bit,
   // Reset signal.
   input reset_n
   );

   reg [(`AUDIO_BIT_DEPTH - 1):0] bit_depth_index;

   wire [(`AUDIO_BIT_WIDTH_DATA - 1):0] vol_data;
   wire [(`AUDIO_BIT_WIDTH_DATA - 1):0] vol_data_shift;

   always @(posedge clk_audio_bit or negedge reset_n) begin
      if ((!reset_n)) begin
         audio_data <= 0;
         audio_ws <= 0;

         bit_depth_index <= 0;
      end
      else begin
         audio_data <= vol_data_shift[0];

         if (bit_depth_index == 1'b0) begin
            audio_ws <= (~audio_ws);
         end

         bit_depth_index <= bit_depth_index + 1'b1;
      end
   end

   assign vol_data_shift =
      (vol_data >> ((`AUDIO_BIT_WIDTH_DATA - 1) - bit_depth_index));

   assign vol_data[(`AUDIO_BIT_WIDTH_DATA - 1):(`AUDIO_BIT_WIDTH_VOLUME)] =
      2'b00;
   assign vol_data[(`AUDIO_BIT_WIDTH_VOLUME - 1):0] = vol;
endmodule
