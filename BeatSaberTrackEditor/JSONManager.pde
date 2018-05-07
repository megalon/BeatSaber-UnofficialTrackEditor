class JSONManager{
  TrackSequencer seq;
  String outputFile, inputFile;
  JSONObject json;
  JSONArray events, notes, obstacles;
  
  String versionString = "1.5.0";
  int beatsPerBar = 16;
  int notesPerBar = 1; // Change this value later
  
  public JSONManager(TrackSequencer seq){
    this.seq = seq;
  }
  
  public void loadTrack(String filename){
    json = loadJSONObject(filename);
    
    float bpmIn = json.getFloat("_beatsPerMinute");
    notes = json.getJSONArray("_notes");
    
    println("notes json: " + notes);
    println("bpmInput  : " + bpmIn);
    
    this.seq.setBPM(bpmIn);
    
    int trackCount = 0;
    int multiCount = 0;
    int noteCount = 0;
    int trackSize = seq.getTrackSize();
    
    
    JSONObject currentNote;
    float currentTime;
    int currentLineIndex;
    int currentLineLayer;
    int currentType;
    int currentCutDirection;
    
    MultiTrack mt;
    Track t;
    
    // Get time of last note as an indicator of length of song
    if(notes == null){
      println("notes JSONArray was null!");
      return;
    }
    
    JSONObject tempNote = notes.getJSONObject(notes.size() - 1);
    float songLength = tempNote.getFloat("_time");
    
    int gridY;
    for(int n = 0; n < notes.size(); ++n){
      currentNote = notes.getJSONObject(n);
      currentTime = currentNote.getFloat("_time");
      currentLineIndex = currentNote.getInt("_lineIndex");
      currentLineLayer = currentNote.getInt("_lineLayer");
      currentType = currentNote.getInt("_type");
      currentCutDirection = currentNote.getInt("_cutDirection");
      
      //println("currentNote : " + currentNote);
      println("currentTime : " + currentTime);
      //println("currentLineIndex : " + currentLineIndex);
      //println("currentLineLayer : " + currentLineLayer);
      //println("currentType : " + currentType);
      //println("currentCutDirection : " + currentCutDirection);
      
      mt = seq.multiTracks.get(currentLineLayer);
      t = mt.tracks.get(currentLineIndex);
      
      gridY = seq.timeToGrid(currentTime);
      
      println("note " + n + " gridY : " + gridY);
      
      t.addNote(currentTime, currentType, currentCutDirection);
    }
  }
  
  // Save the created track to output json file
  public void saveTrack(String filename){
    this.outputFile = filename;
    
    json = new JSONObject();
    
    events = new JSONArray();
    notes = new JSONArray();
    obstacles = new JSONArray();
    
    setNotesAray();
    createPlaceholderEvents();
    
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
  }
  
  
  // Create the notes JSON array
  private void setNotesAray(){
    // Go through every index in the track, but go across all tracks and get the current note
    int trackCount = 0;
    int multiCount = 0;
    int noteCount = 0;
    multiCount = 0;
    Note n = null;
    for(MultiTrack m : seq.multiTracks){
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
  
  private void createPlaceholderEvents(){
    int eventCount = 0;
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
