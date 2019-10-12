// Draughts Game using Minimax
// Tested against Processing v3.5.3

/***********************************************************
 * Constants
 ***********************************************************/
static final int BOARD_LEFT_MARGIN = 50;
static final int BOARD_TOP_MARGIN = 50;
static final int CELL_WIDTH = 80;
static final int CELL_HEIGHT = 80;
static final int MAN_WIDTH = CELL_WIDTH - 4;
static final int MAN_HEIGHT = CELL_HEIGHT - 4;
static final int KING_WIDTH = CELL_WIDTH - 20;
static final int KING_HEIGHT = CELL_HEIGHT - 20;

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
boolean humanTurn;
int humanMovingPieceColumn;
int humanMovingPieceRow;

/***********************************************************
 * Setup. Set size, background, initialise global variables
 * etc.
 ***********************************************************/
void setup() 
{
  size(1200, 800);
  background(120, 120, 120);
  this.board = new Board();
  this.humanTurn = true;
  this.humanMovingPieceColumn = -1;
  this.humanMovingPieceRow = -1;  
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
  
  for(int column = 0; column < Board.BOARD_WIDTH; column++)
  {
    for(int row = 0; row < Board.BOARD_HEIGHT; row++)
    {
      if((row + column) % 2 == 0)
      {
        DrawWhiteSquare(column, row);
      }
      else
      {
        DrawBlackSquare(column, row);
      }

      /*
      boolean mouseOver = false;
      // Check if mouse is over the current square
      if(OverSquare(mouseX, mouseY, column, row))
      { //<>//
        // ..also check that current square contains a human piece, no point highlighting
        // the computer-pieces, since the human player cannot move them.
        if(board.IsHuman(column, row))
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
      }*/
      
      if(!((column == this.humanMovingPieceColumn) && (row == this.humanMovingPieceRow)))
      {
        // Draw the actual pieces
        switch(board.pieces[column][row])
        {
          case Board.COMPUTER_MAN:
            this.DrawComputerManAtSquare(column, row);
            break;
          case Board.HUMAN_MAN:
            this.DrawHumanManAtSquare(column, row);
            break;
          case Board.COMPUTER_KING:
            this.DrawComputerKingAtSquare(column, row);
            break;
          case Board.HUMAN_KING:
            this.DrawHumanKingAtSquare(column, row);
            break;
        }
      }
    }
  }
  
  if((this.humanMovingPieceColumn != -1) && (this.humanMovingPieceRow != -1))
  {
    int tempMouseX = max(mouseX, BOARD_LEFT_MARGIN + (CELL_WIDTH / 2));
    int tempMouseY = max(mouseY, BOARD_TOP_MARGIN + (CELL_HEIGHT / 2));
    tempMouseX = min(tempMouseX, BOARD_LEFT_MARGIN + (CELL_WIDTH * Board.BOARD_WIDTH) - (CELL_WIDTH / 2));
    tempMouseY = min(tempMouseY, BOARD_TOP_MARGIN + (CELL_HEIGHT * Board.BOARD_HEIGHT) - (CELL_HEIGHT / 2));
    
    switch(board.pieces[this.humanMovingPieceColumn][this.humanMovingPieceRow])
    {
      case Board.HUMAN_MAN:
        this.DrawHumanManAtXY(tempMouseX, tempMouseY);
        break;
      case Board.HUMAN_KING:
        this.DrawHumanKingAtXY(tempMouseX, tempMouseY);
        break;
    }
  }
}

boolean OverSquare(int x, int y, int column, int row)
{
  return (x > (BOARD_LEFT_MARGIN + (column * CELL_WIDTH))) && 
         (x < (BOARD_LEFT_MARGIN + ((column + 1) * CELL_WIDTH))) && 
         (y > (BOARD_TOP_MARGIN + (row * CELL_HEIGHT))) && 
         (y < (BOARD_TOP_MARGIN + ((row + 1) * CELL_HEIGHT)));
}

