import java.util.Collections;
import java.util.Comparator;

class JSONManager{
  TrackSequencer seq;
  String outputTrackFile, inputTrackFile, inputInfoFile, outputInfoFile;
  JSONObject jsonTrack, jsonInfo;
  JSONArray events, notes, obstacles;
  GLabel consoleOutLabel;

  String versionString = "1.5.0";
  int beatsPerBar = 16;
  int notesPerBar = 1; // Change this value later
  float offset;
  public JSONManager(TrackSequencer seq, GLabel consoleOutLabel){
    this.seq = seq;
    this.consoleOutLabel = consoleOutLabel;
  }

  public void loadInfo(String filename){
    if(filename == null || filename.isEmpty()){
      return;
    }
    
    this.consoleOutLabel.setText("Opening info file: " + filename);
    
    
    jsonInfo = loadJSONObject(filename);
    
    bpmTextField.setPromptText("" + jsonInfo.getFloat("beatsPerMinute"));
    songNameField.setPromptText("" + jsonInfo.getString("songName"));
    songSubNameField.setPromptText("" + jsonInfo.getString("songSubName"));
    authorNameField.setPromptText("" + jsonInfo.getString("authorName"));
    previewStartTimeField.setPromptText("" + jsonInfo.getInt("previewStartTime"));
    previewDurationField.setPromptText("" + jsonInfo.getInt("previewDuration"));
    coverImagePathField.setPromptText("" + jsonInfo.getString("coverImagePath"));
    
    JSONObject difficultyLevels = jsonInfo.getJSONObject("difficultyLevels");
    
    difficultyRankField.setPromptText("" + difficultyLevels.getString("difficultyRank"));
    
    
  }
  
