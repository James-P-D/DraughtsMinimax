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
  
  // Scores for pieces. Negative for human player, positive for 
  // Computer. Values will be multiplied by Scalar if they are
  // 'safe' (against a wall or proected by teammates)
  static final int HUMAN_MAN_SCORE = -100;
  static final int HUMAN_KING_SCORE = -200;
  static final int COMPUTER_MAN_SCORE = 100;
  static final int COMPUTER_KING_SCORE = 200;
  static final int SAFE_SCALAR = 2;

  int pieces[][];
  
  public Board()
  {
    pieces = new int[BOARD_WIDTH][BOARD_HEIGHT];
    
    for(int column = 0; column < Board.BOARD_WIDTH; column++)
    {    
      for(int row = 0; row < Board.BOARD_HEIGHT; row++)
      {        
        if((row + column) % 2 == 1)
        {
          if(row < COMPUTER_ROWS)
          {
            this.pieces[column][row] = COMPUTER_MAN;
          }
          else if(row >= (BOARD_HEIGHT - HUMAN_ROWS))
          {
            this.pieces[column][row] = HUMAN_MAN;
          }
          else
          {
            this.pieces[column][row] = EMPTY;
          }
        }
        else
        {
          this.pieces[column][row] = EMPTY;
        }
      }
    }    

    this.Output();
  }

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
  
  public Board Clone()
  {
    Board clonedBoard = new Board(this.pieces);
    return clonedBoard;
  }
  
  public void Output()
  {
    print("+");
    for(int column = 0; column < Board.BOARD_WIDTH; column++)
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
            print("c");
            break;
          case COMPUTER_KING :
            print("C");
            break;
          case HUMAN_MAN :
            print("h");
            break;
          case HUMAN_KING :
            print("H");
            break;
          case EMPTY :
            print(" ");
            break;        
        }
      }
      print("|\n");
    }
    
    print("+");
    for(int column = 0; column < Board.BOARD_WIDTH; column++)
    {
      print("-");
    }
    print("+\n");
    print("\n");
  }
  
  private boolean IsSafe(int column, int row)
  {  
    if((column == 0) || (column == BOARD_WIDTH - 1) || // If piece is against either vertical side of board..
       (row == 0) || (row == BOARD_HEIGHT - 1))        // ..or against either the top or bottom of board..
    { 
      return true;                                     // ..then the piece is inherently safe
    }
    
    // If we get here, then we know the piece is not next to a wall, so no need to check row/column +/-1
    // is out of bounds for array.
    
    // Here we check if a human piece (man or king) has two pieces strictly next to it that are also human.
    // By 'sticktly next to' here we mean two human pieces along the same side, which prevents the piece
    // from being taken. Having two peices that are diagonal immediate neighbours does *NOT* make the piece
    // safe, since it's still possible for an oponent to jump over us, the two neighbours *MUST* be on the same
    // row or column to make the current piece safe.
    if(IsHuman(column, row))
    {
      if((IsHuman(column - 1, row - 1) && IsHuman(column + 1, row - 1)) || // Row above
         (IsHuman(column - 1, row + 1) && IsHuman(column + 1, row + 1)) || // Row below
         (IsHuman(column - 1, row - 1) && IsHuman(column - 1, row + 1)) || // Col left
         (IsHuman(column + 1, row - 1) && IsHuman(column + 1, row + 1)))   // Col right
      {
        return true;
      }
    }
    
    // ...and do the same thing for Computer player
    if(IsComputer(column, row))
    {
      if((IsComputer(column - 1, row - 1) && IsComputer(column + 1, row - 1)) || // Row above
         (IsComputer(column - 1, row + 1) && IsComputer(column + 1, row + 1)) || // Row below
         (IsComputer(column - 1, row - 1) && IsComputer(column - 1, row + 1)) || // Col left
         (IsComputer(column + 1, row - 1) && IsComputer(column + 1, row + 1)))   // Col right
      {
        return true;
      }
    }
    return false;
  }
  
  private boolean IsHuman(int column, int row)
  {
    return (this.pieces[column][row] == HUMAN_MAN) || (this.pieces[column][row] == HUMAN_KING);
  }
  
  private boolean IsComputer(int column, int row)
  {
    return (this.pieces[column][row] == COMPUTER_MAN) || (this.pieces[column][row] == COMPUTER_KING);
  }
  
  private boolean IsEmpty(int column, int row)
  {
    return (this.pieces[column][row] == EMPTY);
  }
  
  private int CalculateScore()
  {
    int totalScore = 0;
    for(int column = 0; column < BOARD_WIDTH; column++)
    {
      for(int row = 0; row < BOARD_HEIGHT; row++)
      {
        switch(this.pieces[column][row])
        {
          case HUMAN_MAN :
            totalScore += IsSafe(column, row) ? HUMAN_MAN_SCORE * SAFE_SCALAR : HUMAN_MAN_SCORE;
            break;
          case HUMAN_KING :
            totalScore += IsSafe(column, row) ? HUMAN_KING_SCORE * SAFE_SCALAR : HUMAN_KING_SCORE;
            break;
          case COMPUTER_MAN :
            totalScore += IsSafe(column, row) ? COMPUTER_MAN_SCORE * SAFE_SCALAR : COMPUTER_MAN_SCORE;
            break;
          case COMPUTER_KING :
            totalScore += IsSafe(column, row) ? COMPUTER_KING_SCORE * SAFE_SCALAR : COMPUTER_KING_SCORE;
            break;
        }
      }
    }
    
    return totalScore;
  }
  
  private void ApplyMove(int column, int row, Move move)
  { //<>//
    /*
    print("ApplyMove(");
    print(column);
    print(", ");
    print(row);
    print(") - (");
    print(move.targetColumn);
    print(", ");
    print(move.targetRow);
    print(")\n");
    */
    
    if(move instanceof StepMove)
    {
      this.pieces[move.targetColumn][move.targetRow] = this.pieces[column][row];
      this.pieces[column][row] = Board.EMPTY;
    }
    else if(move instanceof JumpMove)
    {
      this.pieces[((JumpMove)move).takenColumn][((JumpMove)move).takenRow] =  Board.EMPTY;
      if(((JumpMove)move).nextJumpMoves.size() > 0)
      {
        print("Need to implement chained jumps!!!!!!!!!!!!!\n");
        print("Need to implement chained jumps!!!!!!!!!!!!!\n");
        print("Need to implement chained jumps!!!!!!!!!!!!!\n");
        print("Need to implement chained jumps!!!!!!!!!!!!!\n");
        print("Need to implement chained jumps!!!!!!!!!!!!!\n");
      }
    }
    
    if((this.pieces[move.targetColumn][move.targetRow] == Board.COMPUTER_MAN) && (move.targetRow == (Board.BOARD_HEIGHT -1)))
    {
      this.pieces[move.targetColumn][move.targetRow] = Board.COMPUTER_KING;
    }
    else if((this.pieces[move.targetColumn][move.targetRow] == Board.HUMAN_MAN) && (move.targetRow == 0))
    {
      this.pieces[move.targetColumn][move.targetRow] = Board.HUMAN_KING;
    }
  }
}
