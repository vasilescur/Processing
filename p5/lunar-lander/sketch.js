var shipImg; // The standard rocket ship
var shipFireImg; // The rocket ship with fire

// Physics constants
const GRAVITY = 0.01;
const ENGINE = 0.03;

// Game constants
const END_HEIGHT = 30;
const ROT_SPEED = 0.1; // In radians per timestep
const MAX_VEL = 1; // Max ending velocity to win

// Initial Conditions
const INIT_POS_X = 100;
const INIT_POS_Y = 100;
const INIT_VEL_X = 2;
const INIT_VEL_Y = 0;

// Are these keys currently down?
var arrowUp = false;
var arrowDown = false;
var arrowLeft = false;
var arrowRight = false;

// Game control
var gameRunning = true;

// This makes sure the images load before runtime
function preload() {
    // Load rocket ship images
    shipImg = loadImage('ship.png');
    shipFireImg = loadImage('ship-fire.png');
}

// Setup sketch and canvas
function setup() {
    createCanvas(600, 800); // Size goes here
    background(color(0, 0, 0));

    // When drawing an image, make sure it's centered
    imageMode(CENTER);

    // Our player object
    player = new Player();
}

var player;

function draw() {
    // Handle input
    if (arrowUp) {
        player.firing = true;
    } else {
        player.firing = false;
    }

    if (arrowLeft) {
        player.heading -= ROT_SPEED;
    }

    if (arrowRight) {
        player.heading += ROT_SPEED;
    }

    // Physics tick
    player.update();

    if (gameRunning) {

        // Reset canvas
        background(color(0, 0, 0));

        // Draw the new player
        player.draw();

        // Draw the floor
        drawFloor();
    }
}

function keyPressed() {
    if (keyCode == UP_ARROW) {
        arrowUp = true;
    }

    if (keyCode == LEFT_ARROW) {
        arrowLeft = true;
    }

    if (keyCode == RIGHT_ARROW) {
        arrowRight = true;
    }
}

function keyReleased() {
    if (keyCode == UP_ARROW) {
        arrowUp = false;
    }

    if (keyCode == LEFT_ARROW) {
        arrowLeft = false;
    }

    if (keyCode == RIGHT_ARROW) {
        arrowRight = false;
    }
}

function drawFloor() {
    push();

    fill(color(100, 255, 150));
    stroke(color(50, 205, 100));
    strokeWeight(3);

    rect(0, height - END_HEIGHT, width, height);

    pop();
}

function endGame(state) {
    gameRunning = false;

    push();

    translate(0, 0);

    textSize(32);

    if (state == 'win') {
        // Win the game and stop.
        fill(color(50, 255, 100)); // Green
        text("You win!", width / 2 - 100, height / 2);
        console.log('You win.');
    } else if (state == 'lose') {
        // Lose the game and stop.
        fill(color(255, 50, 50)); // Red
        text("You lose.", width / 2 - 100, height / 2);
        console.log('You lose.');
    }

    pop();

    noLoop();
}

// Our beloved Player
class Player {
    // Initializes the player at the top
    constructor() {
        // Position
        this.posX = INIT_POS_X;
        this.posY = INIT_POS_Y;

        // Velocity
        this.velX = INIT_VEL_X;
        this.velY = INIT_VEL_Y;

        // Engine
        this.firing = false;

        // Orientation/rotation (in radians)
        this.heading = 0;
    }

    // Draw the appropriate sprite
    draw() {
        // Save the current state
        push();

        // Rotate the coordinate system by the ship heading
        translate(this.posX, this.posY);
        rotate(this.heading);
        translate(-this.posX, -this.posY);

        // Draw the ship
        if (this.firing) {
            image(shipFireImg, this.posX, this.posY);
        } else {
            image(shipImg, this.posX, this.posY);
        }

        // Restore state
        pop();
    }

    // Physics tick (and handle engine)
    update() {
        // Apply gravity
        this.velY += GRAVITY;

        // Apply velocity to position
        this.posX += this.velX;
        this.posY += this.velY;

        // If engine firing, accelerate *forwards*
        if (this.firing) {
            this.velX += ENGINE * Math.sin(this.heading); //TODO
            this.velY -= ENGINE * Math.cos(this.heading);
        }

        if (this.posY >= height - END_HEIGHT - 40) {
            if (this.velY > MAX_VEL) {
                endGame('lose');
            } else {
                endGame('win');
            }
        }
    }
}