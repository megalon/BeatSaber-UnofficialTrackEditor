class JSONManager{
  TrackSequencer seq;
  String outputFile, inputFile;
  JSONObject json;
  JSONArray events, notes, obstacles;
  GLabel consoleOutLabel;
  
  String versionString = "1.5.0";
  int beatsPerBar = 16;
  int notesPerBar = 1; // Change this value later
  
  public JSONManager(TrackSequencer seq, GLabel consoleOutLabel){
    this.seq = seq;
    this.consoleOutLabel = consoleOutLabel;
  }
  
  // Load a track from disk
  public void loadTrack(String filename){
    
    seq.clearSeq();

    this.consoleOutLabel.setText("Opening track file: " + filename);

    
    json = loadJSONObject(filename);
    
    float bpmIn = json.getFloat("_beatsPerMinute");
    notes = json.getJSONArray("_notes");
    events = json.getJSONArray("_events");
    obstacles = json.getJSONArray("_obstacles");
    
    //If events was empty, create some temp events
    if(events == null){
      createPlaceholderEvents();
    }
    
    println("notes json: " + notes);
    //println("bpmInput  : " + bpmIn);
    
    this.seq.setBPM(bpmIn);
    
    JSONObject currentObject;
    float currentTime;
    int currentLineIndex;
    int currentLineLayer;
    int currentType;
    int currentCutDirection;
    
    float currentDuration; 
    int currentWidth;
    
    MultiTrack mt;
    Track t;
    
    // Get time of last note as an indicator of length of song
    if(notes == null){
      println("notes JSONArray was null!");
      return;
    }
    
    int gridY;
    for(int n = 0; n < notes.size(); ++n){
      currentObject = notes.getJSONObject(n);
      currentTime = currentObject.getFloat("_time");
      currentLineIndex = currentObject.getInt("_lineIndex");
      currentLineLayer = currentObject.getInt("_lineLayer");
      currentType = currentObject.getInt("_type");
      currentCutDirection = currentObject.getInt("_cutDirection");
      
      println("currentTime : " + currentTime);
      //println("currentNote : " + currentNote); //println("currentLineIndex : " + currentLineIndex); //println("currentLineLayer : " + currentLineLayer); //println("currentType : " + currentType);  //println("currentCutDirection : " + currentCutDirection);
      
      // Get notes multitracks. Add one to skip events track
      mt = seq.multiTracks.get(currentLineLayer + 1);
      t = mt.tracks.get(currentLineIndex);
      
      gridY = seq.timeToGrid(currentTime);
      
      println("note " + n + " gridY : " + gridY);
      
      // Add note to the grid
      // NOTE: The 0 on the end of this function is unused for GB_TYPE_NOTE
      t.addGridBlock(GridBlock.GB_TYPE_NOTE, currentTime, currentType, currentCutDirection, 0);
    }
    

    //{"_lineIndex":2,"_type":0,"_duration":1,"_time":76,"_width":2},
    for(int o = 0; o < obstacles.size(); ++o){
      currentObject       = obstacles.getJSONObject(o);
      currentTime         = currentObject.getFloat("_time");
      currentLineIndex    = currentObject.getInt("_lineIndex");
      currentType         = currentObject.getInt("_type");
      currentDuration     = currentObject.getFloat("_duration");
      currentWidth        = currentObject.getInt("_width");
      
      println("currentTime : " + currentTime);
      
      // Get obstacle multitracks
      mt = seq.multiTracks.get(4);
      t = mt.tracks.get(currentLineIndex);
      
      gridY = seq.timeToGrid(currentTime);
      
      println("obstacle " + o + " gridY : " + gridY);
      
      // Add note to the grid
      // NOTE: The 0 on the end of this function is unused for GB_TYPE_NOTE
      // public void addGridBlock(int gridBlockType, float time, int type, int val0, float val1){
      t.addGridBlock(GridBlock.GB_TYPE_OBSTACLE, currentTime, currentType, currentWidth, currentDuration);
    }

    this.consoleOutLabel.setText("++++ Track file loaded! ++++\n " + filename);

  }
  
  // Save the created track to output json file
  public void saveTrack(String filename){
    this.consoleOutLabel.setText("Saving track file: " + filename);
    println("Saving track to file: " + filename);
    
    this.outputFile = filename;
    
    json = new JSONObject();
    
    notes = new JSONArray();
    
    // Currently skipping over events and obstacles!
    //events = new JSONArray();
    obstacles = new JSONArray();
    
    setNotesArray();
    setObstaclesArray();
    
    json.setString("_version", versionString);
    json.setFloat("_beatsPerMinute", seq.getBPM());
    json.setInt("_beatsPerBar", beatsPerBar);
    json.setFloat("_noteJumpSpeed", 10.0);
    json.setFloat("_shuffle", 0.0);
    json.setFloat("_shufflePeriod", 0.25);
    json.setJSONArray("_events", events);
    json.setJSONArray("_notes", notes);
    json.setJSONArray("_obstacles", obstacles);
    
    
    int outFileLen = outputFile.length();
    if(outFileLen < 5 || !this.outputFile.substring(outFileLen - 5, outFileLen).equals(".json")){
      this.outputFile = this.outputFile + ".json";
    }
    
    saveJSONObject(json, filename);
    
    this.consoleOutLabel.setText("++++ Track file saved! ++++ " + hour() + ":" + minute() + ":" + second() + "\n" + filename);
  }
  
  
  // Create the notes JSON array to save to the track file
  private void setNotesArray(){
    // Go through every index in the track, but go across all tracks and get the current note
    int trackCount = 0;
    int multiCount = 0;
    int noteCount = 0;
    multiCount = 0;
    Note n = null;
    for(int i = 1; i < 4; ++i){
      MultiTrack m = seq.multiTracks.get(i);
      trackCount = 0;
      for(Track t : m.tracks){
        
        // Iterate through all gridblocks in hashmap
        for (Float f: t.gridBlocks.keySet()) {
          Note block = (Note)t.gridBlocks.get(f);
          if(block != null){
            JSONObject note = new JSONObject();
            
            note.setFloat("_time", block.getTime());
            note.setInt("_lineIndex", trackCount);
            note.setInt("_lineLayer", multiCount);
            note.setInt("_type", block.getType());
            note.setInt("_cutDirection", block.getCutDirection());
            
            notes.setJSONObject(noteCount, note);
            ++noteCount;
          }
        }
        ++trackCount;
      }
      ++multiCount;
    }
  }
  
  // Create the notes JSON array
  private void setObstaclesArray(){
    // Go through every index in the track, but go across all tracks and get the current note
    int trackCount = 0;
    int multiCount = 0;
    int obstacleCount = 0;
    multiCount = 0;
    MultiTrack m = seq.multiTracks.get(4);
    trackCount = 0;
    for(Track t : m.tracks){
      // Iterate through all gridblocks in hashmap
      for (Float f: t.gridBlocks.keySet()) {
        Obstacle block = (Obstacle)t.gridBlocks.get(f);
        if(block != null){
          JSONObject obstacle = new JSONObject();
          
          // {"_lineIndex":2, "_type":0, "_duration":1, "_time":76, "_width":2},
          obstacle.setFloat("_time", block.getTime());
          obstacle.setInt("_lineIndex", trackCount);
          obstacle.setInt("_type", block.getType());
          obstacle.setFloat("_duration", block.getDuration());
          obstacle.setInt("_width", block.getWidth());
          
          obstacles.setJSONObject(obstacleCount, obstacle);
          ++obstacleCount;
        }
      }
      ++trackCount;
    }
  }
  
  private void createPlaceholderEvents(){
    int eventCount = 0;
    
    events = new JSONArray();
    
    for(int i = 0; i < 5; ++i){
      JSONObject event = new JSONObject();
      
      event.setInt("_time", 0);
      event.setInt("_type", i);
      event.setInt("_value", 1);
      
      events.setJSONObject(eventCount, event);
      ++eventCount;
    }
  }
}
