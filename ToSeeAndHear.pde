/***********************************************************************/
/*       This code was written by Owen Herterich in Spring 2013        */
/*      owenherterich.com | oherterich@gmail.com | @owenherterich      */
/* Included sample text is of The Great Gatsby, by F. Scott Fitzgerald */
/***********************************************************************/

String bookText[]; //String used to store initial text
String bookName; //String used to load initial txt of book
boolean quote; //this boolean acts as a switch, turning on/off when quotation marks (dialogue) is found

//These variables will be used to count the number of quotes and other sentences in the text
int numQuote;
int numOther;

PFont f;

float theta = 0; //this number will be used to draw the text of the quotes at an angle around a circle
float r = 1000; //radius of the inner circle in the visualization

void setup() {


  background(244);

  f = createFont("Dekar-10", 12, true);

  //Initialize these variables to 0 because we haven't yet analyzed text.
  numQuote = 0;
  numOther = 0;

  smooth();

  bookName = "gatsby";

  bookText = loadStrings(bookName + ".txt"); //Load our txt file.

  quote = false; //Set quote boolean to false (otherwise we will be finding everything that is NOT dialogue)
}

void draw() {
  makeFlower(); //Run our function that creates the visualization

  println("DONE");
  exit();
}

//This is where the real meat of the sketch lies.
void makeFlower() {
  size(8000, 8000); //makeQuote

  theta = -PI/2; //Start the angle at the top (12 o clock on a clock)

  float count = 0;

  //We will now parse out all punctuation from the text (except for quotation marks)
  //Put this into a new array
  String words[];
  words = splitTokens(bookText[0], " ,.?!:;[]-");

  //Coordinates we will use when drawing the words to the screen.
  float x = 0;
  float y = 0;

  strokeCap(SQUARE);
  strokeWeight(5);

  fill(0);

  //The initial radius of the circle changes depending on how long the
  //book is. Map the length of our string array to change this.
  float initRad = map(words.length, 30000, 300000, 350, 800);
  r = initRad;

  //This will be the value that we use to iterate the angle of our dialogue
  //around the circle. Calculate by dividing TWO_PI by the number of quotes.
  //EX. If there are 360 pieces of dialogue, the lines will be rotated 1 degree each time.
  float value = TWO_PI/(findNumQuotes());
  
  //Let's loop through all of the words in our text file (minus punctuation)
  for (int i=0; i<words.length; i++) {
    //If we find a quotation mark, turn the quote switch on/off and add to the rotation
    if (words[i].equals("\"")) {
      quote = !quote;
      theta += value;
      //Find another initial radius with an offset. This is how the textured look is made.
      r = initRad + (random(100));
    }//

    //If quote is true (meaning we are looking at words within a piece of dialogue), start drawing stuff
    if (quote == true) {
      stroke(40);
      fill(random(0, 40));
      
      numQuote++; //Add to our count of quotes
      
      //We don't want to draw the actual quotation marks themselves on the screen,
      //so only draw text if it DOES NOT equal a quotation mark
      if (words[i].equals("\"") == false) {
        
        //Use some simple matrix transformations to draw the text in the correct position
        pushMatrix();
        translate(x, y);
        rotate(theta);
        text(words[i], 0, 0);
        popMatrix();
      }

      //This next bit of code gives us the x and y of the next word.
      //This depends on the width of the previous word.
      float w = textWidth(words[i]);
      r += w+3;
      x = cos(theta) * r + width/2;
      y = sin(theta) * r + height/2;

      //Some of these quotes would extend out very very far into space if we let them.
      //This returns the line to the initial radius if it gets too long
      if (r>=1600) {
        theta += value;
        r = initRad + (random(100));
      }
    }
  }
  
  textFont(f, 6);
  save(bookName + "/" + bookName + ".png"); //Save the image into a new folder
}


//This function finds the number of quotes present in the text.
//We need this function in order to figure out the angle in which
//to iterate the lines of dialogue around the circle.
//Less dialogue means greater increases in angle for each line.
int findNumQuotes() {
  int count = 0; //Start our number at 0

  //We will now parse out all punctuation from the text (except for quotation marks)
  String words[];
  words = splitTokens(bookText[0], " ,.?!:;[]-");


  //Loop through all of the words. If we find a quotation mark, change the 
  //quote boolean and increase the number of pieces of dialogue found.
  for (int i=0; i<words.length; i++) {
    if (words[i].equals("\"")) {
      quote = !quote;
      count++;
    }
  }
  return count;
}

