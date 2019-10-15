class Move
{
  int targetColumn;
  int targetRow;
  
  Move(int column, int row)
  {
    this.targetColumn = column;
    this.targetRow = row;
    
    if(row < 0)
    {
      print("Here!"); //<>//
    }
  }
}
