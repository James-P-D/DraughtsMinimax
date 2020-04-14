class PossibleMovesCalculator
{
  private int initialColumn;
  private int initialRow;
  private ArrayList<Move> Moves;
  
  public PossibleMovesCalculator(Board board, int column, int row)
  {
    this.initialColumn = column;
    this.initialRow = row;
    this.Moves = new ArrayList<Move>();

    // TODO: Do we want to only check for Jump moves? Hmm. have a think about MiniMax planning...
    // Check for Jump Moves
    JumpMove jumpMove = GetNextJumpMove(board, column, row); 
    if(jumpMove != null) 
    {
      this.Moves.add(jumpMove);
    }
    else 
    {        
      switch(board.pieces[column][row])
      {
        case Board.HUMAN_MAN:
          // Check Top Left
          if((column - 1 >= 0) && (row - 1 >= 0) && board.IsEmpty(column - 1, row - 1))
          {
            this.Moves.add(new StepMove(column - 1, row - 1));
          }
          // Check Top Right
          if((column + 1 < Board.BOARD_WIDTH) && (row - 1 >= 0) && board.IsEmpty(column + 1, row - 1))
          {
            this.Moves.add(new StepMove(column + 1, row - 1));
          }
          break;
        case Board.HUMAN_KING:
          // Check Top Left
          if((column - 1 >= 0) && (row - 1 >= 0) && board.IsEmpty(column - 1, row - 1))
          {
            this.Moves.add(new StepMove(column - 1, row - 1));
          }
          // Check Top Right
          if((column + 1 < Board.BOARD_WIDTH) && (row - 1 >= 0) && board.IsEmpty(column + 1, row - 1))
          {
            this.Moves.add(new StepMove(column + 1, row - 1));
          }
          // Check Bottom Left
          if((column - 1 >= 0) && (row + 1 < Board.BOARD_HEIGHT) && board.IsEmpty(column - 1, row + 1))
          {
            this.Moves.add(new StepMove(column - 1, row + 1));
          }
          // Check Bottom Right
          if((column + 1 < Board.BOARD_WIDTH) && (row + 1 < Board.BOARD_HEIGHT) && board.IsEmpty(column + 1, row + 1))
          {
            this.Moves.add(new StepMove(column + 1, row + 1));
          }
          break;
        case Board.COMPUTER_MAN:
          // Check Bottom Left
          if((column - 1 >= 0) && (row + 1 < Board.BOARD_HEIGHT) && board.IsEmpty(column - 1, row + 1))
          {
            this.Moves.add(new StepMove(column - 1, row + 1));
          }
          // Check Bottom Right
          if((column + 1 < Board.BOARD_WIDTH) && (row + 1 < Board.BOARD_HEIGHT) && board.IsEmpty(column + 1, row + 1))
          {
            this.Moves.add(new StepMove(column + 1, row + 1));
          }
          break;
        case Board.COMPUTER_KING:
          // Check Top Left
          if((column - 1 >= 0) && (row - 1 >= 0) && board.IsEmpty(column - 1, row - 1))
          {
            this.Moves.add(new StepMove(column - 1, row - 1));
          }
          // Check Top Right
          if((column + 1 < Board.BOARD_WIDTH) && (row - 1 >= 0) && board.IsEmpty(column + 1, row - 1))
          {
            this.Moves.add(new StepMove(column + 1, row - 1));
          }
          // Check Bottom Left
          if((column - 1 >= 0) && (row + 1 < Board.BOARD_HEIGHT) && board.IsEmpty(column - 1, row + 1))
          {
            this.Moves.add(new StepMove(column - 1, row + 1));
          }
          // Check Bottom Right
          if((column + 1 < Board.BOARD_WIDTH) && (row + 1 < Board.BOARD_HEIGHT) && board.IsEmpty(column + 1, row + 1))
          {
            this.Moves.add(new StepMove(column + 1, row + 1));
          }
          break;
      }
    }
  }
    
  private JumpMove GetNextJumpMove(Board board, int column, int row) 
  {
    switch(board.pieces[column][row])
    {
      case Board.HUMAN_MAN:
        // Check Top Left
        if((column - 2 >= 0) && (row - 2 >= 0) && board.IsEmpty(column - 2, row - 2) && board.IsComputer(column - 1, row - 1))
        {
          JumpMove jumpMove = new JumpMove(column - 2, row - 2, column - 1, row - 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }        
        // Check Top Right
        if((column + 2 < Board.BOARD_WIDTH) && (row - 2 >= 0) && board.IsEmpty(column + 2, row - 2) && board.IsComputer(column + 1, row - 1))
        {
          JumpMove jumpMove = new JumpMove(column + 2, row - 2, column + 1, row - 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }
        break;
      case Board.HUMAN_KING:
        // Check Top Left
        if((column - 2 >= 0) && (row - 2 >= 0) && board.IsEmpty(column - 2, row - 2) && board.IsComputer(column - 1, row -1))
        {
          JumpMove jumpMove = new JumpMove(column - 2, row - 2, column -1, row - 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }
        // Check Top Right
        if((column + 2 < Board.BOARD_WIDTH) && (row - 2 >= 0) && board.IsEmpty(column + 2, row - 2) && board.IsComputer(column + 1, row - 1))
        {
          JumpMove jumpMove = new JumpMove(column + 2, row - 2, column + 1, row - 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }
        // Check Bottom Left
        if((column - 2 >= 0) && (row + 2 < Board.BOARD_HEIGHT) && board.IsEmpty(column - 2, row + 2) && board.IsComputer(column - 1, row + 1))
        {
          JumpMove jumpMove = new JumpMove(column - 2, row + 2, column - 1, row + 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }
        // Check Bottom Right
        if((column + 2 < Board.BOARD_WIDTH) && (row + 2 < Board.BOARD_HEIGHT) && board.IsEmpty(column + 2, row + 2) && board.IsComputer(column + 1, row + 1))
        {
          JumpMove jumpMove = new JumpMove(column + 2, row + 2, column + 1, row + 1);

          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }
        break;        
      case Board.COMPUTER_MAN:
        // Check Bottom Left
        if((column - 2 >= 0) && (row + 2 < Board.BOARD_HEIGHT) && board.IsEmpty(column - 2, row + 2) && board.IsHuman(column - 1, row + 1))
        {
          JumpMove jumpMove = new JumpMove(column - 2, row + 2, column - 1, row + 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }        
        // Check Bottom Right
        if((column + 2 < Board.BOARD_WIDTH) && (row + 2 < Board.BOARD_HEIGHT) && board.IsEmpty(column + 2, row + 2) && board.IsHuman(column + 1, row + 1))
        {
          JumpMove jumpMove = new JumpMove(column + 2, row + 2, column + 1, row + 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }
        break;
      case Board.COMPUTER_KING:
        // Check Top Left
        if((column - 2 >= 0) && (row - 2 >= 0) && board.IsEmpty(column - 2, row - 2) && board.IsHuman(column - 1, row - 1))
        {
          JumpMove jumpMove = new JumpMove(column - 2, row - 2, column - 1, row - 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }
        // Check Top Right
        if((column + 2 < Board.BOARD_WIDTH) && (row - 2 >= 0) && board.IsEmpty(column + 2, row - 2) && board.IsHuman(column + 1, row - 1))
        {
          JumpMove jumpMove = new JumpMove(column + 2, row - 2, column + 1, row - 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }
        // Check Bottom Left
        if((column - 2 >= 0) && (row + 2 < Board.BOARD_HEIGHT) && board.IsEmpty(column - 2, row + 2) && board.IsHuman(column - 1, row + 1))
        {
          JumpMove jumpMove = new JumpMove(column - 2, row + 2, column - 1, row + 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
        }
        // Check Bottom Right
        if((column + 2 < Board.BOARD_WIDTH) && (row + 2 < Board.BOARD_HEIGHT) && board.IsEmpty(column + 2, row + 2) && board.IsHuman(column + 1, row + 1))
        {
          JumpMove jumpMove = new JumpMove(column + 2, row + 2, column + 1, row + 1);

          Board newBoard = board.Clone();
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = newBoard.pieces[column][row];
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
                   
          jumpMove.nextJumpMove = GetNextJumpMove(newBoard, jumpMove.targetColumn, jumpMove.targetRow);
          return jumpMove;
       }
       break;        
    }
    return null;
  }
}
