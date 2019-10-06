static final int BOARD_WIDTH = 8;
static final int BOARD_HEIGHT = 8;
static final int BOARD_LEFT_MARGIN = 50;
static final int BOARD_TOP_MARGIN = 50;
static final int CELL_WIDTH = 70;
static final int CELL_HEIGHT = 70;

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
       CELL_WIDTH * BOARD_WIDTH,
       CELL_HEIGHT * BOARD_HEIGHT);
  
  int counter = 0;
  for(int x=0; x<BOARD_WIDTH; x++)
  {
    for(int y=0; y<BOARD_WIDTH; y++)
    {
      if(counter % 2 == 0)
      {
        DrawWhiteSquare(x, y);
      }
      else
      {
        DrawBlackSquare(x, y);
      }
      counter++;
    }
    counter++;
  }
  DrawWhiteCircle(0, 1);
  DrawBlackCircle(0, 0);
}

void DrawBlackSquare(int x, int y)
{
  stroke(0, 0, 0);
  fill(0, 0, 0);
  DrawSquare(x, y);
}

void DrawWhiteSquare(int x, int y)
{
  stroke(255, 255, 255);
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

void DrawWhiteCircle(int x, int y)
{
  stroke(255, 255, 255);
  fill(0,0,0);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4);
  
}

void DrawBlackCircle(int x, int y)
{
  stroke(0, 0, 0);
  fill(255, 255, 255);
  ellipse(BOARD_LEFT_MARGIN + (x * CELL_WIDTH) + (CELL_WIDTH / 2),
          BOARD_TOP_MARGIN + (y * CELL_HEIGHT) + (CELL_HEIGHT / 2),
          CELL_WIDTH - 4,
          CELL_HEIGHT - 4);
}
