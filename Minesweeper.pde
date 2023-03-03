import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
public final static int NUM_ROWS = 20;
public final static int NUM_COLS = 20;
public final static int minesCount = 30;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()  {
  size(400, 400);
  textAlign(CENTER, CENTER);
  
  // make the manager
  Interactive.make( this );

  //your code to initialize buttons goes here
  buttons = new MSButton[NUM_ROWS][NUM_COLS]; // first call to new
   for (int r = 0; r < NUM_ROWS; r++){
     for (int c = 0; c < NUM_COLS; c++){
       buttons[r][c] = new MSButton(r,c); // second call to new
     }
   }
  setMines();
}
public void setMines()  {
  while(mines.size() != minesCount) {
    int mineRow = (int)(Math.random()*NUM_ROWS-1);
    int mineCol = (int)(Math.random()*NUM_COLS);
    if (!mines.contains(buttons[mineRow][mineCol]))
      mines.add(buttons[mineRow][mineCol]);
  }
}

public void draw ()  {
  background( 0 );
  if (isWon() == true)
    displayWinningMessage();
}
public boolean isWon()  {
  int minesSpotted = 0;
  for (int i = 0; i < mines.size(); i++){
    if (mines.get(i).isFlagged() == true)
      minesSpotted++;
  }
  return (minesSpotted == minesCount);
}
public void displayLosingMessage()  {
  for(int i=0;i<mines.size();i++){
        if(mines.get(i).isClicked()==false)
            mines.get(i).mousePressed();
  }
  String loser = "YOU LOSE!!";
  for (int i = 0; i < loser.length(); i++){
    buttons[10][5+i].setLabel(loser.substring(i, i+1));
  }
}
public void displayWinningMessage()  {
  String winner = "YOU WIN!";
  for (int i = 0; i < winner.length(); i++){
    buttons[10][6+i].setLabel(winner.substring(i, i+1));
  }
}
public boolean isValid(int r, int c)  {
  return r < NUM_ROWS && c < NUM_COLS && r >= 0 && c>=0;
}
public int countMines(int row, int col)  {
  int numMines = 0;
  for (int r = row-1; r <= row+1; r++){
    for (int c = col-1; c <= col+1; c++) {
      if (isValid(r,c) && mines.contains(buttons[r][c]))
        numMines++;
      if (mines.contains(buttons[row][col]))
        numMines--;
    }
  }
  return numMines;
}

public class MSButton  {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged;
  private String myLabel;

  public MSButton ( int row, int col )  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add( this ); // register it with the manager
  }

  // called by manager
  public void mousePressed ()  {
    clicked = true;
    if (mouseButton == RIGHT){
      if (flagged == false)
        clicked = false;
      flagged =! flagged;
    }
    else if (mines.contains(this))
      displayLosingMessage();
    else if (countMines(myRow,myCol) > 0)
      setLabel(countMines(myRow,myCol));
    else {
      for(int r = myRow-1; r<=myRow+1;r++)
      for(int c = myCol-1; c<=myCol+1;c++)
        if(isValid(r,c)&&!buttons[r][c].clicked)
           buttons[r][c].mousePressed();
    }
  }
  public void draw () {
    if (isWon())
      displayWinningMessage();
    if (flagged)
      fill(242, 229, 46);
    else if( clicked && mines.contains(this) ) 
         fill(255,0,0);
    else if (clicked)
      fill(103, 141, 201);
    else 
    fill(23, 73, 153);

    rect(x, y, width, height);
    fill(0);
    text(myLabel, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    textSize(15);
    myLabel = newLabel;
  }
  public void setLabel(int newLabel)
  {
    textSize(15);
    myLabel = ""+ newLabel;
  }
  public boolean isFlagged()
  {
    return flagged;
  }
  public boolean isClicked()
  {
    return clicked;
  }
}
