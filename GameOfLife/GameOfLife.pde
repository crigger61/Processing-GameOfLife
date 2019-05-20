import java.util.Arrays;

int sizeofblock=10;
boolean board[][];
boolean playing=false;
int speed=10;
boolean initialpress=true;
boolean pressedColor=false;
boolean bornSurv=false;

boolean[] born=new boolean[10];
boolean[] surv=new boolean[10];
void setup(){
  size(610,610);
  board=new boolean[(int)width/sizeofblock][(int)height/sizeofblock];
  noStroke();
  for(int i=0;i<board.length;i++){
    for(int j=0;j<board[i].length;j++){
      if(i%10<5 ^ j%10<5){
        if(i%5>=1 && i%5<=3 && j%5==2)
          board[i][j]=true;
      }else{
        if(i%5==2 && j%5>=1 && j%5<=3)
          board[i][j]=true;
      }
    }
  }
  
  //setup rules
  //Standard Conway  B3S23
  //Cool maze        B3S12345
  //Inverting Maze   B245678S
  born[3]=true;
  surv[2]=true;
  surv[3]=true;
  
}
void draw(){
  if(playing)
    frameRate(speed);
  else
    frameRate(240);
  noStroke();
  
  for(int i=0;i<board.length;i++){
    for(int j=0;j<board[i].length;j++){
      fill(board[i][j]?0:255);
      rect(i*sizeofblock,j*sizeofblock,sizeofblock,sizeofblock);
    }
  }
  
  int mi=(mouseX-1)/sizeofblock;
  int mj=(mouseY-1)/sizeofblock;
  
  if(mousePressed && !playing){
    if(initialpress)pressedColor=!board[mi][mj];
    initialpress=false;
    try{board[mi][mj]=pressedColor;}catch(Exception e){}
  }else if(!mousePressed)initialpress=true;
  
  stroke(128);
  fill(0,0);
  strokeWeight(1);
  
  rect(mi*sizeofblock,mj*sizeofblock,sizeofblock,sizeofblock);
  
  
  
  if(playing){
    processBoard();
  }
  
  print(frameRate+" "+speed+" "+(bornSurv?"born \tb[":"surv \tb["));
  for(int i=0;i<9;i++)
    print((born[i]?"x":" ")+",");
  print("] s[");
  for(int i=0;i<9;i++)
    print((surv[i]?"x":" ")+",");
  println("]");
  
  
}
void keyPressed(){
  switch(key){
    case 'r':
      genRandBoard();
      break;
    case 'c':
      clearBoard();
      break;
    case 'f':
      if(!playing)processBoard();
      break;
    case ' ':
      playing=!playing;
      break;
    case '[':
      speed-=1;
      break;
    case ']':
      speed+=1;
      break;
    case '{':
      speed-=5;
      break;
    case '}':
      speed+=5;
      break;
    case 'b':
      bornSurv=!bornSurv;
      break;
    default:
      try{
        int n=Integer.parseInt(key+"");
        if(bornSurv)
          born[n]=!born[n];
        else
          surv[n]=!surv[n];
      }catch(NumberFormatException e){}
      break;
  }
  if(speed<=0)
    speed=1;
}
/*
void mousePressed(){
  int mi=(mouseX-1)/sizeofblock;
  int mj=(mouseY-1)/sizeofblock;
  
}
*/
void processBoard(){
  boolean newboard[][]=new boolean[(int)width/sizeofblock][(int)height/sizeofblock];
  for(int i=0;i<board.length;i++){
    for(int j=0;j<board[i].length;j++){
      int c=numNeighbors(i,j);
      
      if(board[i][j]){
        newboard[i][j]=surv[c];
      }else{
        newboard[i][j]=born[c];
      }
      
    }
  }
  board=newboard;
}

int numNeighbors(int i, int j){
  int count=0;
  for(int ip=-1;ip<2;ip++){
    for(int jp=-1;jp<2;jp++){
      if(ip==0 && jp==0)continue;
      int[] p=properPoint(i+ip,j+jp);
      if(board[p[0]][p[1]])count++;
      
    }
  }
  return count;
}
int[] properPoint(int i,int j){
  if(i<0)i=board.length+i;
  else if(i>=board.length)i=i-board.length;
  if(j<0)j=board[i].length+j;
  else if(j>=board.length)j=j-board.length;
  return new int[]{i,j};
}

void genRandBoard(){
  for(int i=0;i<board.length;i++){
    for(int j=0;j<board[i].length;j++){
      board[i][j]=((int)random(2))==0;
    }
  }
}
void clearBoard(){
  for(int i=0;i<board.length;i++){
    for(int j=0;j<board[i].length;j++){
      board[i][j]=false;
    }
  }
}
