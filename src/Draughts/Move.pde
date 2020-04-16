/***********************************************************
 * Base Class for Move. Used by StepMove and JumpMove
 ***********************************************************/  

class Move
{
  /***********************************************************
   * Properties
   ***********************************************************/  
  public int targetColumn;
  public int targetRow;
  
  /***********************************************************
   * Constructor
   ***********************************************************/  
  public Move(int column, int row)
  {
    this.targetColumn = column;
    this.targetRow = row;
  }
}
