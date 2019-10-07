// Draughts Game using Minimax
// Tested against Processing v3.5.3

/***********************************************************
 * Constants
 ***********************************************************/
static final int BOARD_LEFT_MARGIN = 50;
static final int BOARD_TOP_MARGIN = 50;
static final int CELL_WIDTH = 80;
static final int CELL_HEIGHT = 80;
final color COMPUTER_MAN_COLOR = color(120, 120, 120);
final color COMPUTER_KING_COLOR = color(90, 90, 90);
final color HUMAN_MAN_COLOR = color(255, 255, 120);
final color HUMAN_KING_COLOR = color(120, 120, 60);
final color WHITE_COLOR = color(255, 255, 255);
final color BLACK_COLOR = color(0, 0, 0);
final color RED_COLOR = color(255, 0, 0);

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
  for(int x=0; x<Board.BOARD_WIDTH; x++)
  {
    for(int y=0; y<Board.BOARD_HEIGHT; y++)
    {
      stroke(BLACK_COLOR);
      strokeWeight(0);

      if(counter % 2 == 0)
      {
        DrawWhiteSquare(x, y);
      }
      else
      {
        DrawBlackSquare(x, y);
      }
      counter++;      

      stroke(0);
      strokeWeight(0);

      boolean mouseOver = false;
      // Check if mouse is over the current square
      if(
        (mouseX > (BOARD_LEFT_MARGIN + (x * CELL_WIDTH))) && 
        (mouseX < (BOARD_LEFT_MARGIN + ((x + 1) * CELL_WIDTH))) && 
        (mouseY > (BOARD_TOP_MARGIN + (y * CELL_HEIGHT))) && 
        (mouseY < (BOARD_TOP_MARGIN + ((y + 1) * CELL_HEIGHT))))
      { //<>//
        // ..also check that current square contains a human piece, no point highlighting
        // the computer-pieces, since the human player cannot move them.
        if((board.pieces[x][y] == Board.HUMAN_MAN) || (board.pieces[x][y] == Board.HUMAN_KING))
        {
          stroke(RED_COLOR);
          strokeWeight(3);        
        }
      }
      
      // Draw the actual pieces
      switch(board.pieces[x][y])
      {
        case Board.COMPUTER_MAN:
          this.DrawComputerMan(x,y);
          break;
        case Board.HUMAN_MAN:
          this.DrawHumanMan(x,y);
          break;
        case Board.COMPUTER_KING:
          this.DrawComputerKing(x,y);
          break;
        case Board.HUMAN_KING:
          this.DrawHumanKing(x,y);
          break;
      }
      
    }
    counter++;
  }
}

/***********************************************************
 * Draw Black Squares for Board
 ***********************************************************/
void DrawBlackSquare(int x, int y)
{
  fill(BLACK_COLOR);
  DrawSquare(x, y);
}

/***********************************************************
 * Draw White Squares for Board
 ***********************************************************/
void DrawWhiteSquare(int x, int y)
{
  fill(WHITE_COLOR);
  DrawSquare(x, y);
}

/***********************************************************
 * Draw Square using current Color
 ***********************************************************/
void DrawSquare(int x, int y) 
{
  rect(BOARD_LEFT_MARGIN + (x * CELL_WIDTH),
       BOARD_TOP_MARGIN + (y * CELL_HEIGHT),
       CELL_WIDTH,
       CELL_HEIGHT);
}

/***********************************************************
 * Draw normal piece for human player
 ***********************************************************/
void DrawHumanMan(int x, int y)
{
  fill(255, 255, 120);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4); 
}

/***********************************************************
 * Draw normal piece for computer player
 ***********************************************************/
void DrawComputerMan(int x, int y)
{
  fill(COMPUTER_MAN_COLOR);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4);
}

/***********************************************************
 * Dray king piece for human player
 ***********************************************************/
void DrawHumanKing(int x, int y)
{
  fill(HUMAN_MAN_COLOR);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4); 
  fill(HUMAN_KING_COLOR);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 20,
          CELL_HEIGHT - 20);
}

/***********************************************************
 * Draw king piece for computer player
 ***********************************************************/
void DrawComputerKing(int x, int y)
{
  fill(COMPUTER_MAN_COLOR);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4);
  fill(COMPUTER_KING_COLOR);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 20,
          CELL_HEIGHT - 20);
}
