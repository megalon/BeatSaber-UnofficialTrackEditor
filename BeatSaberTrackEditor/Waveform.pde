import ddf.minim.analysis.*;
import ddf.minim.*;

class Waveform extends GUIElement {
  
    
  Minim minim; 
  AudioSample sound; 
  AudioPlayer soundbis;
  private FloatList sampleAverage;
  private int border, leftLength, rightLength;
  private int sampleRate = 44100;
  private float bpm = 90;
  private float [][] spectra;
  private int [][] spectraBitmap;
  private boolean spectraDisp = true;

  // Resolution of the display
  private float sizeOfAvg = 0.0;
  private int heightScale = 1;
  private int spectraWidthScale = 1;
  private int seqOffset;

  private float maxSize = 0;

  private int gridSize = 0;
  private int beatsPerBar = 1;

  // width adjustment for audio display
  private int widthScale = 50;

  String soundfilePath = "data\\90BPM_Stereo_ClickTrack.wav";

  Waveform(GUIElement parent, int x, int y, int gridSize, Minim minim, int yOffset){
    super(parent, x, y, gridSize, gridSize);

    this.gridSize = gridSize;

    this.minim = minim;
    border = 20;
    this.seqOffset = yOffset;
  }

  // analyzes the spectrum and puts it in spectra and spectraBitmap

  // this function shamelessly stolen from tutorial on web
  private void spectraAnalyze(AudioSample sample){
    println("ANALYZING");

    // right now only using left channel not sure if i should average or just ignore right getChannel
    float[] leftChannel = sample.getChannel(AudioSample.LEFT);
    float[] rightChannel = sample.getChannel(AudioSample.RIGHT);

    int fftSize = 256;// 256 seems good size (must be power of two, but play around and see the changes, though there might be a bug somewhere, when i set it above 1024 i get an array error)

    float[] fftSamples = new float[fftSize];

    FFT fft = new FFT(fftSize,sample.sampleRate());

    int totalChunks = (leftChannel.length / fftSize ) + 1;

    spectra = new float[totalChunks][fftSize/2];
    spectraBitmap = new int[totalChunks][fftSize/2];

    for(int chunkIdx = 0; chunkIdx < totalChunks; ++chunkIdx){
        int chunkStartIndex = chunkIdx * fftSize;

        // the chunk size will always be fftSize, except for the
        // last chunk, which will be however many samples are left in source
        int chunkSize = min( leftChannel.length - chunkStartIndex, fftSize );

        // copy first chunk into our analysis array
        System.arraycopy( leftChannel, // source of the copy
               chunkStartIndex, // index to start in the source
               fftSamples, // destination of the copy
               0, // index to copy to
               chunkSize // how many samples to copy
              );

              // if the chunk was smaller than the fftSize, we need to pad the analysis buffer with zeroes
      if ( chunkSize < fftSize ){
      // we use a system call for this
      java.util.Arrays.fill( fftSamples, chunkSize, fftSamples.length - 1, 0.0 );
      }

      // now analyze this buffer
      fft.forward( fftSamples );

      // and copy the resulting spectrum into our spectra array
      for(int i = 0; i < fftSize/2; ++i)    {
        spectra[chunkIdx][i] = fft.getBand(i);
      }
    }

    // filling colors so i don't have to calculate it every time i draw
    int spectraItemLength = spectra[1].length;
    for (int i =0; i<spectra.length; i++){
      for (int j = 0; j<spectraItemLength;j++){
        spectraBitmap[i][j]=Color.HSBtoRGB(spectra[i][j]/20,1,1);
      }
    }
  }

  public void loadSoundFile(String path){

    soundfilePath = path;
    sound = minim.loadSample(soundfilePath, 1024);

    spectraAnalyze(sound);

    soundbis = minim.loadFile(soundfilePath);

    setSampleRate((int)sound.sampleRate());

    println("Loading sound file: " + path);

    resizeDisplay();
  }

  public void setBPM(float bpm){
    this.bpm = bpm;
    resizeDisplay();
  }

  public void setBeatsPerBar(int beats){
    this.beatsPerBar = beats;
    resizeDisplay();
  }

  private void calculateSizeOfAVG(){
    sizeOfAvg = (this.sampleRate / (this.bpm / 60) ) / this.gridSize;
    // Implement beats per bar here somewhere?
    println("sizeOfAvg: " + sizeOfAvg);
  }

  public void resizeDisplay(){
    calculateSizeOfAVG();
    float[] leftSamples = sound.getChannel(AudioSample.LEFT);
    float[] rightSamples = sound.getChannel(AudioSample.RIGHT);
    float[] samplesVal = new float[rightSamples.length];    
    for (int i = 0; i < rightSamples.length; ++i) {
      samplesVal[i] = leftSamples[i] + rightSamples[i];
    }

    leftLength  = leftSamples.length;
    rightLength = rightSamples.length;

    //2. reduce quantity : get an average from those values
    sampleAverage = new FloatList();
    int average=0;

    int avgCounter = 0;
    float lastRemainder = 9999;
    float thisRemainder;
    for (int i = 0; i < samplesVal.length; ++i) {
      average += abs(samplesVal[i] * widthScale) ; // sample are low value so we increase the size to see them

      thisRemainder = (i % (sizeOfAvg));
      if (thisRemainder < lastRemainder) {
        avgCounter++;
        float newVal = average / sizeOfAvg;
        sampleAverage.append(newVal);
        if(newVal > maxSize)
          maxSize = newVal;
        average = 0;
      }
      lastRemainder = thisRemainder;
    }

    println("avgCounter  : "   + avgCounter);
    println("sizeOfAvg   : "   + sizeOfAvg);
    println();
    for (int i = 0; i < sampleAverage.size(); ++i) {
      sampleAverage.set(i, map(sampleAverage.get(i), 0, maxSize, 0, 200));
    }
  }

