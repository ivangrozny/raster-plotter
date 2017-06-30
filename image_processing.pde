import processing.pdf.*;
boolean isRecording = false;
import drop.*; SDrop drop;
PImage img;
String fileName = "mire";

void setup() {
  size(2000, 1200);
  midibusSetup(0, 127);
  drop = new SDrop(this);
  img = loadImage("grad.jpg");
  noLoop();
}

void draw() {
    loadPixels();
  slider[0] = 13; // ppp (size between points)
  slider[1] = 24; // time max

  float D = 1; // point size
  int ppp = int(slider[0]);

  if (isRecording) beginRecord(PDF, fileName+"_Siz-"+D+"_Ppp-"+slider[0]+"_Tmp-"+slider[1]+"_raster-plotter.pdf");
  if (isRecording) println("begin PDF");
  float scale = map( knob[0],0,127, 0,1 );
  scale (scale, scale);
  translate(knob[1], knob[2]);
  if (isRecording) { stroke(0); noFill(); }
  if (!isRecording) {
    background(255);
    fill(0);
	noStroke();
	ellipseMode(CENTER);
  }
  for (int x=0; x<img.width; x+=ppp) {
    for (int y=0; y<img.height-ppp/2; y+=ppp+ppp/7) {

        int posY = ((x/ppp)%2==0)? y+ppp/2 : y ;  // quinquonce
        float contact = map(brightness( img.pixels[x+posY*img.width] ),0,255,slider[1],0);
        //contact = slider[1]-sqrt( slider[1]*slider[1]-contact*contact );   //  curve: a-sqrt( 1-x²+a² )
        contact = contact*contact / slider[1] ;   //  curve: x² / a
        if( isRecording ){
    		beginShape();

            //print(contact+"  -   ");
      		for (int i = 0; i < contact; ++i){
    			switch ( i%4 ) {
                    case 0 : vertex(x, posY); break;
    	  			case 1 : vertex(x+D, posY); break;
    	  			case 2 : vertex(x+D, posY+D); break;
    	  			case 3 : vertex(x, posY+D); break;
    	  		}
    		}
            float dec = ( contact-floor(contact) )*D ;
            switch ( ceil(contact-1)%4 ) {
                case 0 : vertex(x+dec, posY); break;
                case 1 : vertex(x+D, posY+dec); break;
                case 2 : vertex(x+D-dec, posY+D); break;
                case 3 : vertex(x, posY+D-dec); break;
            }
            //println("---");

    		endShape();
	    }
        if (!isRecording){
            if(key!=' ') ellipse(x, posY, floor(contact)+5, floor(contact)+5 );
            if(key==' ') text(floor(contact), x, posY);
        }
    }
  }

  if (isRecording) {
    endRecord();
    isRecording = false;
    println("PDF");
  }
}

void mousePressed() {}
void dropEvent(DropEvent theDropEvent){ img = theDropEvent.loadImage(); redraw();}
void keyPressed() {
  if(key == 's') exportMidibus();
  if(key == 'i') importMidibus();
  redraw();
}
