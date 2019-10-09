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
    for(int column = 0; column < Board.BOARD_WIDTH; column++)
    {    
      for(int row = 0; row < Board.BOARD_HEIGHT; row++)
      {
        if(counter % 2 == 1)
        {
          if(row < COMPUTER_ROWS)
          {
            this.pieces[column][row] = COMPUTER_MAN;
          }
          else if(row >= (BOARD_HEIGHT - HUMAN_ROWS))
          {
            this.pieces[column][row] = HUMAN_MAN;
          }
          else
          {
            this.pieces[column][row] = EMPTY;
          }
        }
        else
        {
          this.pieces[column][row] = EMPTY;
        }
        counter++;
        
        print(pieces[column][row]);
      }
      print("\n");
      counter++;
    }    
  }
}
