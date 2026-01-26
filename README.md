# rl_camera_filters

A new Flutter project.

# Smart Camera Filter App

This project is a smart camera app that provides real-time frame analysis, scanning, and detection features.  

## Selected Options
- **Option A:** Smart frame filtering  
- **Option B:** Scan mode processing  

## Device Information
- **Device model:** Realme 9i  
- **Average FPS:** ~4 FPS  
- **Average inference time per frame:** ~155 ms (approximate)  

## How to Run
1. Clone the repository or unzip the project folder.  
2. Open the project in **Android Studio** or **VS Code** with Flutter support.  
3. Ensure your device has **camera permission** enabled.  
4. Run the app on your device using `flutter run` or your IDE.  
5. Use the on-screen buttons to start filtering or scanning.  
6. Navigate between the app’s tabs to access all features.  

> ⚠️ Important: Allow camera access when prompted; otherwise, the app cannot function correctly.  

## Biggest Issues Faced & Solutions
1. **Camera Lifecycle Management:**  
   - **Problem:** The camera would block or stop working if the app was left without properly closing the camera.  
   - **Solution:** Implemented proper lifecycle management to initialize and dispose of the camera when the app is paused, inactive, or resumed.  

2. **Performance Challenges with Frame Processing:**  
   - **Problem:** The first frames were unstable due to camera warm-up, resulting in low FPS and inconsistent results.  
   - **Solution:** Skipped the initial frames during the warm-up period and processed a fixed number of frames per second to stabilize performance.  

3. **Threshold and Metrics Calibration:**  
   - **Problem:** Determining accurate thresholds for metrics like sharpness, exposure, and motion was challenging.  
   - **Solution:** Iteratively tested multiple values until achieving reasonably accurate results. Calculating metrics for frames was complex but improved with experimentation.  

## Features
- Real-time frame filtering with smart scoring metrics.  
- Scan mode for image processing and analysis.  
- Tab navigation to access different app functionalities.  
- Metrics display including processed frames, accepted frames, average scores, FPS, and processing time.  

## Notes
- The app’s average FPS on Realme 9i is around 4 FPS.  
- Average frame processing time is ~155 milliseconds.  
- Users can navigate between tabs and use buttons normally to test all features.  

## Screen Recording
A 2 minutes screen recording demonstrating the app’s functionality should be included in the email.  


