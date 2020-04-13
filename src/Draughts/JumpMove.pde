class JumpMove extends Move
{
  JumpMove(int column, int row, int takenColumn, int takenRow)
  {
    super(column, row);
    this.nextJumpMove = null;
    
    this.takenColumn = takenColumn;
    this.takenRow = takenRow;
  }
  
  int takenColumn;
  int takenRow;  
  JumpMove nextJumpMove;
}
