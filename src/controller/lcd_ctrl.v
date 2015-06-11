`timescale 1ns / 1ps

`include "../directive/io.vh"
`include "../directive/lcd.vh"

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 15:21:17 04/28/2015
// Design Name: LCD controller.
// Module Name: lcd_ctrl
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
module lcd_ctrl (
   output reg [(`LCD_DATA_BIT_WIDTH - 1):0] data,
   output reg [(`LCD_ROW_COUNT_BIT_WIDTH - 1):0] start_line,
   output reg [(`LCD_ADDR_Y_COUNT_BIT_WIDTH - 1):0] addr_y,
   output reg [(`LCD_ADDR_X_COUNT_BIT_WIDTH - 1):0] addr_x,
   output reg [(`LCD_DATA_ACTION_COUNT_BIT_WIDTH - 1):0] data_action,
   output reg data_busy,

   input instr_busy,
   input clk_ctrl,
   input reset_n
   );

   reg [(12 - 1):0] delay_counter;
   reg draw_finished;

   always @(posedge clk_ctrl or negedge reset_n) begin
      if ((!reset_n)) begin
         data <= 0;
         start_line <= 0;
         addr_y <= 0;
         addr_x <= 0;
         data_action <= `LCD_DATA_ACTION_WRITE_DATA;
         data_busy <= 1;

         delay_counter <= 0;
         draw_finished <= 0;
      end
      else begin
         // Wait for instruction is ready.
         if ((!instr_busy) && data_busy) begin
            if ((!draw_finished)) begin
               // Draw right triangle of width and height 8.
               data <= (8'b1111_1111 >> ((addr_y + 1) % 8));

               addr_y <= addr_y + 1'b1;

               if (addr_y + 1 == `LCD_ADDR_Y_COUNT) begin
                  addr_x <= addr_x + 1'b1;

                  if (addr_x + 1 == `LCD_ADDR_X_COUNT) begin
                     draw_finished <= 1;
                  end
               end

               data_action <= `LCD_DATA_ACTION_WRITE_DATA;
            end
            else begin
               if (delay_counter != (2 ** 12 - 1)) begin
                  delay_counter <= delay_counter + 1'b1;
               end
               else begin
                  start_line <= start_line + 1'b1;

                  data_action <= `LCD_DATA_ACTION_WRITE_DISPLAY_START_LINE;

                  delay_counter <= 0;
               end
            end

            data_busy <= 0;
         end
         else if (instr_busy) begin
            data_busy <= 1;
         end
      end
   end
endmodule
