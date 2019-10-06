class Board 
{
  static final int BOARD_WIDTH = 8;
  static final int BOARD_HEIGHT = 8;
  static final int COMPUTER_ROWS = 3;
  static final int HUMAN_ROWS = 3;
  
  static final int COMPUTER_MAN = 0;
  static final int COMPUTER_KING = 1;
  static final int HUMAN_MAN = 2;
  static final int HUMAN_KING = 3;
  static final int EMPTY = 4;
  
  int pieces[][];
  
  Board()
  {
    pieces = new int[BOARD_WIDTH][BOARD_HEIGHT];
    
    int counter=0; 
    for(int x=0; x<Board.BOARD_WIDTH; x++)
    {    
      for(int y=0; y<Board.BOARD_HEIGHT; y++)
      {
        if(counter % 2 == 1)
        {
          if(y<COMPUTER_ROWS)
          {
            this.pieces[x][y] = COMPUTER_MAN;
          }
          else if(y>= (BOARD_HEIGHT - HUMAN_ROWS))
          {
            this.pieces[x][y] = HUMAN_MAN;
          }
          else
          {
            this.pieces[x][y] = EMPTY;
          }
        }
        else
        {
          this.pieces[x][y] = EMPTY;
        }
        counter++;
        
        print(pieces[x][y]);
      }
      print("\n");
      counter++;
    }    
  }
}
