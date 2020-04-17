class BoardValueCalculator
{
  /***********************************************************
   * Properties
   ***********************************************************/  
  public int value;
  public boolean humanCanMove;
  public boolean computerCanMove;
  
  /***********************************************************
   * Constants
   * Scores for pieces. Negative for human player, positive for 
   * Computer. Values will be multiplied by Scalar if they are
   * 'safe' (against a wall or proected by teammates)
   ***********************************************************/
  static final int HUMAN_WINS = -1000000;
  static final int HUMAN_MAN_SCORE = -100;
  static final int HUMAN_KING_SCORE = -200;
  static final int COMPUTER_WINS = 1000000;
  static final int COMPUTER_MAN_SCORE = 100;
  static final int COMPUTER_KING_SCORE = 200;
  static final int SAFE_SCALAR = 2;
  
  /***********************************************************
   * BoardValueCalculator() method. Calculates the value of a board.
   * Values of pieces is taken in to account, with kings valued
   * more highly than men, and with 'safe' pieces also considered.
   * Note that we don't actually need to count to see if either
   * player has zero pieces left on the board. Knowing that the
   * number of possible moves they can make is sufficent since
   * this could also occur due to the opponent blocking them in
   * and winning that way.
   ***********************************************************/
  public BoardValueCalculator(Board board)
  {
    int totalPossibleHumanMoves = 0;
    int totalPossibleComputerMoves = 0;
    
    this.value = 0;
    for(int column = 0; column < Board.BOARD_WIDTH; column++)
    {
      for(int row = 0; row < Board.BOARD_HEIGHT; row++)
      {
        PossibleMovesCalculator possibleMovesCalculator = new PossibleMovesCalculator(board, column, row);
        switch(board.pieces[column][row])
        {
          case Board.HUMAN_MAN :
            this.value += IsSafe(board, column, row) ? HUMAN_MAN_SCORE * SAFE_SCALAR : HUMAN_MAN_SCORE;
            totalPossibleHumanMoves += possibleMovesCalculator.Moves.size();
            break;
          case Board.HUMAN_KING :
            this.value += IsSafe(board, column, row) ? HUMAN_KING_SCORE * SAFE_SCALAR : HUMAN_KING_SCORE;
            totalPossibleHumanMoves += possibleMovesCalculator.Moves.size();
            break;
          case Board.COMPUTER_MAN :
            this.value += IsSafe(board, column, row) ? COMPUTER_MAN_SCORE * SAFE_SCALAR : COMPUTER_MAN_SCORE;
            totalPossibleComputerMoves += possibleMovesCalculator.Moves.size();
            break;
          case Board.COMPUTER_KING :
            this.value += IsSafe(board, column, row) ? COMPUTER_KING_SCORE * SAFE_SCALAR : COMPUTER_KING_SCORE;
            totalPossibleComputerMoves += possibleMovesCalculator.Moves.size();
            break;
        }
      }
    }
    
    this.humanCanMove = totalPossibleHumanMoves > 0;
    this.computerCanMove = totalPossibleComputerMoves > 0;
  }

  /***********************************************************
   * IsSafe method. Checks to see if item at a given (column, row)
   * is safe (I.E. has a wall or pieces along two adjacent sides)
   ***********************************************************/
  private boolean IsSafe(Board board, int column, int row)
  {  
    if((column == 0) || (column == Board.BOARD_WIDTH - 1) || // If piece is against either vertical side of board..
       (row == 0) || (row == Board.BOARD_HEIGHT - 1))        // ..or against either the top or bottom of board..
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
    if(board.IsHuman(column, row))
    {
      if((board.IsHuman(column - 1, row - 1) && board.IsHuman(column + 1, row - 1)) || // Row above
         (board.IsHuman(column - 1, row + 1) && board.IsHuman(column + 1, row + 1)) || // Row below
         (board.IsHuman(column - 1, row - 1) && board.IsHuman(column - 1, row + 1)) || // Col left
         (board.IsHuman(column + 1, row - 1) && board.IsHuman(column + 1, row + 1)))   // Col right
      {
        return true;
      }
    }
    
    // ...and do the same thing for Computer player
    if(board.IsComputer(column, row))
    {
      if((board.IsComputer(column - 1, row - 1) && board.IsComputer(column + 1, row - 1)) || // Row above
         (board.IsComputer(column - 1, row + 1) && board.IsComputer(column + 1, row + 1)) || // Row below
         (board.IsComputer(column - 1, row - 1) && board.IsComputer(column - 1, row + 1)) || // Col left
         (board.IsComputer(column + 1, row - 1) && board.IsComputer(column + 1, row + 1)))   // Col right
      {
        return true;
      }
    }
    return false;
  }  
}
