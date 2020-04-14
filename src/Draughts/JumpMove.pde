class JumpMove extends Move
{
  /***********************************************************
   * Properties
   ***********************************************************/  
  public int takenColumn;
  public int takenRow;  
  public JumpMove nextJumpMove;

  /***********************************************************
   * Constructor
   ***********************************************************/  
  public JumpMove(int column, int row, int takenColumn, int takenRow)
  {
    super(column, row);
    this.nextJumpMove = null;
    
    this.takenColumn = takenColumn;
    this.takenRow = takenRow;
  }  
}
