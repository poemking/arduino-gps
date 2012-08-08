#include <string.h>
#include <ctype.h>
#include <SoftwareSerial.h>
#include <TinyGPS.h>
#include <SD.h>
#include <dGPS.h>
// Software serial TX & RX Pins for the GPS module
dGPS dgps;                        // Construct dGPS class
File gpsLog;

#define SoftrxPin 3
#define SofttxPin 4
// Initiate the software serial connection
SoftwareSerial nss = SoftwareSerial(SoftrxPin, SofttxPin);
char filename[] = "test9.txt";

void setup() {
  Serial.begin(9600);
  dgps.init();                   // Run initialization routine for dGPS.
  Serial.print("Initializing SD card...");
  pinMode(10, OUTPUT);
  
  if (!SD.begin(4)) {
    Serial.println("initialization failed!");
    return;
  }
  Serial.println("initialization done.");
}

void loop()
{
    if(Serial.available() > 0) {
      char c = Serial.read();
      if(c == 49) {
         gpsLog = SD.open(filename);
         if (gpsLog) {
           Serial.print(filename);
           Serial.print(":");
           Serial.println();
            while (gpsLog.available()) {
             Serial.write(gpsLog.read());
            }
           gpsLog.close();
         }
        }
      }

  gpsLog = SD.open(filename, FILE_WRITE);
  dgps.update();
   if(gpsLog) {
     if(*dgps.Status() == 'A') {
       if(dgps.Lat() > 0 && dgps.Lon() < 0) {
	  Serial.println("logging gps data");
	  Serial.println(dgps.Status());
	  gpsLog.print(dgps.Date());
	  gpsLog.print(dgps.Time());
	  gpsLog.print(",");
	  gpsLog.println(dgps.Lat(), 6);
	   Serial.println(dgps.Lat(), 6);
	  gpsLog.print(",");
	  gpsLog.print(dgps.Lon(), 6);
	  Serial.println(dgps.Lon(), 6);
	  }
     }
     } else {
	  Serial.println("Error writing to gpsLog");
     }
   gpsLog.close();
}