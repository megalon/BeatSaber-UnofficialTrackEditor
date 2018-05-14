// The collection of all tracks.
// Each 
class MultiTrack extends GUIElement{
  
  PFont f;
  
  public ArrayList<Track> tracks;
  
  boolean highlighted = false;
  boolean translucent = false;
  
  int highLightedColor = color(#444444);
  int notHighLightedColor =  color(0x33333333);
  
  MultiTrack(GUIElement parent, int numTracks, int gridWidth, int gridHeight, int beatsPerBar, String name){
    this.setParent(parent);
    this.setElementName(name);
    this.setHeight(Integer.MAX_VALUE/2);
    this.setWidth(gridWidth * numTracks);
    this.setY(-this.getHeight());
    
    this.setFillColor(notHighLightedColor);
    
    
    
    tracks = new ArrayList<Track>();
    
    for(int i = 0; i < numTracks; ++i){
      
      int trackType = Track.TRACK_TYPE_NOTES;
      
      if(name.equals("Events")){
        trackType = Track.TRACK_TYPE_EVENTS;
      }else if(name.equals("Obstacles")){
        trackType = Track.TRACK_TYPE_OBSTACLES;
      }
      
      Track t = new Track(this, gridWidth, gridHeight, beatsPerBar, trackType);
      t.setX(gridWidth * i);
      t.setHeight(this.getHeight());
      tracks.add(t);
    }
    
    // Arial 16 point, with anti-aliasing 
    f = createFont("Arial", 16, true);
    
  }
  
  // This is a replacement for checkTrackClicked designed only for events.
  // This is needed because event "types" are based off of the track that they are on
  // Unlike not tracks where each track can have notes of any type or value
  // Events tracks can only have events of ONE type, but different values
  // Thus we need to use the track as the type
  // val0 is 
  // val1 is 
  public void checkTrackClickedEvents(int mx, int my, int seqYOffset, int val0, float val1, int mouseButtonIndex){
    
    //println("mouseButtonIndex: " + mouseButtonIndex);
    
    int trackCount = 0;
    int value = val0;
    
    for (Track t : tracks){
      if(t.checkClicked(mx, my)){
        if(mouseButtonIndex == -1){
          t.removeGridBlockMouseClick(mx, my);
        }else{
          if(trackCount <= 4){
            value = getLightEvent(val0, mouseButtonIndex);
          }else if(trackCount == 5 || trackCount == 6){
            // if this is one of the rotation only tracks
            
            // If you right click or middle click
            if(mouseButtonIndex == 3 || mouseButtonIndex == 2){
              value = 0;
            }else if(value > 0){
              value = 1;
            }
          }else{
            value = getRotationSpeedEvent(val0);
          }
          t.addGridBlockMouseClick(mx, my, trackCount, value, val1);
        }
      }
      ++trackCount;
    }
  }
  
  public int getRotationSpeedEvent(int val0){
  
      //println("val0:" + val0);
  
      // Clockwise
      switch(val0){
        case(Note.DIR_BOTTOM):       val0 = 1; break;
        case(Note.DIR_BOTTOMLEFT):   val0 = 2; break;
        case(Note.DIR_LEFT):         val0 = 3; break;
        case(Note.DIR_TOPLEFT):      val0 = 4; break;
        case(Note.DIR_TOP):          val0 = 5; break;
        case(Note.DIR_TOPRIGHT):     val0 = 6; break;
        case(Note.DIR_RIGHT):        val0 = 7; break;
        case(Note.DIR_BOTTOMRIGHT):  val0 = 8; break;
        default:                     val0 = 0;
      } 
    return val0;
  }
  
  public void setHighlighted(boolean hi){
    this.highlighted = hi;
  }
  
  public boolean getHighlighted(){
    return this.highlighted;
  }
  
  public int getLightEvent(int keyInput, int type){
      //
      //
      // NOTE:
      //      In this case "TYPE" refers to the track! "VALUE" refers to what is happening
      //      Thus "type" is unused here, becuase we already are in the track we want!
      //
      //
      
      int lightEvent = 0;
      //println("currentCutDirection: " + currentCutDirection);
      if(type == -1){
        lightEvent = -1;
      }else if(type == Note.TYPE_MINE){
        lightEvent = Event.VALUE_OFF;
      }else{
        switch(keyInput){
              case(Note.DIR_BOTTOM):
                // Arrow points UP
                lightEvent = Event.VALUE_OFF;
                break;
              case(Note.DIR_RIGHT):
                // Arrow points RIGHT
                if(type == Note.TYPE_RED)
                  lightEvent = Event.VALUE_RED_FLASH;
                else
                  lightEvent = Event.VALUE_BLUE_FLASH;
                break;
              case(Note.DIR_LEFT):
                // Arrow points LEFT
                if(type == Note.TYPE_RED)
                  lightEvent = Event.VALUE_RED_FADE;
                else
                  lightEvent = Event.VALUE_BLUE_FADE;
                break;
              default:
                // Circle
                if(type == Note.TYPE_RED)
                  lightEvent = Event.VALUE_RED_LIGHT;
                else
                  lightEvent = Event.VALUE_BLUE_LIGHT;
                break;
        } 
    }
    return lightEvent;
  }
  
  public void checkTrackClicked(int mx, int my, int seqYOffset, int type, int val0, float val1){
    //println("Checking click inside MultiTrack:" + mx + " " + my);
    //println("Multitrack xy: " + this.getX() + " " + this.getY());
    for (Track t : tracks){
      //println("TrackPosition: " + t.getX() + " " + t.getY());
      if(t.checkClicked(mx, my)){
        //println("++++++++++Track clicked!");
        //println("seqYOffset: " + seqYOffset);
        //println(" my - (seqYOffset): " + (my - (seqYOffset)));
        if(type == -1)
          t.removeGridBlockMouseClick(mx, my);
        else
          t.addGridBlockMouseClick(mx, my, type, val0, val1);
      }
    }
  }
  
  public void checkTrackClickedObstacle(int mx, int my, int seqYOffset, int selectionWidth, int selectionHeight, int type){
   for (Track t : tracks){
     
     //println("(-selectionHeight - t.getGridHeight()) - t.getY() + seqYOffset: " + ((-selectionHeight - t.getGridHeight()) - t.getY() + seqYOffset));
      
     //println("TrackPosition: " + t.getX() + " " + t.getY());
      if(t.checkClicked(mx, my)){
        
        float duration = t.mouseCordToTime((-selectionHeight - t.getGridHeight()) + t.getHeight());
        //println("Duration: " + duration);
        
        int w = (selectionWidth / t.getWidth()) + 1;
        
        if(type == -1){
          println("Attempting to remove obstacle a: " + mx + ", " + my);
          t.removeGridBlockMouseClick(mx, my);
        }else{
          t.addGridBlockMouseClick(mx, my, type, w, duration);
        }
      }
    } 
  }
  
  // This can be used to click and drag on a notes track
  public void checkTrackClickedNotes(int mx, int my, int seqYOffset, int selectionWidth, int selectionHeight, int type){
   for (Track t : tracks){
     
      if(t.checkClicked(mx, my) || t.checkClicked(mx + selectionWidth, my) ){

        // Get start and end position of selection
        float startTime = t.mouseCordToTime(my - t.getY());
        float endTime = t.mouseCordToTime(my - t.getY() - selectionHeight);
        
        println("startime, endtime : " + startTime + ", " + endTime);
        //println("Duration: " + duration);
        
        int w = (selectionWidth / t.getWidth()) + 1;
        
        
        for (Float f: t.gridBlocks.keySet()) {
          GridBlock block = t.gridBlocks.get(f);
          if(block.getTime() >= startTime && block.getTime() <= endTime){
            println("Found block : " + block + " at time " + block.getTime());  
          }
        }
        
        /*
        if(type == -1){
          println("Attempting to remove obstacle a: " + mx + ", " + my);
          t.removeGridBlockMouseClick(mx, my);
        }else{
          t.addGridBlockMouseClick(mx, my, type, w, duration);
        }
        */
      }
    } 
  }
  
  // trackCopy
  public void selectCopy(int my, int selectionHeight){
   for (Track t : tracks){
     
     // Clear copy buffer
     t.gridBlocksCopy.clear();
     println("Track t:" + t);
   
    // Get start and end position of selection
    float startTime = t.mouseCordToTime(my - t.getY());
    float endTime = t.mouseCordToTime(my - t.getY() - selectionHeight);

    for (Float f: t.gridBlocks.keySet()) {
        
      if(this.getElementName().equals("Events")){
        Event block = (Event)t.gridBlocks.get(f);
        if(block.getTime() >= startTime && block.getTime() <= endTime){
          Event event = new Event(block.getParent(), block.getY(), block.getWidth(), block.getHeight(), block.getType(), block.getValue(), block.getTime() - startTime);
          t.gridBlocksCopy.put(event.getTime(), event);
        }
      }else if(this.getElementName().equals("Obstacles")){
        Obstacle block = (Obstacle)t.gridBlocks.get(f);
        if(block.getTime() >= startTime && block.getTime() <= endTime){
          Obstacle obstacle = new Obstacle(block.getParent(), block.getY(), block.getWidth() / block.getWallWidth(), (int)(block.getHeight() / block.getDuration() / 8), block.getType(), block.getWallWidth(), block.getTime() - startTime, block.getDuration());
          t.gridBlocksCopy.put(obstacle.getTime(), obstacle);
        }
      }else{
        Note block = (Note)t.gridBlocks.get(f);
        if(block.getTime() >= startTime && block.getTime() <= endTime){
          Note note = new Note(block.getParent(), block.getY(), block.getWidth(), block.getHeight(), block.getType(), block.getCutDirection(), block.getTime() - startTime);
          t.gridBlocksCopy.put(note.getTime(), note);
        }
      }
    }
   }
  }
  
  public void updateCopyDrawing(int mx, int my, int oldX, int oldY){
    for(Track t : tracks){
      if(t.gridBlocksCopy.size() > 0){
        println("t.gridBlocksCopy " + t + " size: " + t.gridBlocksCopy.size());
      }
      
      /*
      for (Float f: t.gridBlocksCopy.keySet()) {
        GridBlock block = t.gridBlocksCopy.get(f);
        float pasteTime = t.mouseCordToTime(my - t.getY());
        
        n.setTime(n.getTime() + pasteTime);
        n.setY(t.calculateGridYPos(n.getTime()));
        
        t.gridBlocks.put(n.getTime(), n);
      }
      */
      /*
      float pasteTime = t.mouseCordToTime(my - t.getY());
      // Put the copied blocks back in the normal hashmap
      for (Float f: t.gridBlocksCopy.keySet()) {
        GridBlock block = t.gridBlocksCopy.get(f);
      
        float newTime = t.mouseCordToTime(t.calculateGridYPos(block.getTime()) + my - oldY);
        
        block.setY(t.calculateGridYPos(block.getTime()) + my - oldY - t.getY() + t.yStartingPosition);
        
      }*/
    }
  }
  
  public void selectPaste(int my){
    println();
    for(Track t : tracks){

      if(t.gridBlocksCopy.size() > 0){
        println("t.gridBlocksCopy " + t + " size: " + t.gridBlocksCopy.size());
      }
      
      float pasteTime = t.mouseCordToTime(my - t.getY());
      
      GridBlock b = null;
      
      // Put the copied blocks back in the normal hashmap
      // Each different object type needs to be cast to the matching object
      // The object is then cast back to a generic griblock to be put back into the hashmap
      for (Float f: t.gridBlocksCopy.keySet()) {
        if(t.getTrackType() == Track.TRACK_TYPE_NOTES){
          Note block = (Note)t.gridBlocksCopy.get(f);
          Note n = new Note(block.getParent(), block.getY(), block.getWidth(), block.getHeight(), block.getType(), block.getCutDirection(), block.getTime());
          b = (GridBlock)n;
        }else if(t.getTrackType() == Track.TRACK_TYPE_EVENTS){
          Event block = (Event)t.gridBlocksCopy.get(f);
          Event e = new Event(block.getParent(), block.getY(), block.getWidth(), block.getHeight(), block.getType(), block.getValue(), block.getTime());
          b = (GridBlock)e;
        }else if(t.getTrackType() == Track.TRACK_TYPE_OBSTACLES){
          Obstacle block = (Obstacle)t.gridBlocksCopy.get(f);
          Obstacle o = new Obstacle(block.getParent(), block.getY(), block.getWidth() / block.getWallWidth(), (int)(block.getHeight() / block.getDuration() / 8), block.getType(), block.getWallWidth(), block.getTime(), block.getDuration());
          b = (GridBlock)o;
        }
        
        // Add gridblock back into the hashmap
        if(b != null){
          b.setTime(b.getTime() + pasteTime);
          b.setY(t.calculateGridYPos(b.getTime()));
          t.gridBlocks.put(b.getTime(), b);
        }
      }
    }
  }
  
  public void setBeatsPerBar(int beats){
    for(Track t : tracks){
      t.setBeatsPerBar(beats);
    }
  }
  
  public void setGridResolution(float resolution){
    for(Track t : tracks){
      t.setGridResolution(resolution);
    }
  }
  
  public void setBPM(float bpm){
    for(Track t : tracks){
      t.setBPM(bpm);
    }
  }
  
  public void setTranslucent(boolean t){
    this.translucent = t;
  }
  
  public void display(){
    super.display();
    Track t;
    /*fill(this.getFillColor());
    stroke(#333333);
    rect(this.getX(), this.getY(), this.getWidth(), this.getHeight());
    */
    
    for (int i = 0; i < tracks.size(); ++i){
      t = tracks.get(i);
      
      if(!translucent){
        if(i > 0){
          stroke(color(#333333));
          line(t.getX(), t.getY(), t.getX(), t.getY() + t.getHeight());
        }
      }
      t.display();
    }
    
  }
}