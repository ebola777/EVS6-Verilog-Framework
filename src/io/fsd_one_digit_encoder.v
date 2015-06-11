`timescale 1ns / 1ps

`include "../directive/io.vh"
`include "../directive/data_type.vh"
`include "../directive/characters.vh"

///////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer: Shawn Chang (ebola777@yahoo.com.tw)
//
// Create Date: 18:37:26 03/31/2015
// Design Name: Fourteen-segment display (FSD) ASCII to segment encoder.
// Module Name: fsd_one_digit_encoder
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//    Encode one ASCII character to one FSD digit segment map.
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
///////////////////////////////////////////////////////////////////////////////
module fsd_one_digit_encoder (
   // Segment map.
   output reg [(`FSD_SEGMENT_COUNT - 2):0] seg,

   // ASCII code.
   input [(`ASCII_BIT_WIDTH - 1):0] char
   );

   always @(char) begin
      case (char)
      "": seg <= 14'b00_0000_0000_0000; // (Filled)
      " ": seg <= 14'b11_1111_1111_1111; // SPACE (Blank)
      "!": seg <= 14'b11_1111_1100_1111; // EXCLAMATION MARK
      "\"": seg <= 14'b11_1111_1111_1111; // QUOTATION MARK (Blank)
      "#": seg <= 14'b10_1101_0011_0001; // NUMBER SIGN
      "$": seg <= 14'b10_1101_0001_0010; // DOLLAR SIGN
      "%": seg <= 14'b11_0011_1101_1011; // PERCENT SIGN
      "&": seg <= 14'b01_1010_1010_0110; // AMPERSAND
      "'": seg <= 14'b11_1101_1111_1111; // APOSTROPHE
      "(": seg <= 14'b11_1111_1100_0110; // LEFT PARENTHESIS
      ")": seg <= 14'b11_1111_1111_0000; // RIGHT PARENTHESIS
      "*": seg <= 14'b00_0000_1111_1111; // ASTERISK
      "+": seg <= 14'b10_1101_0011_1111; // PLUS SIGN
      ",": seg <= 14'b11_0111_1111_1111; // COMMA
      "-": seg <= 14'b11_1111_0011_1111; // HYPHEN-MINUS
      ".": seg <= 14'b01_1111_1111_1111; // FULL STOP
      "/": seg <= 14'b11_0011_1111_1111; // SOLIDUS
      "0": seg <= 14'b11_1111_1100_0000; // DIGIT ZERO
      "1": seg <= 14'b11_1011_1111_1001; // DIGIT ONE
      "2": seg <= 14'b11_1111_0010_0100; // DIGIT TWO
      "3": seg <= 14'b11_1111_0111_0000; // DIGIT THREE
      "4": seg <= 14'b11_1111_0001_1001; // DIGIT FOUR
      "5": seg <= 14'b11_1111_0001_0010; // DIGIT FIVE
      "6": seg <= 14'b11_1111_0000_0010; // DIGIT SIX
      "7": seg <= 14'b10_1011_1111_1110; // DIGIT SEVEN
      "8": seg <= 14'b11_1111_0000_0000; // DIGIT EIGHT
      "9": seg <= 14'b11_1111_0001_1000; // DIGIT NINE
      ":": seg <= 14'b10_1101_1111_1111; // COLON
      ";": seg <= 14'b11_0101_1111_1111; // SEMICOLON
      "<": seg <= 14'b01_1011_1111_1111; // LESS-THAN SIGN
      "=": seg <= 14'b11_1111_0011_0111; // EQUALS SIGN
      ">": seg <= 14'b11_0110_1111_1111; // GREATER-THAN SIGN
      "?": seg <= 14'b10_1011_1101_1110; // QUESTION MARK
      "@": seg <= 14'b01_0010_1100_0000; // COMMERCIAL AT
      "A": seg <= 14'b11_1111_0000_1000; // LATIN CAPITAL LETTER A
      "B": seg <= 14'b10_1101_0111_0000; // LATIN CAPITAL LETTER B
      "C": seg <= 14'b11_1111_1100_0110; // LATIN CAPITAL LETTER C
      "D": seg <= 14'b10_1101_1111_0000; // LATIN CAPITAL LETTER D
      "E": seg <= 14'b11_1111_0000_0110; // LATIN CAPITAL LETTER E
      "F": seg <= 14'b11_1111_0000_1110; // LATIN CAPITAL LETTER F
      "G": seg <= 14'b11_1111_0100_0010; // LATIN CAPITAL LETTER G
      "H": seg <= 14'b11_1111_0000_1001; // LATIN CAPITAL LETTER H
      "I": seg <= 14'b10_1101_1111_0110; // LATIN CAPITAL LETTER I
      "J": seg <= 14'b11_1111_1110_0001; // LATIN CAPITAL LETTER J
      "K": seg <= 14'b01_1011_1000_1111; // LATIN CAPITAL LETTER K
      "L": seg <= 14'b11_1111_1100_0111; // LATIN CAPITAL LETTER L
      "M": seg <= 14'b11_1010_1100_1001; // LATIN CAPITAL LETTER M
      "N": seg <= 14'b01_1110_1100_1001; // LATIN CAPITAL LETTER N
      "O": seg <= 14'b11_1111_1100_0000; // LATIN CAPITAL LETTER O
      "P": seg <= 14'b11_1111_0000_1100; // LATIN CAPITAL LETTER P
      "Q": seg <= 14'b01_1111_1100_0000; // LATIN CAPITAL LETTER Q
      "R": seg <= 14'b01_1111_0000_1100; // LATIN CAPITAL LETTER R
      "S": seg <= 14'b11_1110_0111_0010; // LATIN CAPITAL LETTER S
      "T": seg <= 14'b10_1101_1111_1110; // LATIN CAPITAL LETTER T
      "U": seg <= 14'b11_1111_1100_0001; // LATIN CAPITAL LETTER U
      "V": seg <= 14'b11_0011_1100_1111; // LATIN CAPITAL LETTER V
      "W": seg <= 14'b01_0111_1100_1001; // LATIN CAPITAL LETTER W
      "X": seg <= 14'b01_0010_1111_1111; // LATIN CAPITAL LETTER X
      "Y": seg <= 14'b10_1010_1111_1111; // LATIN CAPITAL LETTER Y
      "Z": seg <= 14'b11_0011_1111_0110; // LATIN CAPITAL LETTER Z
      "[": seg <= 14'b11_1111_1100_0110; // LEFT SQUARE BRACKET
      "\\": seg <= 14'b01_1110_1111_1111; // REVERSE SOLIDUS
      "]": seg <= 14'b11_1111_1111_0000; // RIGHT SQUARE BRACKET
      "^": seg <= 14'b11_1111_1101_1100; // CIRCUMFLEX ACCENT
      "_": seg <= 14'b11_1111_1111_0111; // LOW LINE
      "`": seg <= 14'b11_1110_1111_1111; // GRAVE ACCENT
      "a": seg <= 14'b11_1111_0010_0000; // LATIN SMALL LETTER A
      "b": seg <= 14'b01_1111_1000_0111; // LATIN SMALL LETTER B
      "c": seg <= 14'b11_1111_0010_0111; // LATIN SMALL LETTER C
      "d": seg <= 14'b11_0111_0111_0001; // LATIN SMALL LETTER D
      "e": seg <= 14'b11_1111_1000_0110; // LATIN SMALL LETTER E
      "f": seg <= 14'b11_1111_1000_1110; // LATIN SMALL LETTER F
      "g": seg <= 14'b11_1110_0111_0000; // LATIN SMALL LETTER G
      "h": seg <= 14'b11_1111_0000_1011; // LATIN SMALL LETTER H
      "i": seg <= 14'b10_1111_1111_1111; // LATIN SMALL LETTER I
      "j": seg <= 14'b11_1111_1111_0001; // LATIN SMALL LETTER J
      "k": seg <= 14'b00_1001_1111_1111; // LATIN SMALL LETTER K
      "l": seg <= 14'b10_1101_1111_1111; // LATIN SMALL LETTER L
      "m": seg <= 14'b10_1111_0010_1011; // LATIN SMALL LETTER M
      "n": seg <= 14'b01_1111_1010_1111; // LATIN SMALL LETTER N
      "o": seg <= 14'b11_1111_0010_0011; // LATIN SMALL LETTER O
      "p": seg <= 14'b11_1011_1000_1110; // LATIN SMALL LETTER P
      "q": seg <= 14'b01_1111_0001_1100; // LATIN SMALL LETTER Q
      "r": seg <= 14'b11_1111_1010_1111; // LATIN SMALL LETTER R
      "s": seg <= 14'b11_1110_0111_0010; // LATIN SMALL LETTER S
      "t": seg <= 14'b11_1111_1000_0111; // LATIN SMALL LETTER T
      "u": seg <= 14'b11_1111_1110_0011; // LATIN SMALL LETTER U
      "v": seg <= 14'b11_0111_1110_1111; // LATIN SMALL LETTER V
      "w": seg <= 14'b01_0111_1110_1011; // LATIN SMALL LETTER W
      "x": seg <= 14'b01_0010_1111_1111; // LATIN SMALL LETTER X
      "y": seg <= 14'b11_1101_0111_0001; // LATIN SMALL LETTER Y
      "z": seg <= 14'b11_0011_1111_0110; // LATIN SMALL LETTER Z
      "{": seg <= 14'b11_0110_1011_0110; // LEFT CURLY BRACKET
      "|": seg <= 14'b10_1101_1111_1111; // VERTICAL LINE
      "}": seg <= 14'b01_1011_0111_0110; // RIGHT CURLY BRACKET
      "~": seg <= 14'b11_1111_0011_1111; // TILDE
      `CHAR_FILLED: seg <= 14'b00_0000_0000_0000; // (Filled)
      `CHAR_SPACE: seg <= 14'b11_1111_1111_1111; // SPACE (Blank)
      default: seg <= 14'b11_1111_1111_1111; // (Blank)
      endcase
   end
endmodule
