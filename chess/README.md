## Chess

Extremely concise chess code, for play in the command line. Virtually every element that could be DRYed (Don't Repeat Yourself) out, has been.

![Screenshot]
(https://41.media.tumblr.com/b36393c2ab17fbb7a0b7749a8abbaabe/tumblr_inline_nm5wvhf5kI1rnczy0_400.png)

## Instructions

- Clone repo locally and `bundle install`
- Run `ruby play_chess.rb` from the terminal while in the project directory

## Object Oriented Implementation

- Sliding piece and stepping piece modules mixed-in to DRY up shared methods
- Individual pieces classes (e.g. Queen) inherit from Piece superclass

## Move Validation

- Creates a deep dup of the board and tests validity of moves, for both feasibility and whether or not a move leaves a player's king in check

## Outside Gems

- [Colorize](https://github.com/fazibear/colorize) gem adds color to rendered string output