  // Load a track from disk
  public void loadTrack(String filename){
    if(filename == null || filename.isEmpty()){
      return;
    }

    this.consoleOutLabel.setText("Opening track file: " + filename);
    
    jsonTrack = loadJSONObject(filename);
    
    seq.clearSeq();
    
    float bpmIn = jsonTrack.getFloat("_beatsPerMinute");
    notes = jsonTrack.getJSONArray("_notes");
    events = jsonTrack.getJSONArray("_events");
    obstacles = jsonTrack.getJSONArray("_obstacles");
    
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

    // Note specific
    int currentLineLayer;
    int currentType;
    int currentCutDirection;

    // Obstacle specific
    float currentDuration;
    int currentWidth;

    // Event specific
    int currentValue;

    MultiTrack mt;
    Track t;

    // Get time of last note as an indicator of length of song
    if(notes == null){
      println("notes JSONArray was null!");
      return;
    }

    int gridY;

    //
    // Load notes
    //

    float beatOffset =offset*bpmIn/60;



    println(beatOffset);
    delay(1000);

    for(int n = 0; n < notes.size(); ++n){
      currentObject = notes.getJSONObject(n);
      currentTime = currentObject.getFloat("_time");
      println(currentTime);
      //currentTime += beatOffset;

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

    //
    // Load obstacles
    //
    //{"_lineIndex":2,"_type":0,"_duration":1,"_time":76,"_width":2},
    for(int o = 0; o < obstacles.size(); ++o){
      currentObject       = obstacles.getJSONObject(o);
      currentTime         = currentObject.getFloat("_time");// + beatOffset;
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

      // Add an obstacle to the grid
      // public void addGridBlock(int gridBlockType, float time, int type, int val0, float val1){
      t.addGridBlock(GridBlock.GB_TYPE_OBSTACLE, currentTime, currentType, currentWidth, currentDuration);
    }


    //
    // Load events
    //
    // Only events 0 - 4, 8, 9, 12, 13
    for(int e = 0; e < events.size(); ++e){
      currentObject = events.getJSONObject(e);
      currentTime = currentObject.getFloat("_time");// + beatOffset;
      currentType = currentObject.getInt("_type");
      currentValue = currentObject.getInt("_value");


      // Since not all tracks are used, we need to convert the currentValue
      // into the correct track index in the multitrack tracklist
      int updatedTrackValue = 0;

      println("currentType:" + currentType);
      switch(currentType){
        case(8): updatedTrackValue  = 5;
          break;
        case(9): updatedTrackValue  = 6;
          break;
        case(12): updatedTrackValue = 7;
          break;
        case(13): updatedTrackValue = 8;
          break;
        default:
          println("currentType that defaulted:" + currentType);
          updatedTrackValue = currentType;
      }

      // Get events multitrack
      mt = seq.multiTracks.get(0);
      t = mt.tracks.get(updatedTrackValue);

      println("updatedTrackValue output:" + updatedTrackValue);
      println("currentValue output:" + currentValue);
      println("");
      // Add event to the grid
      // NOTE: The 0 on the end of this function is unused for GB_TYPE_EVENT
      t.addGridBlock(GridBlock.GB_TYPE_EVENT, currentTime, updatedTrackValue, currentValue, 0);

    }

    this.consoleOutLabel.setText("++++ Track file loaded! ++++\n " + filename);

  }

  // Save the created track to output json file
  public void saveTrack(String filename){
    this.consoleOutLabel.setText("Saving track file: " + filename);
    println("Saving track to file: " + filename);

    this.outputTrackFile = filename;
    
    jsonTrack = new JSONObject();

    notes = new JSONArray();
    events = new JSONArray();
    obstacles = new JSONArray();
    
    jsonTrack.setString("_version", versionString);
    jsonTrack.setFloat("_beatsPerMinute", seq.getBPM());
    jsonTrack.setInt("_beatsPerBar", beatsPerBar);
    jsonTrack.setFloat("_noteJumpSpeed", 10.0);
    jsonTrack.setFloat("_shuffle", 0.0);
    jsonTrack.setFloat("_shufflePeriod", 0.25);

    setEventsArray();
    setNotesArray();
    setObstaclesArray();
    
    jsonTrack.setJSONArray("_events", events);
    jsonTrack.setJSONArray("_notes", notes);
    jsonTrack.setJSONArray("_obstacles", obstacles);
    
    
    int outFileLen = outputTrackFile.length();
    if(outFileLen < 5 || !this.outputTrackFile.substring(outFileLen - 5, outFileLen).equals(".json")){
      this.outputTrackFile = this.outputTrackFile + ".json";
    }
    
    saveJSONObject(jsonTrack, filename);

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
    
    sortByTime(notes);
  }

  // Create the notes JSON array
  private void setObstaclesArray(){
    // Go through every index in the track, but go across all tracks and get the current note
    int trackCount = 0;
    int multiCount = 0;
    int obstacleCount = 0;
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
          obstacle.setInt("_width", block.getWallWidth());

          obstacles.setJSONObject(obstacleCount, obstacle);
          ++obstacleCount;
        }
      }
      ++trackCount;
    }
    
    sortByTime(obstacles);
  }

  private void setEventsArray(){

    // Go through every index in the track, but go across all tracks and get the current note
    int trackCount = 0;
    int eventCount = 0;
    MultiTrack m = seq.multiTracks.get(0);
    trackCount = 0;
    
    for(Track t : m.tracks){
      // Iterate through all gridblocks in hashmap
      for (Float f: t.gridBlocks.keySet()) {
        Event block = (Event)t.gridBlocks.get(f);
        if(block != null){
          JSONObject event = new JSONObject();

          event.setFloat("_time", block.getTime());
          event.setInt("_type", trackCount);
          event.setInt("_value", block.getValue());

          events.setJSONObject(eventCount, event);
          ++eventCount;
        }
      }

      ++trackCount;
      if(trackCount == 5){
        trackCount = 8;
        //println("Changing trackcount to: " + trackCount);
      }else if(trackCount == 10){
        trackCount = 12;
        //println("Changing trackcount to: " + trackCount);
      }
    }
    
    //
    // Sort the events array. If it is not sorted, events can be skipped
    //
    sortByTime(events);

  }
  
  // Sort the JSONArray by the _time float value
  private void sortByTime(JSONArray array){
    
    // Copy the jsonArray into an arraylist
    ArrayList<JSONObject> jsonValues = new ArrayList<JSONObject>();
    for (int i = 0; i < array.size(); ++i) {
        jsonValues.add(array.getJSONObject(i));
    }
    
    // Sort the arraylist 
    Collections.sort( jsonValues, new Comparator<JSONObject>() {
        //You can change "Name" with "ID" if you want to sort by ID
        private static final String KEY_NAME = "_time";

        @Override
        public int compare(JSONObject a, JSONObject b) {
            Float valA = 0.0;
            Float valB = 0.0;

            try {
                valA = (float) a.getFloat(KEY_NAME);
                valB = (float) b.getFloat(KEY_NAME);
            } 
            catch (Exception e) {
                println("Error: Exception in sorting JSON array!");
            }

            if(valA < valB)
              return -1;
            else if(valA > valB)
              return 1;
            return 0;
        }
    });

    // Copy the sorted ArrayList into the JSONArray
    for (int i = 0; i < array.size(); ++i) {
        array.setJSONObject(i, jsonValues.get(i));
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