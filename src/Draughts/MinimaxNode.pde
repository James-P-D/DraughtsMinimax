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
    
    BoardValueCalculator boardValueCalculator = new BoardValueCalculator(board); 
    if(!boardValueCalculator.humanCanMove)
    {
      this.score = BoardValueCalculator.COMPUTER_WINS - depth;
    } 
    else if(!boardValueCalculator.computerCanMove)
    {
      this.score = BoardValueCalculator.HUMAN_WINS + depth;
    }
    else if(depth >= MAX_SEARCH_DEPTH) 
    {
      if(humanPlayer)
      {
        this.score = boardValueCalculator.value + depth;
      }
      else
      {
        this.score = boardValueCalculator.value - depth;
      }
    }
    else
    {
      for(int column = 0; column < Board.BOARD_WIDTH; column++)
      {
        for(int row = 0; row < Board.BOARD_HEIGHT; row++)
        {
          boolean nextPlayerHuman = !humanPlayer;
          if((nextPlayerHuman && board.IsHuman(column, row)) ||
             (!nextPlayerHuman && board.IsComputer(column, row)))
          {
            PossibleMovesCalculator possibleMovesCalculator = new PossibleMovesCalculator(board, column, row);
            for(int i=0; i<possibleMovesCalculator.Moves.size(); i++)
            {
              MinimaxNode childNode = new MinimaxNode(board.Clone(), column, row, possibleMovesCalculator.Moves.get(i), nextPlayerHuman, depth + 1);
              this.childNodes.add(childNode);
            }
          }
        }
      }
      
      if(humanPlayer)
      {
        this.score = 0;
        for(int i = 0; i< this.childNodes.size(); i++)
        {
          if(this.childNodes.get(i).score > this.score)
          {
            this.score = this.childNodes.get(i).score; 
          }
        }
      }
      else
      {
        this.score = 0;
        for(int i = 0; i< this.childNodes.size(); i++)
        {
          if(this.childNodes.get(i).score < this.score)
          {
            this.score = this.childNodes.get(i).score; 
          }
        }
      }
    }
  }
}
