class MinimaxTree
{  
  /***********************************************************
   * Properties
   ***********************************************************/  
  public ArrayList<MinimaxNode> childNodes;
  
  /***********************************************************
   * Constructor
   ***********************************************************/  
  public MinimaxTree(Board board)
  {
    this.childNodes = new ArrayList<MinimaxNode>();
    
    for(int column = 0; column < Board.BOARD_WIDTH; column++)
    {    
      for(int row = 0; row < Board.BOARD_HEIGHT; row++)
      {
        if(board.IsComputer(column, row))
        {
          PossibleMovesCalculator possibleMovesCalculator = new PossibleMovesCalculator(board, column, row);
          
          for(int i=0; i<possibleMovesCalculator.Moves.size(); i++)
          {
            /*
            print(column);
            print(", ");
            print(row);
            print(" -> ");
            
            print(possibleMovesCalculator.Moves.get(i).targetColumn);
            print(", ");
            print(possibleMovesCalculator.Moves.get(i).targetRow);
            print("\n");
            */
            MinimaxNode childNode = new MinimaxNode(board.Clone(), column, row, possibleMovesCalculator.Moves.get(i), false, 0);
            this.childNodes.add(childNode);
          }          
        }
      }
    } 
  }
}
