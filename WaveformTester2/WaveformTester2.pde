// Test waveform display

import ddf.minim.*;
Minim minim; 
AudioSample sound; 
AudioPlayer soundbis;
FloatList sampleAverage; 
int border, leftLength, rightLength; 

// Resolution of the display
int sizeOfAvg = 600;

// width adjustment for audio display
int widthScale = 300;

String soundfilePath = "data\\test-audio-file.wav";
 
public void loadSound(){
  minim = new Minim(this);
  sound = minim.loadSample(soundfilePath, 2048);
  soundbis = minim.loadFile(soundfilePath);
}
 
void setup() {
  
  loadSound();
  
  // time is 3min 30s & nb of samples is 9 115 000
  println(soundbis.bufferSize());
 
  size(200, 600);
  background(255);
  border = 10;
 
  //1. get samples values as if it was a mono file
  float[] leftSamples = sound.getChannel(AudioSample.LEFT);
  float[] rightSamples = sound.getChannel(AudioSample.RIGHT);
  float [] samplesVal = new float[rightSamples.length];
  for (int i=0; i <rightSamples.length; i++) {
    samplesVal[i] = leftSamples[i]+ rightSamples[i];
  }
  
  leftLength  = leftSamples.length;
  rightLength = rightSamples.length;
 
  //2. reduce quantity : get an average from those values each  16 348 samples
  sampleAverage = new FloatList();
  int average=0;
  for (int i = 0; i< samplesVal.length; i+=1) {
    average += abs(samplesVal[i] * widthScale) ; // sample are low value so we increase the size to see them
    
    if ( i % sizeOfAvg == 0 && i!=0) { 
      sampleAverage.append( average / sizeOfAvg);
      average = 0;
    }
  }
  
  // Play the sound file
  soundbis.play();
  
  // Debug info for timing
  float prevTime = -1;
  for ( int i=0; i < sampleAverage.size(); i++) {
    
    float time = round((i * sizeOfAvg) / sound.sampleRate());
    if(prevTime != time){
      prevTime = time;
      println("Time testing:" + time + " at index: " + i + " rounded: " + round(time));
    }
  }
}
 
void draw() {
  background(0);
  stroke(255);
  fill(190);
  strokeWeight(1);
  
  // Draw the waveform display and the time. Time is currenlty showing each second
  float prevTime = -1;
  for ( int i=0; i < sampleAverage.size(); i++) {
    
    // Draw the sound file
    line(width - border*2, -i + height - border, (width - border*2) - sampleAverage.get(i), -i + height - border);
    
    // Draw the text (time in seconds)
    float time = floor((i * sizeOfAvg) / sound.sampleRate());
    if(prevTime != time){
      prevTime = time;
      //text(round(time), i + border, height-border/2);
      text(round(time), width - border, height - i - border);
    }
  }
  
  // Draw the play head (red line moving across)
  strokeWeight(2);
  stroke(#ff0000);
  float ypos = (soundbis.position() * sound.sampleRate() / 1000) / sizeOfAvg;
  line(border, -ypos + height + border, width, -ypos + height + border);
}
