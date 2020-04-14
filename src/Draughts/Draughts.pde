// Draughts Game using Minimax
// Tested against Processing v3.5.3

/***********************************************************
 * Constants
 ***********************************************************/
static final int MAX_SEARCH_DEPTH = 6;

static final int BOARD_LEFT_MARGIN = 75;
static final int BOARD_TOP_MARGIN = 75;
static final int CELL_WIDTH = 80;
static final int CELL_HEIGHT = 80;
static final int MAN_WIDTH = CELL_WIDTH - 10;
static final int MAN_HEIGHT = CELL_HEIGHT - 10;
static final int KING_WIDTH = CELL_WIDTH - 30;
static final int KING_HEIGHT = CELL_HEIGHT - 30;

final color WHITE_COLOR = color(255, 255, 255);
final color BLACK_COLOR = color(0, 0, 0);
final color GRAY_COLOR = color(120, 120, 120);
final color LIGHT_GRAY_COLOR = color(60, 60, 60);
final color RED_COLOR = color(255, 0, 0);
final color GREEN_COLOR = color(0, 255, 0);
final color BLUE_COLOR = color(0, 0, 255);
final color YELLOW_COLOR = color(255, 255, 0);
final color PINK_COLOR = color(255, 0, 255);
final color CYAN_COLOR = color(0, 255, 255);

final color DARK_BLUE_COLOR = color(0, 0, 126);
final color DARK_YELLOW_COLOR = color(126, 126, 0);

final color BOARD_CELL_COLOR_1 = WHITE_COLOR;
final color BOARD_CELL_COLOR_2 = LIGHT_GRAY_COLOR;//BLACK_COLOR;
final color COMPUTER_MAN_COLOR = BLACK_COLOR;
final color COMPUTER_KING_COLOR = BLACK_COLOR;
final color HUMAN_MAN_COLOR = WHITE_COLOR;
final color HUMAN_KING_COLOR = WHITE_COLOR;

final String HUMAN_TURN_MESSAGE = "HUMAN TURN";
final String COMPUTER_TURN_MESSAGE = "COMPUTER TURN";
final String HUMAN_WINS_MESSAGE = "HUMAN WINS!";
final String COMPUTER_WINS_MESSAGE = "COMPUTER WINS!";
final String DRAW_MESSAGE = "DRAW";

/***********************************************************
 * Global Variables (yuck!)
 ***********************************************************/
Board mainBoard;
boolean humanGoesFirst;
boolean humanTurn;
int humanMovingPieceColumn;
int humanMovingPieceRow;

ArrayList<PositionTuple> possibleMovePositions;
PossibleMovesCalculator possibleMovesCalculator;

/***********************************************************
 * Setup. Set size, background, initialise global variables
 * etc.
 ***********************************************************/
