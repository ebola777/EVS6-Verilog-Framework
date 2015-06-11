`timescale 1ns / 1ps

`include "../directive/io.vh"
`include "../directive/lcd.vh"

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 22:37:40 05/09/2015
// Design Name: LCD encoder.
// Module Name: lcd_encoder
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
module lcd_encoder (
   inout [(`LCD_DATA_BIT_WIDTH - 1):0] lcd_data,

   output reg [(`LCD_COL_SELECT_COUNT - 1):0] lcd_cs,
   output reg lcd_io,
   output reg lcd_wr,
   output reg lcd_en,
   output reg lcd_reset_n,
   output reg instr_busy,

   input [(`LCD_DATA_BIT_WIDTH - 1):0] data_write,
   input [(`LCD_ROW_COUNT_BIT_WIDTH - 1):0] start_line_write,
   input [(`LCD_ADDR_Y_COUNT_BIT_WIDTH - 1):0] addr_y,
   input [(`LCD_ADDR_X_COUNT_BIT_WIDTH - 1):0] addr_x,
   input [(`LCD_DATA_ACTION_COUNT_BIT_WIDTH - 1):0] data_action,
   input data_busy,
   input clk_lcd,
   input reset_n
   );

   // Data
   reg [(`LCD_DATA_BIT_WIDTH - 1):0] lcd_data_out;
   // State
   reg [(`LCD_INSTR_ACTION_COUNT_BIT_WIDTH - 1):0] instr_action;
   // Delay
   reg [(`LCD_DELAY_ENABLE_BIT_WIDTH - 1):0] en_delay;
   reg [(`LCD_DELAY_WRITE_DISPLAY_ON_BIT_WIDTH - 1):0] set_display_on_delay;

   wire [(`LCD_DRIVER_ADDR_Y_COUNT_BIT_WIDTH - 1):0] driver_addr_y;
   wire [(`LCD_COL_SELECT_COUNT_BIT_WIDTH - 1):0] addr_y_cs;
   wire [(`LCD_COL_SELECT_COUNT - 1):0] next_lcd_cs;

   always @(posedge clk_lcd or negedge reset_n) begin
      if ((!reset_n)) begin
         // Set data to make sure write is not ready in the beginning.
         lcd_data_out <= 0;
         lcd_cs <= (~0);
         lcd_io <= `LCD_INSTRUCTION;
         lcd_wr <= `LCD_WRITE;
         lcd_en <= 0;
         // Reset LCD.
         lcd_reset_n <= 0;
         // Inform busy.
         instr_busy <= 1;

         // Set to disabling resetting LCD state.
         instr_action <= `LCD_INSTR_ACTION_ENABLE_RESET;
         // Reset delays to 0.
         en_delay <= 0;
         set_display_on_delay <= 0;
      end
      else begin
         if (lcd_en) begin
            /*
             * Disable enable signal.
             */

            if (en_delay == `LCD_DELAY_ENABLE) begin
               lcd_en <= 0;

               en_delay <= 0;
            end
            else begin
               en_delay <= en_delay + 1'b1;
            end
         end
         else begin
            /*
             * Decide signals.
             */

            case (instr_action)
            `LCD_INSTR_ACTION_ENABLE_RESET: begin
               // Enable resetting LCD.
               lcd_reset_n <= 0;
               lcd_en <= 1;
            end
            `LCD_INSTR_ACTION_DISABLE_RESET: begin
               // Disable resetting LCD.
               lcd_reset_n <= 1;
               lcd_en <= 1;
            end
            `LCD_INSTR_ACTION_WRITE_DISPLAY_ON: begin
               // Set display on.
               lcd_data_out <= {`LCD_DATA_PREFIX_WRITE_DISPLAY_ON, 1'b1};
               lcd_io <= `LCD_INSTRUCTION;
               lcd_wr <= `LCD_WRITE;
               lcd_en <= 1;
            end
            `LCD_INSTR_ACTION_WRITE_Y_ADDRESS: begin
               // Write Y address.
               lcd_data_out <= {`LCD_DATA_PREFIX_WRITE_Y_ADDRESS,
                  driver_addr_y};
               lcd_cs <= (~0);
               lcd_io <= `LCD_INSTRUCTION;
               lcd_wr <= `LCD_WRITE;
               lcd_en <= 1;
            end
            `LCD_INSTR_ACTION_WRITE_X_ADDRESS: begin
               // Write X address.
               lcd_data_out <= {`LCD_DATA_PREFIX_WRITE_X_ADDRESS, addr_x};
               lcd_cs <= (~0);
               lcd_io <= `LCD_INSTRUCTION;
               lcd_wr <= `LCD_WRITE;
               lcd_en <= 1;
            end
            `LCD_INSTR_ACTION_WRITE_DISPLAY_START_LINE: begin
               // Write display start line.
               lcd_data_out <= {`LCD_DATA_PREFIX_WRITE_DISPLAY_START_LINE,
                  start_line_write};
               lcd_cs <= (~0);
               lcd_io <= `LCD_INSTRUCTION;
               lcd_wr <= `LCD_WRITE;
               lcd_en <= 1;
            end
            `LCD_INSTR_ACTION_WRITE_DATA: begin
               // Write data.
               lcd_data_out <= data_write;
               lcd_cs <= next_lcd_cs;
               lcd_io <= `LCD_DATA;
               lcd_wr <= `LCD_WRITE;
               lcd_en <= 1;
            end
            `LCD_INSTR_ACTION_NULL: begin
               // Do nothing.
               lcd_en <= 0;
            end
            endcase

            /*
             * Decide next instruction action and busy signal.
             */

            case (instr_action)
            `LCD_INSTR_ACTION_ENABLE_RESET: begin
               instr_action <= `LCD_INSTR_ACTION_DISABLE_RESET;
            end
            `LCD_INSTR_ACTION_DISABLE_RESET: begin
               instr_action <= `LCD_INSTR_ACTION_WRITE_DISPLAY_ON;
            end
            `LCD_INSTR_ACTION_WRITE_DISPLAY_ON: begin
               if (set_display_on_delay == `LCD_DELAY_WRITE_DISPLAY_ON) begin
                  instr_action <= `LCD_INSTR_ACTION_NULL;

                  set_display_on_delay <= 0;
               end
               else begin
                  set_display_on_delay <= set_display_on_delay + 1'b1;
               end
            end
            `LCD_INSTR_ACTION_WRITE_Y_ADDRESS: begin
               instr_action <= `LCD_INSTR_ACTION_WRITE_X_ADDRESS;
            end
            `LCD_INSTR_ACTION_WRITE_X_ADDRESS: begin
               instr_action <= `LCD_INSTR_ACTION_WRITE_DATA;
            end
            `LCD_INSTR_ACTION_WRITE_DATA: begin
               instr_action <= `LCD_INSTR_ACTION_NULL;
            end
            `LCD_INSTR_ACTION_WRITE_DISPLAY_START_LINE: begin
               instr_action <= `LCD_INSTR_ACTION_NULL;
            end
            `LCD_INSTR_ACTION_NULL: begin
               // Wait for data is ready.
               if ((!data_busy) && (!instr_busy)) begin
                  if (data_action == `LCD_DATA_ACTION_WRITE_DATA) begin
                     instr_action <= `LCD_INSTR_ACTION_WRITE_Y_ADDRESS;
                  end
                  else if (data_action ==
                        `LCD_DATA_ACTION_WRITE_DISPLAY_START_LINE) begin
                     instr_action <=
                        `LCD_INSTR_ACTION_WRITE_DISPLAY_START_LINE;
                  end

                  instr_busy <= 1;
               end
               else if (data_busy) begin
                  instr_busy <= 0;
               end
            end
            endcase
         end
      end
   end

   // LCD data.
   assign lcd_data = (lcd_wr != `LCD_READ ? lcd_data_out : 1'bz);

   // Y address for a single driver.
   assign driver_addr_y =
      addr_y[(`LCD_DRIVER_ADDR_Y_COUNT_BIT_WIDTH - 1):0];
   // Column select index from Y address leftmost bits.
   assign addr_y_cs = (addr_y>>
      (`LCD_ADDR_Y_COUNT_BIT_WIDTH - `LCD_COL_SELECT_COUNT + 1));
   // Encoded column select signals from column select index.
   assign next_lcd_cs =
      ~(1'b1 << ((`LCD_COL_SELECT_COUNT - 1) - addr_y_cs));
endmodule
