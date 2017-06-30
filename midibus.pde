import themidibus.*; MidiBus myBus;
int[] knob =   {63 ,0 ,0 ,0 ,0 ,0 ,50 ,50};
int[] slider = {63 ,63 ,63 ,63 ,63 ,63 ,63 ,63};
int[] button = {0 ,0 ,0 ,0 ,0 ,0 ,0 ,0};
float valueMin;
float valueMax;
void midibusSetup(int min,int max){
  myBus = new MidiBus(this, 0,1);
  try { loadMidibus("midibus.txt"); }catch(Exception e){
  	saveMidibus("data/midibus.txt"); println("the file \"midibus.txt\" CREATED");
  }
  valueMin = min;
  valueMax = max;
}

void controllerChange(int channel, int number, int value) {
  if(number<=7)                 slider[number] = int(map(value,0,127,valueMin, valueMax));
  if(number>=16 && number<=23) knob[number-16] = int(map(value,0,127,valueMin, valueMax)) ;

  if(number>=32 && number<=39){ button[number-32] = 1 ; println("1"); }
  if(number>=48 && number<=55){ button[number-48] = 0  ; println("0"); }
  if(number>=64 && number<=71){ button[number-64] = -1  ; println("-1"); }
  saveMidibus("data/midibus.txt");
  println("___ "+value);
  redraw();
}

void importMidibus(){
  selectInput("Select a midibus file :", "import_midibusSelected");
}
void import_midibusSelected(File selection) {
  if (selection != null)
    loadMidibus( selection.getAbsolutePath() );
}

void exportMidibus(){
  selectOutput("Name the midibus file :", "export_midibusSelected");
}
void export_midibusSelected(File selection) {
  if (selection != null)
  	fileName = selection.getAbsolutePath();
    saveMidibus( selection.getAbsolutePath()+".txt" );
    isRecording = true;
    redraw();
}


void saveMidibus(String name){
  String str[] = new String[8];
  for (int i = 0; i < 8; ++i) {
    str[i]  =   knob[i] + " " ;
    str[i] += slider[i] + " " ;
    str[i] += button[i] + "" ;
  }
  saveStrings(name, str);
}

void loadMidibus(String name){
  String str[] = loadStrings(name);
  for (int i = 0; i < 8; ++i) {
    println("str[i]: "+str[i]);
    String tmp[] = split(str[i]," ");
      knob[i] = int(tmp[0]) ;
    slider[i] = int(tmp[1]) ;
    button[i] = int(tmp[2]) ;
  }
  redraw();
}
