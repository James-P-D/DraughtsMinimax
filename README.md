# DraughtsMinimax
A Processing implementation of Draughts (Checkers) using Minimax

![Screenshot](https://github.com/James-P-D/DraughtsMinimax/blob/master/Screenshot.gif)

## Introduction



## Rules

Computer always plays as Black, whilst Human always plays as Yellow, with the player that moves first toggling between games. Initially, the Human pieces can only move diagonally upwards on the board, providing the next-closest diagonal cell is empty. If the next-closest diagonal cell contains a rival piece, and the next-closest diagonal cell is empty, the player can jump over the opponent and the opponent's piece is removed from the board. The game continues oscellating between the two players until one player sucessfully removes all the opponent pieces, or the opponent is unable to move.

In addition to these basic rules, there are two other details regarding the game of Draughts that some users, including the programmer, initially forget.

Firstly, the initial pieces on the board are called 'Men' and can only move upwards in the case of Human pieces, and downwards across the board for Computer pieces. If a piece by either player reaches the other end of the board, the piece is transformed into a 'King' which can both move and take opponent pieces diagonally in all four directions. On a physical board, converting a 'Man' to a 'King' is typically performed by adding a second piece on top of the first. In this game, we identify kings by adding a darker circle to the piece. This is illustrated in the contrived example below where both Human and Computer players convert a 'Man' to a 'King':

![Screenshot](https://github.com/James-P-D/DraughtsMinimax/blob/master/Kings.gif)

Secondly, when jumping over opponents, it is possible to 'chain' your move, and thus take possession of multiple opponent pieces:

![Screenshot](https://github.com/James-P-D/DraughtsMinimax/blob/master/Chaining.gif)

Finally, please note that there are many different variations of the game of Draughts. Some games allow 'Kings' to take pieces in any diagonal direction, but can only move to unoccupied spaces in one direction. Other variations allow 'Kings' to move any number of places diagonally providing the path is clear, meaning the piece can move from one corner of the board to the opposite corner in a single step, much like a Queen in Chess. In one (frankly insane) variation, captured pieces are left on the board but are now unmoveable and cannot be jumped over. There's even a variation where the whole board 'wraps' in all four directions so it possible for pieces to move leftwards across the board and then suddenly appear on the right-hand side of the board.

Basically what I'm saying is, if you don't like the choice of rules, don't email me, just fork the repository and keep it to yourself. :)

## Minimax

The value of a board can be calculated easily enough by assigning values to pieces, and thus summing the result. So, for example, a board in which there are 5 enemy pieces is obviously of greater value than an enemy board with 6 pieces, so the move required to transform the board from its current state to the state in which there are fewer enemy pieces (as the result of jumping over one of them) will be chosen by the Computer player. In addition, since King pieces are able to move in four directions, compared to Men who can only move in two, the values of Kings is double that of Men. Therefore if the Computer player is in a position where it can either capture a single enemy Man, or can convert one of its own Men into a King, it will chose the latter move.

In addition to the valuing of pieces on the board, the game must also take into consideration the depth of tree when applying the Minimax algorithm. Firstly, this is because the game is infinite and therefore we are restricted to searching only to a depth of MAX_DEPTH moves (currently set to 5, but the value can be increased at the expense of processing time.) Secondly, if the Computer player is faced with two possible moves, one of which will result in taking a enemy piece immediately, and one that will result in taking an enemy piece after 2 moves, the Computer should logcially opt for the first option.

Finally, the positioning of pieces on the board matters. Both Men and King pieces can only be captured if it is possible for the opposition player to jump over them. Enemy pieces that are either up against one of the four sides, or are positioned with two Human pieces next to them, cannot be taken. Therefore we should assign greater value to these pieces since they should be considered safe.
