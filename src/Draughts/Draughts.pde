static final int BOARD_LEFT_MARGIN = 50;
static final int BOARD_TOP_MARGIN = 50;
static final int CELL_WIDTH = 60;
static final int CELL_HEIGHT = 60;

Board board;

void setup() 
{
  size(1200, 800);
  background(120, 120, 120);
  board = new Board();  
}

void draw() 
{ 
  DrawBoard();
} 

void DrawBoard()
{
  fill(0, 0, 0);
  rect(BOARD_LEFT_MARGIN,
       BOARD_TOP_MARGIN,
       CELL_WIDTH * Board.BOARD_WIDTH,
       CELL_HEIGHT * Board.BOARD_HEIGHT);
  
  int counter = 0;
  for(int x=0; x<Board.BOARD_WIDTH; x++)
  {
    for(int y=0; y<Board.BOARD_HEIGHT; y++)
    {
      stroke(0);
      strokeWeight(0);

      if(counter % 2 == 0)
      {
        DrawWhiteSquare(x, y);
      }
      else
      {
        DrawBlackSquare(x, y);
      }
      counter++;      
      
      boolean mouseOver = false;
      if(
        (mouseX > (BOARD_LEFT_MARGIN + (x * CELL_WIDTH))) && 
        (mouseX < (BOARD_LEFT_MARGIN + ((x + 1) * CELL_WIDTH))) && 
        (mouseY > (BOARD_TOP_MARGIN + (y * CELL_HEIGHT))) && 
        (mouseY < (BOARD_TOP_MARGIN + ((y + 1) * CELL_HEIGHT))))
      {         //<>//
        stroke(255, 0, 0);
        strokeWeight(3);        
      } else {
        stroke(0);
        strokeWeight(0);
      }
      
      switch(board.pieces[x][y])
      {
        case Board.COMPUTER_MAN:
          this.DrawComputerMan(x,y);
          break;
        case Board.HUMAN_MAN:
          this.DrawHumanMan(x,y);
          break;
        case Board.COMPUTER_KING:
          this.DrawComputerKing(x,y);
          break;
        case Board.HUMAN_KING:
          this.DrawHumanKing(x,y);
          break;
      }
      
    }
    counter++;
  }
}

void DrawBlackSquare(int x, int y)
{
  fill(0, 0, 0);
  DrawSquare(x, y);
}

void DrawWhiteSquare(int x, int y)
{
  fill(255, 255, 255);
  DrawSquare(x, y);
}

void DrawSquare(int x, int y) 
{
  rect(BOARD_LEFT_MARGIN + (x * CELL_WIDTH),
       BOARD_TOP_MARGIN + (y * CELL_HEIGHT),
       CELL_WIDTH,
       CELL_HEIGHT);
}

void DrawHumanMan(int x, int y)
{
  fill(255, 255, 120);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4); 
}

void DrawComputerMan(int x, int y)
{
  fill(120, 120, 120);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4);
}

void DrawHumanKing(int x, int y)
{
  fill(255, 255, 120);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4); 
  fill(120, 120, 60);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 20,
          CELL_HEIGHT - 20);
}

void DrawComputerKing(int x, int y)
{
  fill(120, 120, 120);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4);
  fill(90, 90, 90);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 20,
          CELL_HEIGHT - 20);
}