void setup() 
{
  // Form width should be (CELL_WIDTH * Board.BOARD_WIDTH) + (2 * BOARD_LEFT_MARGIN)
  // Form height should be (CELL_HEIGHT * Board.BOARD_HEIGHT) + (2 * BOARD_TOP_MARGIN)
  // size() doesn't allow anything other than integer literals for paramters, so we
  // have to use surface.setSize() instead!
  //size(800, 800);
  surface.setSize((CELL_WIDTH * Board.BOARD_WIDTH) + (2 * BOARD_LEFT_MARGIN), (CELL_HEIGHT * Board.BOARD_HEIGHT) + (2 * BOARD_TOP_MARGIN)); 
  surface.setResizable(false);
  surface.setLocation(0, 0);
  
  background(GRAY_COLOR);
  this.mainBoard = new Board();
  
  this.humanGoesFirst = true;
  this.humanTurn = this.humanGoesFirst;
  this.humanMovingPieceColumn = -1;
  this.humanMovingPieceRow = -1;
  
  this.possibleMovePositions = new ArrayList<PositionTuple>();
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
 * - Draws pieces (both men, and kings if any)
 * - Handles highlighting of pieces during mouseover for human moves
 * - Handles highlighting of valid possible move squares for human moves
 ***********************************************************/
void DrawBoard()
{
  // Make the entire NxN board black to begin with, this way we don't need to actually draw the black
  // squares since the spaces between the white squares will be black regardless.
  stroke(BOARD_CELL_COLOR_2);
  strokeWeight(2);
  fill(BOARD_CELL_COLOR_2);
  rect(BOARD_LEFT_MARGIN,
       BOARD_TOP_MARGIN,
       CELL_WIDTH * Board.BOARD_WIDTH,
       CELL_HEIGHT * Board.BOARD_HEIGHT);
  
  // First update the labels
  if(this.humanTurn)
  {
    this.WriteLabel(HUMAN_TURN_MESSAGE);
  }
  else
  {
    this.WriteLabel(COMPUTER_TURN_MESSAGE);
  }

  stroke(BOARD_CELL_COLOR_1);
  strokeWeight(2);

  // Now loop through all the squares
  for(int column = 0; column < Board.BOARD_WIDTH; column++)
  {
    for(int row = 0; row < Board.BOARD_HEIGHT; row++)
    {
      // Sum of Row and Column will be even for all White squares
      if((row + column) % 2 == 0)
      {
        DrawWhiteSquare(column, row);
      }
      else
      {
        // If it's the Human-turn, turn any possible-move square to red
        if(this.humanTurn)
        {
          if((humanMovingPieceColumn != -1) &&
             (humanMovingPieceRow != -1))
          {      
            if(possibleMovesCalculator != null)
            {
              for(int i = 0; i< this.possibleMovePositions.size(); i++)
              {                
                if((this.possibleMovePositions.get(i).column == column) &&
                   (this.possibleMovePositions.get(i).row == row))
                {
                  DrawRedSquare(column, row);
                }                
              }
            }
          }
        }
      }
      
      // For the current Column and Row, if it isn't the currently moving Human piece, then just
      // draw the relevent circle.
      if(!((column == this.humanMovingPieceColumn) && (row == this.humanMovingPieceRow)))
      {
        // Draw the actual pieces
        switch(mainBoard.pieces[column][row])
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
    } //<>//
  } //<>//

  // Finally, for the currently moving human piece, draw the item at the current mouse position
  if((this.humanMovingPieceColumn != -1) && (this.humanMovingPieceRow != -1))
  {
    int tempMouseX = max(mouseX, BOARD_LEFT_MARGIN + (CELL_WIDTH / 2));
    int tempMouseY = max(mouseY, BOARD_TOP_MARGIN + (CELL_HEIGHT / 2));
    tempMouseX = min(tempMouseX, BOARD_LEFT_MARGIN + (CELL_WIDTH * Board.BOARD_WIDTH) - (CELL_WIDTH / 2));
    tempMouseY = min(tempMouseY, BOARD_TOP_MARGIN + (CELL_HEIGHT * Board.BOARD_HEIGHT) - (CELL_HEIGHT / 2));
    
    switch(mainBoard.pieces[this.humanMovingPieceColumn][this.humanMovingPieceRow])
    {
      case Board.HUMAN_MAN:
        this.DrawHumanManAtXY(tempMouseX, tempMouseY);
        break;
      case Board.HUMAN_KING:
        this.DrawHumanKingAtXY(tempMouseX, tempMouseY);
        break;
    }
  }
  
  // If it's no longer the human's turn, disable the drawing loop and calculate the Computer's
  // best possible move
  if(!humanTurn)
  {
    //computerProcsesing = true;
    CalculateComputerMove();
    //noLoop();
    humanTurn = true;
  }
}

/***********************************************************
 * Mouse Pressed Event. When user presses mouse, check if they
 * are over a human-piece (man or king) and if so, calculate
 * possible moves for the piece. Finally, store final target
 * column and row values in possibleMovePositions so that our
 * main Draw() loop can high-light the valid target cells
 * in red.
 ***********************************************************/
void mousePressed() 
{
  if(this.humanTurn) 
  {
    noLoop();
    if((mouseX > BOARD_LEFT_MARGIN) && (mouseX < BOARD_LEFT_MARGIN + (CELL_WIDTH * Board.BOARD_WIDTH)) &&
       (mouseY > BOARD_TOP_MARGIN) && (mouseY < BOARD_TOP_MARGIN + (CELL_HEIGHT * Board.BOARD_HEIGHT)))
    {
      int column = (mouseX - BOARD_LEFT_MARGIN) / CELL_WIDTH;
      int row = (mouseY - BOARD_TOP_MARGIN) / CELL_HEIGHT;
      
      if(mainBoard.IsHuman(column, row))
      {
        this.humanMovingPieceColumn = column;
        this.humanMovingPieceRow = row;
        
        possibleMovesCalculator = new PossibleMovesCalculator(mainBoard, column, row);
        this.possibleMovePositions.clear();
        
        for(int i=0; i< possibleMovesCalculator.Moves.size(); i++)
        {
          Move possibleMove = possibleMovesCalculator.Moves.get(i);
          if(possibleMove instanceof StepMove)
          {
            this.possibleMovePositions.add(new PositionTuple(possibleMove.targetColumn, possibleMove.targetRow)); 
          } else if(possibleMove instanceof JumpMove) {
            JumpMove possibleJumpMove = (JumpMove)possibleMove;
            while(possibleJumpMove.nextJumpMove != null)
            {
              possibleJumpMove = possibleJumpMove.nextJumpMove;
            }
            this.possibleMovePositions.add(new PositionTuple(possibleJumpMove.targetColumn, possibleJumpMove.targetRow));
          }
        }
      }
    }
    
    loop();
  }
}

/***********************************************************
 * Mouse Released Event. When the user stops pressing the mouse
 * button, calculate the position of the mouse and see if it's
 * a valid place to relocate the piece.
 ***********************************************************/
void mouseReleased()
{
  if(this.humanTurn) 
  {
    if((mouseX > BOARD_LEFT_MARGIN) && (mouseX < BOARD_LEFT_MARGIN + (CELL_WIDTH * Board.BOARD_WIDTH)) &&
       (mouseY > BOARD_TOP_MARGIN) && (mouseY < BOARD_TOP_MARGIN + (CELL_HEIGHT * Board.BOARD_HEIGHT)))
    {
      noLoop();
      int column = (mouseX - BOARD_LEFT_MARGIN) / CELL_WIDTH;
      int row = (mouseY - BOARD_TOP_MARGIN) / CELL_HEIGHT;
      
      if(possibleMovesCalculator != null)
      {
        for(int i=0; i< possibleMovesCalculator.Moves.size(); i++)
        {
          if(possibleMovesCalculator.Moves.get(i) instanceof StepMove)
          {
            StepMove possibleMove = (StepMove)possibleMovesCalculator.Moves.get(i);
            if((column == possibleMove.targetColumn) && (row == possibleMove.targetRow))
            {
              mainBoard.ApplyMove(this.humanMovingPieceColumn, this.humanMovingPieceRow, possibleMove);
                    
              this.humanTurn = false;
              break;
            }
          }
          else if(possibleMovesCalculator.Moves.get(i) instanceof JumpMove)
          {
            JumpMove initialJumpMove = (JumpMove)possibleMovesCalculator.Moves.get(i);
            JumpMove jumpMove = (JumpMove)possibleMovesCalculator.Moves.get(i);
            int finalTargetColumn = jumpMove.targetColumn; 
            int finalTargetRow = jumpMove.targetRow; 
            do {
              finalTargetColumn = jumpMove.targetColumn; 
              finalTargetRow = jumpMove.targetRow; 
              
              jumpMove = jumpMove.nextJumpMove;
            } while(jumpMove != null);
            
            if((column == finalTargetColumn) && (row == finalTargetRow))
            {
              mainBoard.ApplyMove(this.humanMovingPieceColumn, this.humanMovingPieceRow, initialJumpMove);
                    
              this.humanTurn = false;
            }
          }
        }
        possibleMovesCalculator = null;
      }
      
      loop();
    }
  }
  
  if(!humanTurn)
  {
    this.possibleMovePositions.clear();
  }
  
  this.humanMovingPieceColumn = -1;
  this.humanMovingPieceRow = -1;
}

/***********************************************************
 * Calculate the best move for the Computer
 ***********************************************************/
void CalculateComputerMove()
{
  print("Start calculating\n");
  this.mainBoard.Output();
  
  MinimaxTree minimaxTree = new MinimaxTree(this.mainBoard);
  this.mainBoard.ApplyMove(minimaxTree.childNodes.get(0).column, minimaxTree.childNodes.get(0).row, minimaxTree.childNodes.get(0).move);
  this.mainBoard.Output();
  print("Done calculating\n");
  //this.computerProcsesing = false;
  System.gc();
}

/***********************************************************
 * Returns TRUE if x, y is over a particular cell
 ***********************************************************/
//TODO: DO we need this?!?!?!?!?!?!??!?!?!?!?!?!??!?!?!?!?!?!?!?!?!?!?!?!?!?!?!?!?!?!?!??!??!?!?!?
boolean OverSquare(int x, int y, int column, int row)
{
  return (x > (BOARD_LEFT_MARGIN + (column * CELL_WIDTH))) && 
         (x < (BOARD_LEFT_MARGIN + ((column + 1) * CELL_WIDTH))) && 
         (y > (BOARD_TOP_MARGIN + (row * CELL_HEIGHT))) && 
         (y < (BOARD_TOP_MARGIN + ((row + 1) * CELL_HEIGHT)));
}

/***********************************************************
 * Draw Black Squares for Board
 ***********************************************************/
void DrawBlackSquare(int column, int row)
{
  fill(BOARD_CELL_COLOR_1);
  DrawSquare(column, row);
}

/***********************************************************
 * Draw White Squares for Board
 ***********************************************************/
void DrawWhiteSquare(int column, int row)
{
  fill(BOARD_CELL_COLOR_1);
  DrawSquare(column, row);
}

/***********************************************************
 * Draw Red Squares for Board
 ***********************************************************/
void DrawRedSquare(int column, int row)
{
  fill(RED_COLOR);
  DrawSquare(column, row);
}

/***********************************************************
 * Draw Square using current Color
 ***********************************************************/
void DrawSquare(int column, int row) 
{
  strokeWeight(0);
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
  stroke(COMPUTER_MAN_COLOR);
  strokeWeight(2);
  fill(HUMAN_MAN_COLOR);
  ellipse(x, y, MAN_WIDTH, MAN_HEIGHT); 
}

/***********************************************************
 * Draw computer piece for human player at specific coordinates
 ***********************************************************/
void DrawComputerManAtXY(int x, int y) 
{
  stroke(HUMAN_MAN_COLOR);
  strokeWeight(2);
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
  stroke(COMPUTER_MAN_COLOR);
  strokeWeight(2);
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
  stroke(HUMAN_MAN_COLOR);
  strokeWeight(2);
  fill(COMPUTER_MAN_COLOR);
  ellipse(x, y, MAN_WIDTH, MAN_HEIGHT);
  fill(COMPUTER_KING_COLOR);
  ellipse(x, y, KING_WIDTH, KING_HEIGHT);
}

/***********************************************************
 * Write label at top of screen
 ***********************************************************/
void WriteLabel(String message)
{
  // Overwrite any existing text
  stroke(GRAY_COLOR);
  fill(GRAY_COLOR);
  rect(0, 0, (CELL_WIDTH * Board.BOARD_WIDTH) + (2 * BOARD_LEFT_MARGIN), BOARD_TOP_MARGIN);
 
 //surface.setSize((CELL_WIDTH * Board.BOARD_WIDTH) + (2 * BOARD_LEFT_MARGIN), (CELL_HEIGHT * Board.BOARD_HEIGHT) + (2 * BOARD_TOP_MARGIN)); 
 
  
  // Add the text
  PFont f = createFont("SourceCodePro-Regular.ttf", 40);
  textFont(f);
  textAlign(CENTER);
  fill(BLACK_COLOR);
  text(message, ((CELL_WIDTH * Board.BOARD_WIDTH) + (2 * BOARD_LEFT_MARGIN)) / 2, 50);
}
