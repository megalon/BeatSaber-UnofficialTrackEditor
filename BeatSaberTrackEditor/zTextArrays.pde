static final class TextArrays{
  public static final String[] instructionsText = {
    "  1. Load an audio file using the LOAD AUDIO button",
    "  2. Set the BPM using the BPM textbox",
    "  3. Start editing, or load a track json file with LOAD TRACK",
    "  4. Save the track file with SAVE TRACK when finished",
    "",
  };
  
  public static final String[] defaultControlsText = {
    "  SPACE         :        Play / Pause",
    "  SHIFT + SPACE :        Jump to start",
    "",
    "  SCROLL WHEEL : Scroll sequencer",
    "  SCROLL WHEEL + SHIFT : Speed scroll sequencer",
    "  UP ARROW : Scroll up sequencer",
    "  DOWN ARROW : Scroll down sequencer",
    "",
    "  SQUARE BRACKETS [ and ] : Adjust grid size",
    "  TAB : Stretch spectrogram width to grid",
    "",
    "  CTRL + S : Quick save",
    "",
    "  Currently the program autosaves every 30 sec into the directory \n .\\data\\tmp\\",
  };
  
  public static final String[] noteControlsText = {
    "  Notes:",
    "      Place RED note : Left click",
    "      Place BLUE note: Right click     or     Control + Left Click",
    "      Place MINE : Middle click     or     Alt + Left Click",
    "      Delete note: Shift + Left Click",
    "      Grid snap toggle: G",
    "      Change snap resolution: Square brackets [ and ]",
    "",
    "  Direction arrows: ",
    "  Click while holding down a key:",
    "          W: Up",
    "          S: Down",
    "          A: Left",
    "          D: Right",
    "  For diagonals, combine buttons.",
    "      W+A = UP LEFT, W+D = UP RIGHT, etc",
    "",
    "  Scrolling: ",
    "      SCROLL WHEEL     or     UP / DOWN arrow keys",
    "      Hold SHIFT to scroll faster",
    ""
  };
  
  public static final String[] eventControlsText = {
    "  Lights :",
    "  Click while holding down a key:",
    "      Turn light OFF : Middle click    or    W + left click",
    "      RED  light ON    : Left click",
    "      RED  light FLASH : A + Left click",
    "      RED  light FADE  : D + Left click",
    "      BLUE light ON    : Right click",
    "      BLUE light FLASH : A + Right click",
    "      BLUE light FADE  : D + Right click",
    "      Light OFF        : W + Left click",
    "",
    "  Rotatable objects : ",
    "          Only supports ON or OFF events",
    "          ON  : Left click",
    "          OFF : Right click    or   Middle Click",
    "",
    "  Rotating Lasers : ",
    "          Rotation value as a number. Higher = faster",
    "          WASD + Left click",
    "          OFF : Right Click",
    "",
    "  Remove any block : Shift + Left click"
  };
  
  public static final String[] obstacleControlsText = {
    "  Obstacles :",
    "      Place WALL : Left click and drag",
    "      Place CEILING : Right click and drag",
    "",
    "      Delete obstacle : Shift + Click the \"X\"",
    "",
    "  The obstacle sometimes lands a little offset at the moment.\n",
    "  Try clicking near the edge of the grid boxes for better precision.",
    "",
    "  Obstacles cannot be moved once placed.",
    "  I'd like to implement this in the future!"
  };
  
  
  public static final String eventNames[] = {
      "X_LIGHTS",
      "OVERHEAD_LIGHTS", 
      "LEFT_LIGHTS",
      "RIGHT_LIGHTS",
      "???",
      "???",
      "???",
      "TURN_OBJECT",
      "???",
      "???",
      "MOVE_LIGHT2",
      "MOVE_LIGHT3"};
      
}