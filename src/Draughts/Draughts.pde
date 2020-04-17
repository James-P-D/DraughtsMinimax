// Draughts Game using Minimax
// Tested against Processing v3.5.3

// TODO
// * Actual choosing of best move
// * Detect win/draw
// * Start new game
// * Update CalculateScore to take into account user winning by forcing opponent into position where there are no possible moves
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
final color BOARD_CELL_COLOR_2 = LIGHT_GRAY_COLOR;
final color COMPUTER_MAN_COLOR = BLACK_COLOR;
final color COMPUTER_KING_COLOR = BLACK_COLOR;
final color HUMAN_MAN_COLOR = WHITE_COLOR;
final color HUMAN_KING_COLOR = WHITE_COLOR;

final String HUMAN_TURN_MESSAGE = "HUMAN TURN";
final String COMPUTER_TURN_MESSAGE = "COMPUTER TURN";
final String HUMAN_WINS_MESSAGE = "HUMAN WINS!";
final String COMPUTER_WINS_MESSAGE = "COMPUTER WINS!";

/***********************************************************
 * Global Variables (yuck!)
 ***********************************************************/
Board mainBoard;
boolean humanGoesFirst;
boolean humanTurn;
boolean humanHasWon;
boolean computerHasWon;
int humanMovingPieceColumn;
int humanMovingPieceRow;
boolean computerProcessing = false;
boolean computerProcessingComplete = false;
MinimaxTree minimaxTree;
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
  // size() doesn't allow anything other than integer literals for parameters, so we
  // have to use surface.setSize() instead!
  //size(800, 800);
  surface.setSize((CELL_WIDTH * Board.BOARD_WIDTH) + (2 * BOARD_LEFT_MARGIN), (CELL_HEIGHT * Board.BOARD_HEIGHT) + (2 * BOARD_TOP_MARGIN)); 
  surface.setResizable(false);
  surface.setLocation(0, 0);
  
  background(GRAY_COLOR);
  this.humanGoesFirst = false;
  
  this.InitialiseGame();  
  this.possibleMovePositions = new ArrayList<PositionTuple>();
}

/***********************************************************
 * InitialiseGame() - Create the board and set the boolean
 * flags. This will be called on startup, or whenever someone
 * wins the game and the user wants to play again
 ***********************************************************/

void InitialiseGame()
{
  this.mainBoard = new Board();
  
  this.humanGoesFirst = !this.humanGoesFirst; // If human went first last time, computer goes first this time, and vice-versa.
  this.humanTurn = this.humanGoesFirst;
  this.humanMovingPieceColumn = -1;
  this.humanMovingPieceRow = -1;
  this.humanHasWon = false;
  this.computerHasWon = false;
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
  if(this.humanHasWon || this.computerHasWon)
  {
    if(this.humanHasWon) 
    {
      this.WriteLabel(HUMAN_WINS_MESSAGE);
    }
    if(this.computerHasWon) 
    {
      this.WriteLabel(COMPUTER_WINS_MESSAGE);
    }
  }
  else
  {
    if(this.humanTurn)
    {
      this.WriteLabel(HUMAN_TURN_MESSAGE);
    }
    else
    {
      this.WriteLabel(COMPUTER_TURN_MESSAGE);
    }
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

  if(this.humanHasWon || this.computerHasWon)
  {
    return;
  }

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
    if(frameCount % 50 == 0)
    {
      if(!this.computerProcessing)
      {
        print_("Starting thread...\n");
        this.computerProcessing = true;
        this.computerProcessingComplete = false;
        thread("CalculateComputerMove");
      }
      else if(this.computerProcessingComplete)
      {
        this.computerProcessing = false;
        print_("Thread has finished!\n");
        this.mainBoard.ApplyMove(minimaxTree.childNodes.get(0).column, minimaxTree.childNodes.get(0).row, minimaxTree.childNodes.get(0).move); //<>//
        humanTurn = true;
        
        BoardValueCalculator boardValueCalculator = new BoardValueCalculator(this.mainBoard);
        if(!boardValueCalculator.humanCanMove)
        {
          this.computerHasWon = true;
        }
      }
      else
      {
        print_("Waiting on thread...\n");        
      }
    }
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
  print_("Start mousePressed()\n");
  
  if((mouseY > 0) && (mouseY < BOARD_TOP_MARGIN) && (this.humanHasWon || this.computerHasWon))
  {
    this.InitialiseGame();
  }
  else if(this.humanTurn) 
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
  print_("Done mousePressed()\n");
}

/***********************************************************
 * Mouse Released Event. When the user stops pressing the mouse
 * button, calculate the position of the mouse and see if it's
 * a valid place to relocate the piece.
 ***********************************************************/
void mouseReleased()
{
  print_("Start mouseReleased()\n");
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
              break;
            }
          }
        }
        possibleMovesCalculator = null;
      }
            
      // If it's no longer the human's turn, then we did make a valid move.
      if(!humanTurn)
      {
        this.possibleMovePositions.clear(); //<>//
        BoardValueCalculator boardValueCalculator = new BoardValueCalculator(this.mainBoard);
        if(!boardValueCalculator.computerCanMove)
        {
          this.humanHasWon = true;
        }
      }
      
      loop();      
    }
  }
  
  this.humanMovingPieceColumn = -1;
  this.humanMovingPieceRow = -1;
  
  print_("Done mouseReleased()\n");
}

/***********************************************************
 * Calculate the best move for the Computer
 ***********************************************************/
void CalculateComputerMove()
{
  print_("Start calculating\n");  
  this.minimaxTree = new MinimaxTree(this.mainBoard);    
  print_("Done calculating\n");
  
  print_("Start GC\n");
  System.gc();
  print_("Done GC\n");
  
  // Don't turn off this.computerProcessing here! That needs to be done in the Draw() method!
  this.computerProcessingComplete = true;
  print("\n");
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
   
  // Add the text
  PFont f = createFont("SourceCodePro-Regular.ttf", 40);
  textFont(f);
  textAlign(CENTER);
  fill(BLACK_COLOR);
  text(message, ((CELL_WIDTH * Board.BOARD_WIDTH) + (2 * BOARD_LEFT_MARGIN)) / 2, 50);
}

/***********************************************************
 * Write to stdout with timestamp
 ***********************************************************/
void print_(String message)
{
  print(nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2) + " - " + message);
}
