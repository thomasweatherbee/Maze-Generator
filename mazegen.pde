int cellSize = 4;
ArrayList<ArrayList<cell>> cells = new ArrayList<ArrayList<cell>>();
ArrayList<Integer> stack = new ArrayList<Integer>();
ArrayList<Integer> solutionStack = new ArrayList<Integer>();
int[] naviLoc = {0, 0};
boolean solutionSet = false;
int[] solLoc = {0, 0};
int[] pastSolLoc = {0, 0};
int iter = 0;

void setup() {
  size(1280, 720);
  frameRate(600);
  colorMode(RGB);
  for (int i = 0; i < width/cellSize; i++) {
    cells.add(new ArrayList<cell>());
    for (int j = 0; j < height/cellSize; j++) {
      cells.get(i).add(new cell(i, j));
    }
  }
  //noLoop();
}

void draw() {
  background(40);
  if (!solutionSet) {
    while (true) {
      cells.get(naviLoc[0]).get(naviLoc[1]).beenHere = true;
      int[] placesToGo = {0, 0, 0, 0};
      int dir = 0;
      if (naviLoc[0] > 0) { //Left edge
        if (cells.get(naviLoc[0]-1).get(naviLoc[1]).beenHere == false) {
          placesToGo[0] = 1;
        }
      }
      if (naviLoc[0] < (width/cellSize) - 1) { //Right edge
        if (cells.get(naviLoc[0]+1).get(naviLoc[1]).beenHere == false) {
          placesToGo[1] = 1;
        }
      }
      if (naviLoc[1] > 0) { //Top Edge
        if (cells.get(naviLoc[0]).get(naviLoc[1]-1).beenHere == false) {
          placesToGo[2] = 1;
        }
      }
      if (naviLoc[1] < (height/cellSize) - 1) { //Bottom Edge
        if (cells.get(naviLoc[0]).get(naviLoc[1]+1).beenHere == false) {
          placesToGo[3] = 1;
        }
      }
      if (arraySum(placesToGo) > 0) {    
        while (true) {
          int randDir = int(random(4));
          if (placesToGo[randDir] == 1) {
            dir = randDir;
            stack.add(dir);
            break;
          }
        }
      } else {
        dir = stack.get(stack.size()-1);
        if (dir == 2) {
          dir = 3;
        } else if (dir == 3) {
          dir = 2;
        } else if (dir == 0) {
          dir = 1;
        } else if (dir == 1) {
          dir = 0;
        }
        stack.remove(stack.size()-1);
      }
      if (dir == 0) { //left right up down :: top right down left
        cells.get(naviLoc[0]).get(naviLoc[1]).removeWall(3);
        naviLoc[0]--;
        cells.get(naviLoc[0]).get(naviLoc[1]).removeWall(1);
      } else if (dir == 1) {
        cells.get(naviLoc[0]).get(naviLoc[1]).removeWall(1);
        naviLoc[0]++;
        cells.get(naviLoc[0]).get(naviLoc[1]).removeWall(3);
      } else if (dir == 2) {
        cells.get(naviLoc[0]).get(naviLoc[1]).removeWall(0);
        naviLoc[1]--;
        cells.get(naviLoc[0]).get(naviLoc[1]).removeWall(2);
      } else if (dir == 3) {
        cells.get(naviLoc[0]).get(naviLoc[1]).removeWall(2);
        naviLoc[1]++;
        cells.get(naviLoc[0]).get(naviLoc[1]).removeWall(0);
      }
      if (naviLoc[0] == width/cellSize - 1 && naviLoc[1] == height/cellSize - 1 && solutionSet == false) {
        for (int i = 0; i < stack.size(); i++) {
          solutionStack.add(stack.get(i));
        }
        solutionSet = true;
      }
      if (stack.size() == 0) {
        break;
        //noLoop();
      }
    }
  }
  for (int i = 0; i < cells.size(); i++) {
    for (int j = 0; j < cells.get(i).size(); j++) {
      cells.get(i).get(j).show();
    }
  }
  fill(255, 51, 0);
  stroke(255, 51, 0);
  strokeWeight(2);
  point(naviLoc[0] * cellSize + cellSize/2, naviLoc[1] * cellSize + cellSize/2);
  displaySolution();
  {
    stroke(255, 51, 0);
    strokeWeight(2);
      line(solLoc[0] * cellSize + cellSize/2, solLoc[1] * cellSize + cellSize/2, pastSolLoc[0] * cellSize + cellSize/2, pastSolLoc[1] * cellSize + cellSize/2);
      pastSolLoc[0] = solLoc[0];
      pastSolLoc[1] = solLoc[1];
      if (solutionStack.get(iter) == 0) { //left right up down :: top right down left
        solLoc[0]--;
      } else if (solutionStack.get(iter) == 1) {
        solLoc[0]++;
      } else if (solutionStack.get(iter) == 2) {
        solLoc[1]--;
      } else if (solutionStack.get(iter) == 3) {
        solLoc[1]++;
      }
    line(solLoc[0] * cellSize + cellSize/2, solLoc[1] * cellSize + cellSize/2, pastSolLoc[0] * cellSize + cellSize/2, pastSolLoc[1] * cellSize + cellSize/2);
  }
  if(iter > solutionStack.size()){
    noLoop();
  }
}

