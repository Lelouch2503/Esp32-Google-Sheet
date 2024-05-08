ESP32-GoogleSheet-Flutter
Description:
  - This is a sample project to update data from ESP32 to Google Sheet and display data from Google Sheet on Android mobile app using Flutter. 
  - The project includes source code for ESP32, Flutter app, and instructions on how to set up and use.

Features
  - ESP32 sends sensor data to Google Sheet via Google API.
  - Flutter app displays data from Google Sheet and allows users to update information.

Installation
  - ESP32, dht22
![image](https://github.com/Lelouch2503/Esp32-Google-Sheet/assets/107485957/1d1725f1-4991-400e-b4f9-429e1d135687)


Flutter App
  - Copy the source code from the Flutter_App directory to a Flutter project.
  - Update the Google Sheets API key in the Flutter_App/lib/services/google_sheets_api.dart file as instructed.
  - Run the app on a device or emulator.
  ![image](https://github.com/Lelouch2503/Esp32-Google-Sheet/assets/107485957/de7b887d-c0d6-4160-ae4d-42ffeeb4eb6b)


  
Requirements
  - ESP32 with firmware supporting Wi-Fi connection and communication with Google API.
  - Arduino IDE to compile and upload the source code for ESP32.
  - Flutter project installed and configured.
  - Google Sheets API key for accessing and updating data.
