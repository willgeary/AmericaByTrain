class Trips{
  // Class properties
  PVector start, end;
  int tripFrames, startFrame, endFrame;
  String time;
  PFont f;  // font variable


  // Class constructor
  Trips(int duration, int start_frame, int end_frame, String startStation, String endStation, float startX, float startY, float endX, float endY, int route_id, int region_id, int train_id)
  {
    start = new PVector(startX, startY);
    end = new PVector(endX, endY);
    tripFrames = duration;
    startFrame = start_frame;
    endFrame = end_frame;
  }
  // Class methods
  void plotRide(){
    if (frameCount >= startFrame && frameCount < endFrame){
      float percentTravelled = (float(frameCount) - float(startFrame)) / float(tripFrames);
      PVector currentPosition = new PVector(lerp(start.x, end.x, percentTravelled), lerp(start.y, end.y, percentTravelled));
      ellipse(currentPosition.x, currentPosition.y, 6, 6);


    }
    else{
    }
  }
}