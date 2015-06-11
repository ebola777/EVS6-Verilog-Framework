`timescale 1ns / 1ps

`include "src/directive/io.vh"
`include "src/directive/lcd.vh"

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 23:37:56 05/27/2015
// Design Name: Test bench for LCD encoder.
// Module Name: lcd_encoder_test
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
module lcd_encoder_test;
   /*
    * Simulated external signals
    */

   reg clk_lcd;
   reg clk_ctrl;
   reg reset_n;

   /*
    * Test target signals
    */

   wire [(`LCD_DATA_BIT_WIDTH - 1):0] lcd_data;

   wire [(`LCD_COL_SELECT_COUNT - 1):0] lcd_cs;
   wire lcd_io;
   wire lcd_wr;
   wire lcd_en;
   wire lcd_reset_n;
   wire instr_busy;

   reg [(`LCD_DATA_BIT_WIDTH - 1):0] data_write;
   reg [(`LCD_ROW_COUNT_BIT_WIDTH - 1):0] start_line_write;
   reg [(`LCD_ADDR_Y_COUNT_BIT_WIDTH - 1):0] addr_y;
   reg [(`LCD_ADDR_X_COUNT_BIT_WIDTH - 1):0] addr_x;
   reg [(`LCD_DATA_ACTION_COUNT_BIT_WIDTH - 1):0] data_action;
   reg data_busy;

   /*
    * Expected output signals
    */

   reg [(`LCD_DATA_BIT_WIDTH - 1):0] expected_lcd_data;
   reg [(`LCD_COL_SELECT_COUNT - 1):0] expected_lcd_cs;
   reg expected_lcd_io;
   reg expected_lcd_wr;
   reg expected_lcd_reset_n;
   reg expected_instr_busy;

   /*
    * Test target internal signals.
    */

   reg [(`LCD_INSTR_ACTION_COUNT_BIT_WIDTH - 1):0] last_instr_action [0:1];

   /*
    * Controller signals
    */

   reg draw_finished;

   /*
    * Test purposes signals
    */

   reg pass;


   lcd_encoder lcd_encoder(
      .lcd_data(lcd_data),

      .lcd_cs(lcd_cs),
      .lcd_io(lcd_io),
      .lcd_wr(lcd_wr),
      .lcd_en(lcd_en),
      .lcd_reset_n(lcd_reset_n),
      .instr_busy(instr_busy),

      .data_write(data_write),
      .start_line_write(start_line_write),
      .addr_y(addr_y),
      .addr_x(addr_x),
      .data_action(data_action),
      .data_busy(data_busy),
      .clk_lcd(clk_lcd),
      .reset_n(reset_n)
      );

   /*
    * Sequential simulated external signals
    */
   initial begin
      pass = 1;

      clk_lcd = 1;
      clk_ctrl = 1;
      reset_n = 0;
      #1;
      reset_n = 1;
      #9;
   end

   /*
    * Sequential clock signal
    */
   always #12.5 clk_lcd = ~clk_lcd;
   always #125 clk_ctrl = ~clk_ctrl;

   /*
    * Simulated LCD controller
    */
   always @(posedge clk_ctrl or negedge reset_n) begin
      if ((!reset_n)) begin
         data_write <= 0;
         start_line_write <= 0;
         addr_y <= 127;
         addr_x <= 0;
         data_action <= `LCD_DATA_ACTION_WRITE_DATA;
         data_busy <= 1;

         draw_finished <= 0;
      end
      else begin
         if ((!instr_busy) && data_busy) begin
            if ((!draw_finished)) begin
               data_write <= (8'b1111_1111 >> ((addr_y + 1) % 8));
               start_line_write <= 0;
               addr_y <= addr_y + 1'b1;
               addr_x <= 0;
               data_action <= `LCD_DATA_ACTION_WRITE_DATA;

               if ((addr_y + 1) == 'd8) begin
                  draw_finished <= 1;
               end
            end
            else begin
               data_write <= 0;
               start_line_write <= start_line_write - 1'b1;
               addr_y <= 0;
               addr_x <= 0;
               data_action <= `LCD_DATA_ACTION_WRITE_DISPLAY_START_LINE;
            end

            data_busy <= 0;
         end
         else if (instr_busy) begin
            data_busy <= 1;
         end
      end
   end

   /*
    * Stop criteria
    */
   always @(*) begin
      if (start_line_write == (64 - 8)) begin
         finish();
      end
   end

   /*
    * Verifier
    */
   always @(posedge lcd_en or posedge instr_busy or negedge reset_n) begin
      if ((!reset_n)) begin
         last_instr_action[0] = `LCD_INSTR_ACTION_ENABLE_RESET;
         last_instr_action[1] = `LCD_INSTR_ACTION_ENABLE_RESET;
      end
      else begin
         last_instr_action[0] = last_instr_action[1];
         last_instr_action[1] = lcd_encoder.instr_action;

         case (last_instr_action[0])
         `LCD_INSTR_ACTION_ENABLE_RESET: begin
            expected_lcd_data = 0;
            expected_lcd_cs = (~0);
            expected_lcd_io = `LCD_INSTRUCTION;
            expected_lcd_wr = `LCD_WRITE;
            expected_lcd_reset_n = 0;
            expected_instr_busy = 1;
         end
         `LCD_INSTR_ACTION_DISABLE_RESET: begin
            expected_lcd_data = 0;
            expected_lcd_cs = (~0);
            expected_lcd_io = `LCD_INSTRUCTION;
            expected_lcd_wr = `LCD_WRITE;
            expected_lcd_reset_n = 1;
            expected_instr_busy = 1;
         end
         `LCD_INSTR_ACTION_WRITE_DISPLAY_ON: begin
            expected_lcd_data = {`LCD_DATA_PREFIX_WRITE_DISPLAY_ON, 1'b1};
            expected_lcd_cs = (~0);
            expected_lcd_io = `LCD_INSTRUCTION;
            expected_lcd_wr = `LCD_WRITE;
            expected_lcd_reset_n = 1;
            expected_instr_busy = 1;
         end
         `LCD_INSTR_ACTION_WRITE_Y_ADDRESS: begin
            expected_lcd_data =
               {`LCD_DATA_PREFIX_WRITE_Y_ADDRESS, addr_y[5:0]};
            expected_lcd_cs = (~0);
            expected_lcd_io = `LCD_INSTRUCTION;
            expected_lcd_wr = `LCD_WRITE;
            expected_lcd_reset_n = 1;
            expected_instr_busy = 1;
         end
         `LCD_INSTR_ACTION_WRITE_X_ADDRESS: begin
            expected_lcd_data =
               {`LCD_DATA_PREFIX_WRITE_X_ADDRESS, addr_x};
            expected_lcd_cs = (~0);
            expected_lcd_io = `LCD_INSTRUCTION;
            expected_lcd_wr = `LCD_WRITE;
            expected_lcd_reset_n = 1;
            expected_instr_busy = 1;
         end
         `LCD_INSTR_ACTION_WRITE_DISPLAY_START_LINE: begin
            expected_lcd_data =
               {`LCD_DATA_PREFIX_WRITE_DISPLAY_START_LINE, start_line_write};
            expected_lcd_cs = (~0);
            expected_lcd_io = `LCD_INSTRUCTION;
            expected_lcd_wr = `LCD_WRITE;
            expected_lcd_reset_n = 1;
            expected_instr_busy = 1;
         end
         `LCD_INSTR_ACTION_WRITE_DATA: begin
            expected_lcd_data = data_write;
            expected_lcd_cs = 2'b01;
            expected_lcd_io = `LCD_DATA;
            expected_lcd_wr = `LCD_WRITE;
            expected_lcd_reset_n = 1;
            expected_instr_busy = 1;
         end
         `LCD_INSTR_ACTION_NULL: begin
            // No need to change expected values.
         end
         default: begin
            $display("Unexpected LCD encoder instruction action %d.",
               last_instr_action[0]);
            fail();
         end
         endcase

         verify();
      end
   end

   task finish;
      begin
         if (pass) begin
            $display("OK. Test passed.");
         end
         else begin
            $display("ERROR. Please check errors.");
         end

         $finish;
      end
   endtask

   task verify;
      begin
         if (lcd_data !== expected_lcd_data ||
               lcd_cs !== expected_lcd_cs ||
               lcd_io !== expected_lcd_io ||
               lcd_wr !== expected_lcd_wr ||
               lcd_reset_n !== expected_lcd_reset_n ||
               instr_busy !== expected_instr_busy) begin
            print_errors();
         end
      end
   endtask

   task fail;
      begin
         pass = 0;
         finish();
      end
   endtask

   task print_errors;
      begin
         pass = 0;
         $display("@%0d Error:", $time);
         $display("Was: \t lcd_data = %b, lcd_cs = %b, lcd_io = %b, lcd_wr = %b, lcd_reset_n = %b, instr_busy = %b",
            lcd_data, lcd_cs, lcd_io, lcd_wr, lcd_reset_n, instr_busy);
         $display("Expected: \t lcd_data = %b, lcd_cs = %b, lcd_io = %b, lcd_wr = %b, lcd_reset_n = %b, instr_busy = %b",
            expected_lcd_data, expected_lcd_cs, expected_lcd_io, expected_lcd_wr, expected_lcd_reset_n, expected_instr_busy);
      end
   endtask
endmodule
