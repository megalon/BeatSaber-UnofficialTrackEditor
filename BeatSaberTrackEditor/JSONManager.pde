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
  
  public void saveTrack(String filename){
    this.outputFile = filename;
    
    json = new JSONObject();
    
    events = new JSONArray();
    notes = new JSONArray();
    obstacles = new JSONArray();
    
    setNotes();
    
    json.setString("_version", versionString);
    json.setFloat("_beatsPerMinute", seq.getBPM());
    json.setInt("_beatsPerBar", beatsPerBar);
    json.setFloat("_noteJumpSpeed", 10.0);
    json.setFloat("_shuffle", 0.0);
    json.setFloat("_shufflePeriod", 0.25);
    json.setJSONArray("_events", events);
    json.setJSONArray("_notes", notes);
    json.setJSONArray("_obstacles", obstacles);
    
    saveJSONObject(json, filename + ".json");
  }
  
  public void loadTrack(String filename){
    json = loadJSONObject(filename);
    
    float bpmIn = json.getFloat("_beatsPerMinute");
    notes = json.getJSONArray("_notes");
    
    this.seq.setBPM(bpmIn);
    
    int trackCount = 0;
    int multiCount = 0;
    int noteCount = 0;
    int trackSize = seq.getTrackSize();
    for(int i = 0; i < trackSize; ++i){
      multiCount = 0;
      for(MultiTrack m : seq.multiTracks){
        trackCount = 0;
        for(Track t : m.tracks){
          Note block = (Note)t.gridBlocks[i];
          if(block != null){
            JSONObject note = notes.getJSONObject(noteCount);
            ++noteCount;
          }
          ++trackCount;
        }
        ++multiCount;
      }
    }
  }
  
  private void setNotes(){
    // Go through every index in the track, but go across all tracks and get the current note
    int trackCount = 0;
    int multiCount = 0;
    int noteCount = 0;
    int trackSize = seq.multiTracks.get(0).tracks.get(0).trackSize;
    for(int i = 0; i < trackSize; ++i){
      multiCount = 0;
      for(MultiTrack m : seq.multiTracks){
        trackCount = 0;
        for(Track t : m.tracks){
          Note block = (Note)t.gridBlocks[i];
          if(block != null){
            JSONObject note = new JSONObject();
            
            note.setFloat("_time", (float)(trackSize - block.getGridY()) / seq.beatsPerBar);
            note.setInt("_lineIndex", trackCount);
            note.setInt("_lineLayer", multiCount);
            note.setInt("_type", block.getType());
            note.setInt("_cutDirection", block.getCutDirection());
            
            notes.setJSONObject(noteCount, note);
            ++noteCount;
          }
          ++trackCount;
        }
        ++multiCount;
      }
    }
  }
}