  public void setSampleRate(int sampleRate){
    this.sampleRate = sampleRate;

  }

  // Get number of samples in soundfile
  public int getNumSamples(){
    return max(leftLength, rightLength);
  }

  public int getLength(){
    return soundbis.length();
  }

  public void play(){
    soundbis.play();
  }

  public void pause(){
    soundbis.pause();
  }

  public void stopPlaying(){
    soundbis.pause();
    soundbis.rewind();
  }

  public boolean getPlaying(){
    return soundbis.isPlaying();
  }

  public void setPosition(int gridPos){
    //float ypos = (soundbis.position() * sound.sampleRate() / 1000) / sizeOfAvg * beatsPerBar;
    //soundbis.skip();
  }

  public int soundPosition2Pixels(int p){
    return (int)((p / 1000.0 * sampleRate) / sizeOfAvg * beatsPerBar);
  }

  public float pixels2SoundPosition(int p){
    return ((p * (sizeOfAvg / beatsPerBar)) / sampleRate) * 1000;
  }

  // Set the tracker position in samples
  public void setTrackerPositionSamples(int pos){
    soundbis.rewind();
    soundbis.skip(pos);
  }
  
  public void setTrackerPositionPixels(int pos){
    soundbis.rewind();
    soundbis.skip((int)pixels2SoundPosition(pos));
  }

  // Returns current position in the song in ms
  public int getSongPosition(){
    return soundbis.position();
  }

  // Returns position of the tracker bar in pixels
  public int getTrackerPosition(){
    return soundPosition2Pixels(soundbis.position());
  }

  public void display(){
    /*
    if(soundbis.isPlaying()){
      println("Position ms      : " + soundbis.position());
      println("Position sec     : " + (soundbis.position() / 1000.0));
      println("Position samples : " + (int)(soundbis.position() / 1000.0 * sampleRate));
      println("Position pixels  : " + (int)((soundbis.position() / 1000.0 * sampleRate) / sizeOfAvg * beatsPerBar));

      float samplePos = (int)((soundbis.position() / 1000.0 * sampleRate) / sizeOfAvg * beatsPerBar);

      println("Position samples : " + (samplePos * (sizeOfAvg / beatsPerBar)));
      println("Position sec     : " + ((samplePos * (sizeOfAvg / beatsPerBar)) / sampleRate));
      println("Position ms      : " + ((samplePos * (sizeOfAvg / beatsPerBar)) / sampleRate) * 1000);
      println("");
    }
    */
    if(sampleRate != 0){
      if(sound != null){

        //heres where the magic happens for spectra
        // ------------- spectra --------------
        if (spectraDisp){
          int yPos = this.getY();
          int maxPix = soundPosition2Pixels(getLength());
          int borderScaled = border * spectraWidthScale; // Optimization
          ///
          for (int i = seqOffset; i > 0; --i){
            int scaleIndex = ((yPos - i) * spectraBitmap.length / maxPix); // magic scaling factor
            if (scaleIndex >= spectra.length){
              scaleIndex = 0;
            }
            for (int j = 0; j < spectra[scaleIndex].length; ++j){
              stroke(spectraBitmap[scaleIndex][j]);
              line(j * spectraWidthScale + borderScaled, i, j * spectraWidthScale + 1 + borderScaled, i); // Optimized draw from two point calls
            }
          }
          //return color to normal
          fill(190);
          stroke(#ffffff);
          strokeCap(SQUARE);
          // ------------- end spectra --------------
        }else{
          fill(190);
          stroke(#ffffff);
          textSize(18);
          //strokeWeight(beatsPerBar);
          // Draw the waveform display and the time. Time is currently showing each second
          float prevTime = -1;
          for ( int i=0; i < sampleAverage.size(); i++) {
            // Draw the sound file
            line(border*2, -(i * beatsPerBar) + this.getY()+8, border*2 + ((sampleAverage.get(i) * 8) / maxSize), -(i * beatsPerBar) + this.getY()+8);
 
          }
        }
        
        fill(190);
        stroke(#ffffff);
        textSize(18);
        //strokeWeight(beatsPerBar);
        float prevTime = -1;
        // Draw the waveform display and the time. Time is currently showing each second
        for ( int i = 0; i < sampleAverage.size(); i++) {
          // Draw the text (time in seconds)
          float time = floor((i * sizeOfAvg) / sampleRate);
          if(prevTime != time){
            prevTime = time;
            //text(round(time), i + border, height-border/2);
            text(round(time), 4, this.getY() - (i * beatsPerBar) - border);
          }
        }

        strokeWeight(1);
        line(border*2, this.getY(), border*2, -(sampleAverage.size() * beatsPerBar) + this.getY());
        // Draw the play head (red line moving across)
        strokeWeight(2);
        stroke(#ff0000);
        float ypos = soundPosition2Pixels(soundbis.position());
        line(0, -ypos + this.getY(), width, -ypos + this.getY());
      }
    } else {
      println("Error: Could not display waveform, sound is null!");
    }
  }
}
