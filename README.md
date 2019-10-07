# DraughtsMinimax
A Processing implementation of Draughts using Minimax

![Screenshot](https://github.com/James-P-D/DraughtsMinimax/blob/master/Screenshot.gif)

## Introduction



## Rules

Computer always plays as Black, whilst Human always plays as Yellow, with the player that moves first toggling between games. Initially, the Human pieces can only move diagonally upwards on the board, providing the next-closest diagonal cell is empty. If the next-closest diagonal cell contains a rival piece, and the next-closest diagonal cell is empty, the player can jump over the oponent and the oponent's piece is removed from the board. The game continues oscellating between the two players until one player sucessfully removes all the openent pieces.

In addition to these basic rules, there are two other details regarding the game of Draughts that some users, including the programmer, initially forget.

Firstly, the initial pieces on the board are called 'Men' and can only move upwards in the case of Human pieces, and downwards across the board for Computer pieces. If a piece by either player reaches the other end of the board, the piece is transformed into a 'King' which can both move and take oponent pieces diagonally in all four directions. On a physical board, converting a 'Man' to a 'King' is typically performed by adding a second piece on top of the first. In this game, we identify kings by adding a darker circle to the piece. This is illustrated in the contrived example below where both Human and Computer players convert a 'Man' to a 'King':

![Screenshot](https://github.com/James-P-D/DraughtsMinimax/blob/master/Kings.gif)

Secondly, when jumping over oponents, it is possible to 'chain' your move, and thus take possession of multiple oponent pieces:

![Screenshot](https://github.com/James-P-D/DraughtsMinimax/blob/master/Chaining.gif)

Finally, please note that there are many different variations of the game of Draughts. In some games, taking pieces is compulsory, meaning you can't move one square diagonally if there is the opportunity to jump over an oponent piece and take it elsewhere on the board. Some games allow 'Kings' to take pieces in any diagonal direction, but can only move to unocupied spaces in one direction. Other variations allow 'Kings' to move any number of places diagonally providing the path is clear, meaning the piece can move from one corner of the board to the opposite corner in a single step. In one (frankly insane) variation, captured pieces are left on the board but are now immobile and cannot be jumped over.

Basically what I'm saying is, if you don't like the choice of rules, don't email me, just fork the repository and keep it to yourself. :)