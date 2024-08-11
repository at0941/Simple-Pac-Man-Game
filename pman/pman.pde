// Pacman variables
float pacmanX = width*4;
float pacmanY = height;
float mouthAngleStart = radians(60);
float mouthAngleEnd = radians(300);
float direction;
boolean mouthOpen = true;
boolean movingEast = true;

// Pellets and Fruits
int[] path =  {20, 60, 100, 140, 180, 220, 260, 300, 340, 380, 420, 460, 500, 540, 580, 620, 660, 700, 740, 780};
PVector[] pellets = new PVector[path.length];
int fruitX = path[floor(random(path.length))];

// Ghost variables
float ghostX = path[floor(random(path.length))];
float invulnerabilityTimer = 0;
int swapRandomiser;
boolean invulnerable = false;
boolean swapDirection = false;

// Score and game state
int score = 0;
boolean gameOver = false;

void setup() {
  size(800, 200);
  for (int i = 0; i < path.length; i++) {
    pellets[i] = new PVector(path[i], height/2);
  }
}

void draw() {
  background(0);
  drawScore();
  drawTrack();
  drawPellets();
  drawFruit();
  drawPacman();
  drawGhost();
}

void keyPressed() {
  // Swaps direction when SPACE is presssed
  if (key == ' ' && !gameOver) {
    movingEast = !movingEast;
  }
}

void drawScore() {
  // Displays score
  fill(255);
  textAlign(CENTER);
  textSize(12);
  text("Score: ", 25, 25);
  text(int(score), 50, 25);

  // Displays game over
  if (gameOver) {
    fill(255);
    textSize(20);
    text("GAME OVER", width/2, height/2-70);
    if (movingEast) {
      pacmanX -= 2.5;
    } else {
      pacmanX +=2.5;
    }
    if (mouthOpen) {
      mouthAngleStart += 0.1;
      mouthAngleEnd -= 0.1;
    } else {
      mouthAngleStart -= 0.1;
      mouthAngleEnd += 0.1;
    }
    if (swapDirection) {
      ghostX+= 3;
    } else {
      ghostX-= 3;
    }
  }
}

void drawTrack() {
  // Draws the track
  stroke(0, 0, 255);
  strokeWeight(10);
  line(0, height/2 - 50, 800, height/2 - 50);
  line(0, height/2 + 50, 800, height/2 + 50);
}

void drawPellets() {
  // Pellets and hitbox detection
  noStroke();
  fill(255);
  for (int i = 0; i <pellets.length; i++) {
    circle(pellets[i].x, pellets[i].y, 5);
    if (pacmanX == pellets[i].x && pacmanY == pellets[i].y) {
      eatPellet(i);
      score +=1;
    }
    if (score%20 == 0) {
      resetPellets(i);
    }
  }
}

void drawFruit() {
  // Fruits and hitbox detection
  fill(255, 0, 0);
  circle(fruitX, height/2, 10);
  if (pacmanX == fruitX) {
    invulnerabilityTimer = 0;
    fruitX = path[floor(random(path.length))];
    invulnerable = true;
  } else if (invulnerabilityTimer >= 180) {
    invulnerable = false;
  }
}

void drawPacman() {
  // Draws Pacman
  noStroke();
  fill(255, 255, 0);
  arc(pacmanX, pacmanY, 30, 30, direction + mouthAngleStart, direction + mouthAngleEnd, PIE);
  if (mouthOpen) {
    mouthAngleStart -= 0.1;
    mouthAngleEnd += 0.1;
  } else {
    mouthAngleStart += 0.1;
    mouthAngleEnd -= 0.1;
  }
  if (mouthAngleStart<radians(0) || mouthAngleStart > radians(60)) {
    mouthOpen =!mouthOpen;
  }

  // Movement
  if (pacmanX>830) {
    pacmanX = -30;
  } else if (pacmanX <  -30) {
    pacmanX = 830;
  }

  // Swaps direction
  if (movingEast) {
    pacmanX += 2.5;
    direction = atan2(-direction, pacmanY);
  } else {
    pacmanX -= 2.5;
    direction = atan2(-direction, -pacmanY);
  }

  //Hitbox detection with ghost
  if (dist(pacmanX, height/2, ghostX, height/2) < 10 && !invulnerable) {
    gameOver = true;
  }
}

void drawGhost() {
  // Invulnerability and colour
  swapRandomiser = int(random(100));
  if (invulnerable) {
    fill(200);
    invulnerabilityTimer++;
  } else {
    fill(220, 30, 230);
  }

  // Draws the ghost
  rectMode(CENTER);
  square(ghostX, height/2+5, 20);
  circle(ghostX, height/2-5, 20);
  fill(255);
  circle(ghostX-5, height/2-2, 10);
  circle(ghostX+5, height/2-2, 10);
  fill(0, 0, 255);
  circle(ghostX-5, height/2-2, 5);
  circle(ghostX+5, height/2-2, 5);

  // Ghost movement
  if (swapRandomiser == 1) {
    swapDirection = !swapDirection;
  }
  if (swapDirection) {
    ghostX-=3;
  } else {
    ghostX+=3;
  }
  if (ghostX > width+20) {
    ghostX = -20;
  } else if (ghostX < -20) {
    ghostX = width+20;
  }
}

// Detects eaten pellets
void eatPellet(int index) {
  pellets[index].y += height;
}

// Resets all pellets after they're all eaten
void resetPellets(int index) {
  pellets[index].y = height/2;
}