void displaySolution() {
  int[] solLoc = {0, 0};
  int[] pastSolLoc = {0, 0};
  stroke(255, 51, 0);
  strokeWeight(2);
  for (int i = 0; i < solutionStack.size(); i++) {
    line(solLoc[0] * cellSize + cellSize/2, solLoc[1] * cellSize + cellSize/2, pastSolLoc[0] * cellSize + cellSize/2, pastSolLoc[1] * cellSize + cellSize/2);
    pastSolLoc[0] = solLoc[0];
    pastSolLoc[1] = solLoc[1];
    if (solutionStack.get(i) == 0) { //left right up down :: top right down left
      solLoc[0]--;
    } else if (solutionStack.get(i) == 1) {
      solLoc[0]++;
    } else if (solutionStack.get(i) == 2) {
      solLoc[1]--;
    } else if (solutionStack.get(i) == 3) {
      solLoc[1]++;
    }
  }
  line(solLoc[0] * cellSize + cellSize/2, solLoc[1] * cellSize + cellSize/2, pastSolLoc[0] * cellSize + cellSize/2, pastSolLoc[1] * cellSize + cellSize/2);
}

int arraySum(int[] x) {
  int sum = 0;
  for (int i = 0; i < x.length; i++) {
    sum += x[i];
  }
  return sum;
}

class cell {
  int xCoord;
  int yCoord;
  int[] status = {1, 1, 1, 1}; //top, right, bottom, left
  boolean beenHere = false;

  cell(int x, int y) {
    xCoord = x * cellSize;
    yCoord = y * cellSize;
  }

  void removeWall(int x) {
    status[x] = 0;
  }

  void show() {
    if (beenHere) {
      noStroke();
      fill(255);
      rect(xCoord, yCoord, cellSize, cellSize);
      stroke(40);
      strokeWeight(1);
      if (status[0] == 1) {
        line(xCoord, yCoord, xCoord + cellSize, yCoord);
      }
      if (status[1] == 1) {
        line(xCoord+cellSize, yCoord, xCoord+cellSize, yCoord+cellSize);
      }
      if (status[2] == 1) {
        line(xCoord, yCoord+cellSize, xCoord+cellSize, yCoord+cellSize);
      }
      if (status[3] == 1) {
        line(xCoord, yCoord, xCoord, yCoord+cellSize);
      }
    }
  }
}

void keyPressed() {
  if (key == 'w') {
    redraw();
  }
}