void mousePressed() 
{
  if(this.humanTurn) 
  {
    if((mouseX > BOARD_LEFT_MARGIN) && (mouseX < BOARD_LEFT_MARGIN + (CELL_WIDTH * Board.BOARD_WIDTH)) &&
       (mouseY > BOARD_TOP_MARGIN) && (mouseY < BOARD_TOP_MARGIN + (CELL_HEIGHT * Board.BOARD_HEIGHT)))
    {
      int column = (mouseX - BOARD_LEFT_MARGIN) / CELL_WIDTH;
      int row = (mouseY - BOARD_TOP_MARGIN) / CELL_HEIGHT;
      
      if(board.IsHuman(column, row))
      {
        this.humanMovingPieceColumn = column;
        this.humanMovingPieceRow = row;
      }
    }
  }
}

void mouseDragged() 
{
}

void mouseReleased()
{
}

/***********************************************************
 * Draw Black Squares for Board
 ***********************************************************/
void DrawBlackSquare(int column, int row)
{
  strokeWeight(0);
  fill(BLACK_COLOR);
  DrawSquare(column, row);
}

/***********************************************************
 * Draw White Squares for Board
 ***********************************************************/
void DrawWhiteSquare(int column, int row)
{
  strokeWeight(0);
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
 * Draw normal piece for human player at specific square
 ***********************************************************/
void DrawHumanManAtSquare(int column, int row)
{
  DrawHumanManAtXY(BOARD_LEFT_MARGIN + (column * CELL_WIDTH) + (CELL_WIDTH / 2),
                   BOARD_TOP_MARGIN + (row * CELL_HEIGHT) + (CELL_HEIGHT / 2));
}

/***********************************************************
 * Draw normal piece for computer player at specific square
 ***********************************************************/
void DrawComputerManAtSquare(int column, int row)
{
  DrawComputerManAtXY(BOARD_LEFT_MARGIN + (column * CELL_WIDTH) + (CELL_WIDTH / 2),
                      BOARD_TOP_MARGIN + (row * CELL_HEIGHT) + (CELL_HEIGHT / 2));
}

/***********************************************************
 * Draw normal piece for human player at specific coordinates
 ***********************************************************/
void DrawHumanManAtXY(int x, int y) 
{
  fill(HUMAN_MAN_COLOR);
  ellipse(x, y, MAN_WIDTH, MAN_HEIGHT); 
}

/***********************************************************
 * Draw computer piece for human player at specific coordinates
 ***********************************************************/
void DrawComputerManAtXY(int x, int y) 
{
  fill(COMPUTER_MAN_COLOR);
  ellipse(x, y, MAN_WIDTH, MAN_HEIGHT); 
}

/***********************************************************
 * Dray king piece for human player
 ***********************************************************/
void DrawHumanKingAtSquare(int column, int row)
{
  DrawHumanKingAtXY(BOARD_LEFT_MARGIN + (column * CELL_WIDTH) + (CELL_WIDTH / 2),
                    BOARD_TOP_MARGIN + (row * CELL_HEIGHT) + (CELL_HEIGHT / 2));
}

/***********************************************************
 * Draw king piece for computer player
 ***********************************************************/
void DrawComputerKingAtSquare(int column, int row)
{
  DrawComputerKingAtXY(BOARD_LEFT_MARGIN + (column * CELL_WIDTH) + (CELL_WIDTH / 2),
                       BOARD_TOP_MARGIN + (row * CELL_HEIGHT) + (CELL_HEIGHT / 2));
}

/***********************************************************
 * Draw king piece for human player at specific coordinates
 ***********************************************************/
void DrawHumanKingAtXY(int x, int y) 
{
  fill(HUMAN_MAN_COLOR);
  ellipse(x, y, MAN_WIDTH, MAN_HEIGHT);
  fill(HUMAN_KING_COLOR);
  ellipse(x, y, KING_WIDTH, KING_HEIGHT);
}

/***********************************************************
 * Draw king piece for computer player at specific coordinates
 ***********************************************************/
void DrawComputerKingAtXY(int x, int y) 
{
  fill(COMPUTER_MAN_COLOR);
  ellipse(x, y, MAN_WIDTH, MAN_HEIGHT);
  fill(COMPUTER_KING_COLOR);
  ellipse(x, y, KING_WIDTH, KING_HEIGHT);
}
