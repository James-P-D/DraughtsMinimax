class MinimaxNode
{
  /***********************************************************
   * Properties
   ***********************************************************/  
  public ArrayList<MinimaxNode> childNodes;
  public int score;
  public Move move;
  public int row;
  public int column;
  
  /***********************************************************
   * Constructor
   ***********************************************************/  
  public MinimaxNode(Board board, int currentColumn, int currentRow, Move move, boolean humanPlayer, int depth)
  {
    this.childNodes = new ArrayList<MinimaxNode>();
    this.column = currentColumn;
    this.row = currentRow;
    this.move = move;
    
    board.ApplyMove(currentColumn, currentRow, move);
    
    if(depth >= MAX_SEARCH_DEPTH) return;
    
    for(int column = 0; column < Board.BOARD_WIDTH; column++)
    {    
      for(int row = 0; row < Board.BOARD_HEIGHT; row++)
      {
        humanPlayer = !humanPlayer;
        if((humanPlayer && board.IsHuman(column, row)) ||
           (!humanPlayer && board.IsComputer(column, row)))
        {
          PossibleMovesCalculator possibleMovesCalculator = new PossibleMovesCalculator(board, column, row);
          for(int i=0; i<possibleMovesCalculator.Moves.size(); i++)
          {            
            MinimaxNode childNode = new MinimaxNode(board.Clone(), column, row, possibleMovesCalculator.Moves.get(i), humanPlayer, depth + 1);
            this.childNodes.add(childNode);
          }          
        }
      }
    }    
  }
}
