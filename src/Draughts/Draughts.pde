// Draughts Game using Minimax
// Tested against Processing v3.5.3

/***********************************************************
 * Constants
 ***********************************************************/
static final int BOARD_LEFT_MARGIN = 50;
static final int BOARD_TOP_MARGIN = 50;
static final int CELL_WIDTH = 80;
static final int CELL_HEIGHT = 80;
final color WHITE_COLOR = color(255, 255, 255);
final color BLACK_COLOR = color(0, 0, 0);

final color RED_COLOR = color(255, 0, 0);
final color GREEN_COLOR = color(0, 255, 0);
final color BLUE_COLOR = color(0, 0, 255);
final color YELLOW_COLOR = color(255, 255, 0);
final color PINK_COLOR = color(255, 0, 255);
final color CYAN_COLOR = color(0, 255, 255);

final color DARK_BLUE_COLOR = color(0, 0, 126);
final color DARK_YELLOW_COLOR = color(126, 126, 0);

final color COMPUTER_MAN_COLOR = BLUE_COLOR;
final color COMPUTER_KING_COLOR = DARK_BLUE_COLOR;
final color HUMAN_MAN_COLOR = YELLOW_COLOR;
final color HUMAN_KING_COLOR = DARK_YELLOW_COLOR;


/***********************************************************
 * Global Variables (yuck!)
 ***********************************************************/
Board board;

/***********************************************************
 * Setup. Set size, background, initialise global variables
 * etc.
 ***********************************************************/
void setup() 
{
  size(1200, 800);
  background(120, 120, 120);
  board = new Board();  
}

/***********************************************************
 * Main draw() method
 ***********************************************************/
void draw() 
{ 
  DrawBoard();
} 

/***********************************************************
 * Draw the board.
 * - Draws black and white squares
 * - Draws pieces (both normal men and kings, if any)
 * - Handles highlighting of pieces during mouseover
 *   for human moves
 * - Handles highlighting of valid possible move squares
 *   for human moves
 ***********************************************************/
void DrawBoard()
{
  stroke(BLACK_COLOR);
  strokeWeight(0);
  fill(BLACK_COLOR);
  rect(BOARD_LEFT_MARGIN,
       BOARD_TOP_MARGIN,
       CELL_WIDTH * Board.BOARD_WIDTH,
       CELL_HEIGHT * Board.BOARD_HEIGHT);
  
  int counter = 0;
  for(int column = 0; column < Board.BOARD_WIDTH; column++)
  {
    for(int row = 0; row < Board.BOARD_HEIGHT; row++)
    {
      if(counter % 2 == 0)
      {
        DrawWhiteSquare(column, row);
      }
      else
      {
        DrawBlackSquare(column, row);
      }
      counter++;      

      stroke(0);
      strokeWeight(0);

      boolean mouseOver = false;
      // Check if mouse is over the current square
      if(
        (mouseX > (BOARD_LEFT_MARGIN + (column * CELL_WIDTH))) && 
        (mouseX < (BOARD_LEFT_MARGIN + ((column + 1) * CELL_WIDTH))) && 
        (mouseY > (BOARD_TOP_MARGIN + (row * CELL_HEIGHT))) && 
        (mouseY < (BOARD_TOP_MARGIN + ((row + 1) * CELL_HEIGHT))))
      { //<>//
        // ..also check that current square contains a human piece, no point highlighting
        // the computer-pieces, since the human player cannot move them.
        if((board.pieces[column][row] == Board.HUMAN_MAN) || (board.pieces[column][row] == Board.HUMAN_KING))
        {
          stroke(RED_COLOR);
          strokeWeight(3);
          
          if(board.pieces[column][row] == Board.HUMAN_MAN)
          {
            // Highlight two squares (plus current one)
          }
          
          if(board.pieces[column][row] == Board.HUMAN_KING)
          {
            // Highlight four squares (plus current one)
          }
        }
      }
      
      // Draw the actual pieces
      switch(board.pieces[column][row])
      {
        case Board.COMPUTER_MAN:
          this.DrawComputerMan(column, row);
          break;
        case Board.HUMAN_MAN:
          this.DrawHumanMan(column, row);
          break;
        case Board.COMPUTER_KING:
          this.DrawComputerKing(column, row);
          break;
        case Board.HUMAN_KING:
          this.DrawHumanKing(column, row);
          break;
      }
      
    }
    counter++;
  }
}

/***********************************************************
 * Draw Black Squares for Board
 ***********************************************************/
void DrawBlackSquare(int column, int row)
{
  fill(BLACK_COLOR);
  DrawSquare(column, row);
}

/***********************************************************
 * Draw White Squares for Board
 ***********************************************************/
void DrawWhiteSquare(int column, int row)
{
  fill(WHITE_COLOR);
  DrawSquare(column, row);
}

/***********************************************************
 * Draw Square using current Color
 ***********************************************************/
void DrawSquare(int column, int row) 
{
  rect(BOARD_LEFT_MARGIN + (column * CELL_WIDTH),
       BOARD_TOP_MARGIN + (row * CELL_HEIGHT),
       CELL_WIDTH,
       CELL_HEIGHT);
}

/***********************************************************
 * Draw normal piece for human player
 ***********************************************************/
void DrawHumanMan(int column, int row)
{
  fill(255, 255, 120);
  ellipse(BOARD_LEFT_MARGIN + (column * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (row * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4); 
  stroke(BLACK_COLOR);
  strokeWeight(0);
}

/***********************************************************
 * Draw normal piece for computer player
 ***********************************************************/
void DrawComputerMan(int column, int row)
{
  fill(COMPUTER_MAN_COLOR);
  ellipse(BOARD_LEFT_MARGIN + (column * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (row * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4);
  stroke(BLACK_COLOR);
  strokeWeight(0);
}

/***********************************************************
 * Dray king piece for human player
 ***********************************************************/
void DrawHumanKing(int column, int row)
{
  fill(HUMAN_MAN_COLOR);
  ellipse(BOARD_LEFT_MARGIN + (column * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (row * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4); 
  stroke(BLACK_COLOR);
  strokeWeight(0);
  fill(HUMAN_KING_COLOR);
  ellipse(BOARD_LEFT_MARGIN + (column * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (row * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 20,
          CELL_HEIGHT - 20);
}

/***********************************************************
 * Draw king piece for computer player
 ***********************************************************/
void DrawComputerKing(int column, int row)
{
  fill(COMPUTER_MAN_COLOR);
  ellipse(BOARD_LEFT_MARGIN + (column * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (row * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4);
  stroke(BLACK_COLOR);
  strokeWeight(0);
  fill(COMPUTER_KING_COLOR);
  ellipse(BOARD_LEFT_MARGIN + (column * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (row * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 20,
          CELL_HEIGHT - 20);
}
