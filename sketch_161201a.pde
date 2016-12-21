  // Global variables
Table tripTable;
Trips[] trip;
PImage img;
PShape map;
PFont f;


// View 1 = NYC
// int totalFrames = 3600;
// int totalMinutes = 46400;
// float minLat = 40.926510033;
// float maxLat = 40.56800447;
// float minLon = -74.06000068;
// float maxLon = -73.749000482;
  
// View 2  = USA
int totalFrames = 6600;
int totalMinutes = 1266400;
float minLat = 60; //usa16_earch: 75 //usa15_dark: 90 // 88.211; // works on usa13
float maxLat = 14.0; //usa16_earth: 2.0 //usa15_dark: -6 // -16.553;//works!
float minLon = -128.518; //usa16_earth: -147.918 //usa15_dark: -180.918; //-162.384; // works! 
float maxLon = -82.83; //usa16_earth: -77.53 //usa15_dark: -86.53 //-59.982; // works!

void setup() {
  //fullScreen();
  size(1093, 684);
  //size(795, 800);
  img = loadImage("usa17_earth.png");
  //img = loadImage("dots.png");
  //map = loadShape("usa2.svg");
  loadData();
  println("All done...");
}

void loadData() {
  
  //tripTable = loadTable("/Users/Will/Dropbox/Documents/School/Grad School/Columbia/Courses/2016 Fall/Mapping/us_amtrak/02_data/master_v4csv.csv", "header");
  tripTable = loadTable("/Users/Will/amtrak/legsconcat3.csv", "header");
  println(str(tripTable.getRowCount()) + " records loaded...");
  trip = new Trips[tripTable.getRowCount()];
  for (int i=0; i<tripTable.getRowCount(); i++) { //******** take this back up to the full dataset *********
    int duration = round(map(tripTable.getInt(i, "tripduration"), 0, totalMinutes, 0, totalFrames));        
    // starttime should be in m/d/yy h:mm format
    String timestamp = split(tripTable.getString(i, "starttime"), " ")[1];

    String[] startdatetime = split(tripTable.getString(i, "starttime"), " ");
    String[] enddatetime = split(tripTable.getString(i, "stoptime"), " ");

    int startday = int(split(startdatetime[0], "/")[1]) - 1;
    int endday = int(split(enddatetime[0], "/")[1]) - 1;

    String[] starttime = split(split(tripTable.getString(i, "starttime"), " ")[1], ":");
    String[] endtime = split(split(tripTable.getString(i, "stoptime"), " ")[1], ":");

    float startSecond_day1 = int(starttime[0]) * 3600 + int(starttime[1]) * 60;    
    float endSecond_day1 = int(endtime[0]) * 3600 + int(endtime[1]) * 60;

    float startSecond = startday*24*60*60 + startSecond_day1;
    float endSecond = endday*24*60*60 + endSecond_day1;

    int startFrame = floor(map(startSecond, 0, totalMinutes, 0, totalFrames));
    int endFrame = floor(map(endSecond, 0, totalMinutes, 0, totalFrames));
    String startStation = tripTable.getString(i, "start station id");
    String endStation = tripTable.getString(i, "end station id");
    float startX = map(tripTable.getFloat(i, "start station longitude"), minLon, maxLon, 0, 800);
    float startY = map(tripTable.getFloat(i, "start station latitude"), minLat, maxLat, 0, 800);
    float endX = map(tripTable.getFloat(i, "end station longitude"), minLon, maxLon, 0, 800);
    float endY = map(tripTable.getFloat(i, "end station latitude"), minLat, maxLat, 0, 800);
    int route_id = tripTable.getInt(i, "route_id");
    int region_id = tripTable.getInt(i, "RegionNumber");
    int train_id = tripTable.getInt(i, "TrainNumber");
    trip[i] = new Trips(duration, startFrame, endFrame, startStation, endStation, startX, startY, endX, endY, route_id, region_id, train_id);
  }
}


void draw() { 

  // Move back to draw later
  noStroke();
  fill(0);
  rect(0, 0, width, height);
  fill(0);

  //tint(200); 
  image(img, 0, 0, width, height);
  //shape(map, 0, 0,map.width*1, map.height*1);            // Draw at coordinate (280, 40) at the default size

  //int startFrame = floor(map(startSecond, 0, totalMinutes, 0, totalFrames));
  //text(""+frameCount, 20, 300);


  fill(0, 0, 0, 0.2);
  rect(0, 0, width, height);
  
  // framerate
  //surface.setTitle(int(frameRate) + " fps");
 
  for (int i=0; i<trip.length; i++) {
    int region_id = tripTable.getInt(i, "RegionNumber");
    //String time = tripTable.getString(i, "timestamp");

    if (region_id == 1) {  // northeast corridor
      trip[i].plotRide(); 
      color c = color(65,105,225); // royal blue
      fill(c,255);
    } 
    else if (region_id == 2) { // east
      trip[i].plotRide();
      color c = color(75,0,130); // indigo
      fill(c,255);
    }
    else if (region_id == 3) { // midwest
      trip[i].plotRide();
      color c = color(255,255,0); // yello
      fill(c,255);
    }
    else if (region_id == 4) { // west
      trip[i].plotRide();
      color c = color(220,20,60); // crimson
      fill(c,255);
    }
    else if (region_id == 5) { // California Corridor
      trip[i].plotRide();
      color c = color(148,0,211); // darkviolet
      fill(c,255);
    }
  }
  
  // Legend
  f = createFont("Helvetica", 16, true);  // Loading font

  // 1. Northeast Corridor
  fill(65,105,225);
  rect(14, 500, 155, 25, 7);
  fill(255, 255, 255);
  textFont(f, 18);
  text("Northeast Corridor", 16, 520);
  
  // 2. East
  fill(75,0,130);
  rect(14, 530, 155, 25, 7);
  fill(255, 255, 255);
  textFont(f, 18);
  text("East Service", 16, 550);
  
  // 3. Midwest
  fill(255,255,0);
  rect(14, 560, 155, 25, 7);
  fill(0, 0, 0);
  textFont(f, 18);
  text("Midwest Service", 16, 580);
  
  // 4. West
  fill(220,20,60);
  rect(14, 590, 155, 25, 7);
  fill(255, 255, 255);
  textFont(f, 18);
  text("West Service", 16, 610);
  
  // 5. California Corridor
  fill(148,0,211);
  rect(14, 620, 155, 25, 7);
  fill(255, 255, 255);
  textFont(f, 18);
  text("California Corridor", 16, 640);

 
  
  // Signature
  f = createFont("AppleSDGothicNeo-Light", 20, true);  // Loading font
  fill(50, 50, 50);
  textFont(f, 22);
  text("@wgeary", 980, 640);
 
  // Title
  fill(0,0,0,180);
  rect(14, 50, 380, 68, 7);
  fill(255, 255, 255);
  textFont(f, 36);
  text("America by Train", 18, 90);
  textFont(f, 16);
  text("One week of Amtrak activity (Monday through Sunday)", 18, 110);

  
  
  //saveFrame();
}