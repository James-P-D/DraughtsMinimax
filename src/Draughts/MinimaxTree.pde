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
        // Remember, we only care about computer pieces at the top of the tree. As we start building the whole
        // tree, we can start switching between the two players.
        if(board.IsComputer(column, row))
        {
          PossibleMovesCalculator possibleMovesCalculator = new PossibleMovesCalculator(board, column, row);
          
          for(int i = 0; i < possibleMovesCalculator.Moves.size(); i++)
          {
            // Note that since we only ever use MinimaxTree when it is the computer's turn, the parameter for
            // specifying the 'humanPlayer' parameter, can always be set to 'false' to begin with
            MinimaxNode childNode = new MinimaxNode(board.Clone(), column, row, possibleMovesCalculator.Moves.get(i), false, 1);
            this.childNodes.add(childNode);
          }          
        }
      }
    } 
  }
  
  /***********************************************************
   * GetBestMove() method. Returns the best move.
   ***********************************************************/
  public MinimaxNode GetBestMove()
  {
    int bestScore = Integer.MIN_VALUE;
    int bestMove = 0;
    for(int i = 0; i < this.childNodes.size(); i++)
    {
      if(this.childNodes.get(i).score > bestScore)
      { 
        bestScore = this.childNodes.get(i).score;
        bestMove = i;
      }
    }
    
    return this.childNodes.get(bestMove);
  }
}
