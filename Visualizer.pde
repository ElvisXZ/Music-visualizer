/*
    Author: Elvis Lin
    Date: 4/26/19

    This code is a music visualizer with enhanced effect.
    Requires a music file in the same directory to run.
    Works well with songs that have high amplitude (i.g. guitar, drum, etc).

*/

import ddf.minim.analysis.*;
import ddf.minim.*;
import peasy.*;

Minim minim;
AudioPlayer player;
FFT fft;
PeasyCam cam;

float[] angle1;
float[] angle2;
float[] y, x;
Dot[] dot;
Shape[] shapes;
int dot_amt = 300;
int shape_amt = 200;
float speed;
PVector pt;
float val;
BeatDetect beat;
BeatListener bl;

float kickSize, snareSize, hatSize; // kickdrum/snaredrum/hi-hats

// setup
void setup(){
    size(400,400, P3D);
    //fullScreen(P3D);
    smooth(8);

    spotLight(255, 0, 0, width/2, height/2, 400, 0, 0, -1, PI/4, 2);

    // minim load and play
    minim = new Minim(this);
    
    String song_file = "/music/bgm3.mp3";
    
    player = minim.loadFile(song_file, 1024);
    //player = minim.loadFile("/music/bgm2.mp3", 1024);
    //player = minim.loadFile("/music/death_note_tribute.mp3", 1024);
    
    player.play();
    
    // beat detector
    beat = new BeatDetect(player.bufferSize(), player.sampleRate());
    beat.setSensitivity(300);  
    kickSize = snareSize = hatSize = 16;
    bl = new BeatListener(beat, player);  

    // fft
    fft = new FFT(player.bufferSize(), player.sampleRate());
    y = new float[fft.specSize()];
    x = new float[fft.specSize()];
    angle1 = new float[fft.specSize()];
    angle2 = new float[fft.specSize()];
    dot = new Dot[dot_amt];
    shapes = new Shape[shape_amt];

    // initialize dot class
    for(int i = 0; i <dot_amt;i++){
        dot[i] = new Dot(450.0, random(0.1,1), 30);
    }    

    // initialize shape class
    pt = new PVector(mouseX,mouseY);
    String shape;
    for (int i = 0; i < shape_amt; i++) {
        if(random(0,1) < 0.5){ // set random ellipse or cube
            shape = "ell";
        }
        else{
            shape = "cube";
        }
        shapes[i] = new Shape(shape);
    }
  
    frameRate(120);
    player.loop();
}

// draw
void draw(){
    background(0);
    noStroke();
    fft.forward(player.mix);
    
    // center sphere
    orb(1, 2, 2, 20, 10);
    orb(2, 2, 2, 40, 10);
    orb(3, 2, 2, 80, 20);
    orb(4, 2, 2, 80, 20);
    
    border();
    dots(); // center dots and background
    moving_shape(); // background moving shapes
}

// center sphere 
void orb(int dir, int a, int b, int c, int d){

    pushMatrix();
    translate(width/2, height/2, 0);
    for (int i = 0; i < fft.specSize(); i++){
        angle2[i] = angle2[i] + fft.getFreq(i)/10000;
        // rotate accordingly
        if(dir == 1){
            rotateX(sin(angle2[i]/2));
            rotateY(cos(angle2[i]/2));
        }
        if(dir == 2){
            rotateZ(sin(angle2[i]/2));
        }        
        
        if(dir == 3){
            rotateZ(sin(angle2[i]/2));
            rotateY(sin(angle2[i]/4));
        }
        
        if(dir == 4){
            rotateZ(sin(angle2[i]/2));
            rotateY(sin(angle2[i]/4));
        }
        
        val = constrain(fft.getBand(i), 0, 20);
        color c1 = color(fft.getFreq(i)*6, fft.getFreq(i), val*2);
        fill(c1);

        pushMatrix();
        // translate accordingly
        if(dir == 1){
            translate((x[i]*player.right.get(i)+450), (y[i]*player.right.get(i))*200);
        }

        if(dir == 2 || dir == 3){
            translate((x[i]*player.right.get(i)+500), (y[i]*player.right.get(i))+150);
        }
        if(dir == 4){
            translate((x[i]*player.right.get(i)+400), (y[i]*player.right.get(i))+150);
        }
        rect(-fft.getFreq(i)/a, -fft.getFreq(i)/b,fft.getFreq(i)/c, fft.getFreq(i)/d);
        popMatrix();
    }
    popMatrix();
    

}

// the corner border
void border(){

    float p_bv = fft.getBand(0);
    float multiplyer = 2;
    for(int i = 1; i < fft.specSize(); i++)
    {
        float bv = fft.getBand(i)*(1 + (i/50));
        
        pushMatrix();

        // detect kick, snare, hihat noise
        val = constrain(fft.getBand(i), 0, 20);
        color c = color(fft.getFreq(i)*6, fft.getFreq(i), val*2);
        if ( beat.isKick() ) c = color(fft.getFreq(i)*10, fft.getFreq(i)*10, val*10);
        if ( beat.isSnare() ) c = color(fft.getFreq(i)*10, fft.getFreq(i)*10, val*10);
        if ( beat.isHat() ) c = color(fft.getFreq(i)*10, fft.getFreq(i)*10, val*10);
        stroke(c);
        
        //bot left
        line(0, height- (p_bv*multiplyer), 0, height - (bv*multiplyer) );
        line(0, height- (p_bv*multiplyer), (bv*multiplyer), height);
        
        //bot right
        line(width, height - (p_bv*multiplyer), width, height - (bv*multiplyer));
        line(width, height - (p_bv*multiplyer), width - (bv*multiplyer), height);
        
        //top left
        line(0, (p_bv*multiplyer), 0, (bv*multiplyer));
        line(0, (p_bv*multiplyer), (bv*multiplyer), 0);

        //top left
        line(width, (p_bv*multiplyer), width, (bv*multiplyer));
        line(width, (p_bv*multiplyer), width - (bv*multiplyer), 0);
        popMatrix();

        p_bv = bv;
  }
}

// center dots
void dots(){
    pushMatrix();
    noStroke();
    translate(width/2,height/2);
    float freq = fft.getFreq(0);
    for(int i = 0;i <dot.length;i++){
      
        int i2 = int(constrain(i, 0, fft.specSize()));
        val = constrain(fft.getBand(i2), 0, 20);
        color c = color(fft.getFreq(i2)*6, fft.getFreq(i2), val*2);
        dot[i].setSpeed(freq/10);
        dot[i].display(c, freq/2);
        dot[i].move();
  }
    popMatrix();

}

// background moving cubes/dot
void moving_shape(){
    pushMatrix();

    // determine speed based on amplitude
    float bv = fft.getBand(0);
    if (bv >= 20){
        speed = bv/4;
    }
    else if(bv <= 1){
        speed = 0;
    }    
    else if(bv <= 2){
        speed = 1;
    }    
    else{
        speed = 2;
    }

    // update/display shape
    for (int i = 0; i < shapes.length; i++) {
        int i2 = int(constrain(i, 0, fft.specSize()));
        //print("%d" , (fft.getFreq(i2)*4));
        val = constrain(fft.getBand(i2), 0, 20);
        color c = color(fft.getFreq(i2)*6, fft.getFreq(i2), val*2);
        shapes[i].update(speed);
        shapes[i].transform(pt);
        shapes[i].checkEdge();
        shapes[i].show(c, bv);
    }

    popMatrix();  

}

void stop(){
    player.close();
    minim.stop();
    super.stop();
}

// update mouse location
void mouseMoved(){
    pt.x = mouseX;
    pt.y = mouseY;
}
