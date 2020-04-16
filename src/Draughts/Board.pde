class Board 
{
  // 8x8 board
  static final int BOARD_WIDTH = 8;
  static final int BOARD_HEIGHT = 8;
  
  // Players fill up first 3 rows
  static final int COMPUTER_ROWS = 3;
  static final int HUMAN_ROWS = 3;
  
  // 'Enum's for pieces
  static final int EMPTY = 0;
  static final int COMPUTER_MAN = 1;
  static final int COMPUTER_KING = 2;
  static final int HUMAN_MAN = 3;
  static final int HUMAN_KING = 4;
  
 
  public int pieces[][];
  
  /***********************************************************
   * Constructor
   ***********************************************************/

  public Board()
  {
    pieces = new int[BOARD_WIDTH][BOARD_HEIGHT];
    
    for(int column = 0; column < Board.BOARD_WIDTH; column++)
    {    
      for(int row = 0; row < Board.BOARD_HEIGHT; row++)
      {        
        if((row + column) % 2 == 1)
        {
          this.pieces[column][row] = EMPTY;
          
          if(row < COMPUTER_ROWS)
          {
            this.pieces[column][row] = COMPUTER_MAN;
          }
          else if(row >= (BOARD_HEIGHT - HUMAN_ROWS))
          {
            this.pieces[column][row] = HUMAN_MAN;
          }
        }
        else
        {
          this.pieces[column][row] = EMPTY;
        }
      }
    }
  }

  /***********************************************************
   * Constructor
   ***********************************************************/
  public Board(int initialPieces[][])
  {
    pieces = new int[BOARD_WIDTH][BOARD_HEIGHT];
    
    for(int column = 0; column < Board.BOARD_WIDTH; column++)
    {    
      for(int row = 0; row < Board.BOARD_HEIGHT; row++)
      {
        this.pieces[column][row] = initialPieces[column][row];
      }
    }
  }
  
  /***********************************************************
   * Clone method. Creates identical copy of Board.
   ***********************************************************/  
  public Board Clone()
  {
    Board clonedBoard = new Board(this.pieces);
    return clonedBoard;
  }

  /***********************************************************
   * Output method. Displays textual copy of board to stdout
   ***********************************************************/
  public void Output()
  {
    print("+");
    for(int column = 0; column < Board.BOARD_WIDTH * 3; column++)
    {
      print("-");
    }
    print("+\n");
    
    for(int row = 0; row < Board.BOARD_HEIGHT; row++)
    {
      print("|");
      for(int column = 0; column < Board.BOARD_WIDTH; column++)
      {
        switch(this.pieces[column][row])
        {
          case COMPUTER_MAN :
            print(" c ");
            break;
          case COMPUTER_KING :
            print(" C ");
            break;
          case HUMAN_MAN :
            print(" h ");
            break;
          case HUMAN_KING :
            print(" H ");
            break;
          case EMPTY :
            print("   ");
            break;        
        }
      }
      print("|\n");
    }
    
    print("+");
    for(int column = 0; column < Board.BOARD_WIDTH * 3; column++)
    {
      print("-");
    }
    print("+\n");
    print("\n");
  }
  
  /***********************************************************
   * IsHuman() method. Returns true if piece at (column, row)
   * is human (man or king)
   ***********************************************************/
  public boolean IsHuman(int column, int row)
  {
    return (this.pieces[column][row] == HUMAN_MAN) || (this.pieces[column][row] == HUMAN_KING);
  }
  
  /***********************************************************
   * IsComputer() method. Returns true if piece at (column, row)
   * is computer (man or king)
   ***********************************************************/
  public boolean IsComputer(int column, int row)
  {
    return (this.pieces[column][row] == COMPUTER_MAN) || (this.pieces[column][row] == COMPUTER_KING);
  }
  
  /***********************************************************
   * IsEmpty() method. Returns true if piece at (column, row)
   * is neither human or computer piece
   ***********************************************************/
  public boolean IsEmpty(int column, int row)
  {
    return (this.pieces[column][row] == EMPTY);
  }
  
  /***********************************************************
   * ApplyMove() method. Applies a given move to the piece at
   * position (column, row)
   ***********************************************************/
  private void ApplyMove(int column, int row, Move move)
  {     //<>//
    if(move instanceof StepMove)
    {
      // Move the piece to the target position
      this.pieces[move.targetColumn][move.targetRow] = this.pieces[column][row];
      // Mark the start-position as empty
      this.pieces[column][row] = Board.EMPTY;

      if((this.pieces[move.targetColumn][move.targetRow] == Board.COMPUTER_MAN) && (move.targetRow == (Board.BOARD_HEIGHT -1)))
      {
        this.pieces[move.targetColumn][move.targetRow] = Board.COMPUTER_KING;
      }
      else if((this.pieces[move.targetColumn][move.targetRow] == Board.HUMAN_MAN) && (move.targetRow == 0))
      {
        this.pieces[move.targetColumn][move.targetRow] = Board.HUMAN_KING;
      }
    }
    else if(move instanceof JumpMove)
    {
      int finalColumn = column;
      int finalRow = row;
      JumpMove jumpMove = (JumpMove)move;
      
      do {
        // Mark the piece we are jumping over as empty
        this.pieces[jumpMove.takenColumn][jumpMove.takenRow] =  Board.EMPTY;
        // Move the piece to the target position (jumping over the taken piece)
        this.pieces[jumpMove.targetColumn][jumpMove.targetRow] = this.pieces[finalColumn][finalRow];
        // Mark the start-position as empty
        this.pieces[finalColumn][finalRow] = Board.EMPTY;
        
        finalColumn = jumpMove.targetColumn;
        finalRow = jumpMove.targetRow;
        jumpMove = jumpMove.nextJumpMove;      
      } while(jumpMove != null);

      if((this.pieces[finalColumn][finalRow] == Board.COMPUTER_MAN) && (finalRow == (Board.BOARD_HEIGHT -1)))
      {
        this.pieces[finalColumn][finalRow] = Board.COMPUTER_KING;
      }
      else if((this.pieces[finalColumn][finalRow] == Board.HUMAN_MAN) && (finalRow == 0))
      {
        this.pieces[finalColumn][finalRow] = Board.HUMAN_KING;
      }
    }
  }
}
