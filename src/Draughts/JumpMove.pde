class JumpMove extends Move
{
  JumpMove(int column, int row, int takenColumn, int takenRow)
  {
    super(column, row);
    this.nextJumpMoves = new ArrayList<JumpMove>();
    
    this.takenColumn = takenColumn;
    this.takenRow = takenRow;
  }
  
  int takenColumn;
  int takenRow;
  
  ArrayList<JumpMove> nextJumpMoves;
}
