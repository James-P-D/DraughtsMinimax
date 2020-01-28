class PossibleMovesCalculator
{
  int initialColumn;
  int initialRow;
  
  PossibleMovesCalculator(Board board, int column, int row)
  {
    this.initialColumn = column;
    this.initialRow = row;
    this.Moves = new ArrayList<Move>();
    
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
        
        // Check for Jump Moves
        this.Moves.addAll(GetJumpMoveTree(board, column, row));
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
        
        // Check for Jump Moves
        this.Moves.addAll(GetJumpMoveTree(board, column, row));
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

        // Check for Jump Moves
        this.Moves.addAll(GetJumpMoveTree(board, column, row));
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
        
        // Check for Jump Moves
        this.Moves.addAll(GetJumpMoveTree(board, column, row));
        break;      
    }
  }
  
  ArrayList<Move> Moves;
  
  private ArrayList<JumpMove> GetJumpMoveTree(Board board, int column, int row) 
  {
    ArrayList<JumpMove> jumpMoves = new ArrayList<JumpMove>();
    switch(board.pieces[column][row])
    {
      case Board.HUMAN_MAN:
        // Check Top Left
        if((column - 2 >= 0) && (row - 2 >= 0) && board.IsEmpty(column - 2, row - 2) && board.IsComputer(column - 1, row -1))
        {
          JumpMove jumpMove = new JumpMove(column - 2, row - 2, column -1, row - 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = Board.HUMAN_MAN;
          
          jumpMove.nextJumpMoves.addAll(GetJumpMoveTree(newBoard, jumpMove.targetColumn, jumpMove.targetRow));
          this.Moves.add(jumpMove);
        }
        // Check Top Right
        if((column + 2 < Board.BOARD_WIDTH) && (row - 2 >= 0) && board.IsEmpty(column + 2, row - 2) && board.IsComputer(column + 1, row - 1))
        {
          JumpMove jumpMove = new JumpMove(column + 2, row - 2, column + 1, row - 1);
          Board newBoard = board.Clone();
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = Board.HUMAN_MAN;
          
          jumpMove.nextJumpMoves.addAll(GetJumpMoveTree(newBoard, jumpMove.targetColumn, jumpMove.targetRow));
          this.Moves.add(jumpMove);
        }
        break;
      case Board.HUMAN_KING:
        // Check Top Left
        if((column - 2 >= 0) && (row - 2 >= 0) && board.IsEmpty(column - 2, row - 2) && board.IsComputer(column - 1, row -1))
        {
          JumpMove jumpMove = new JumpMove(column - 2, row - 2, column -1, row - 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = Board.HUMAN_MAN;
          
          jumpMove.nextJumpMoves.addAll(GetJumpMoveTree(newBoard, jumpMove.targetColumn, jumpMove.targetRow));
          this.Moves.add(jumpMove);
        }
        // Check Top Right
        if((column + 2 < Board.BOARD_WIDTH) && (row - 2 >= 0) && board.IsEmpty(column + 2, row - 2) && board.IsComputer(column + 1, row - 1))
        {
          JumpMove jumpMove = new JumpMove(column + 2, row - 2, column + 1, row - 1);
          Board newBoard = board.Clone();
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = Board.HUMAN_MAN;
          
          jumpMove.nextJumpMoves.addAll(GetJumpMoveTree(newBoard, jumpMove.targetColumn, jumpMove.targetRow));
          this.Moves.add(jumpMove);
        }
        // Check Bottom Left
        if((column - 2 >= 0) && (row + 2 < Board.BOARD_HEIGHT) && board.IsEmpty(column - 2, row + 2) && board.IsComputer(column - 1, row + 1))
        {
          JumpMove jumpMove = new JumpMove(column - 2, row + 2, column - 1, row + 1);
          
          Board newBoard = board.Clone();
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = Board.HUMAN_MAN;
          
          jumpMove.nextJumpMoves.addAll(GetJumpMoveTree(newBoard, jumpMove.targetColumn, jumpMove.targetRow));
          this.Moves.add(jumpMove);
        }
        // Check Bottom Right
        if((column + 2 < Board.BOARD_WIDTH) && (row + 2 < Board.BOARD_HEIGHT) && board.IsEmpty(column + 2, row + 2) && board.IsComputer(column + 1, row + 1))
        {
          JumpMove jumpMove = new JumpMove(column + 2, row + 2, column + 1, row + 1);
          Board newBoard = board.Clone();
          newBoard.pieces[column][row] = Board.EMPTY;
          newBoard.pieces[jumpMove.takenColumn][jumpMove.takenRow] = Board.EMPTY;
          newBoard.pieces[jumpMove.targetColumn][jumpMove.targetRow] = Board.HUMAN_MAN;
          
          jumpMove.nextJumpMoves.addAll(GetJumpMoveTree(newBoard, jumpMove.targetColumn, jumpMove.targetRow));
          this.Moves.add(jumpMove);
        }
        break;        
    }
    
    return jumpMoves;
  }
}
