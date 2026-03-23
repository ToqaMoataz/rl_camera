Smart Camera Filter App
This project is a smart camera app that provides real-time frame analysis, scanning, and detection features.

📺 Demo & Screen Recording
Video Demo: (https://drive.google.com/drive/folders/1N3QJmkIwTPtoOmHpaqZHK94hOHf_l7BZ?usp=drive_link).

Highlights: A 2-minute demonstration showing Option A (Smart Frame Gate), Option B (Scan Mode), and general UI navigation.

🛠 Features
✅ Option A: Smart Frame Gate (Quality Filter) - [COMPLETE]
Builds a camera preview that scores each frame and decides ACCEPT / REJECT based on:

Sharpness: Blur score analysis.

Motion: Shake score detection.

Exposure: Brightness score evaluation.

Goal: Automatically capture the “best” 10 frames within 15 seconds and show live metrics.

✅ Option B: Scan Mode (Stabilized Capture Filter) - [COMPLETE]
A dedicated "Scan" mode for cleaner image results using simple image processing:

Processing: Includes crop to content, deskew, contrast enhancement, and adaptive thresholding.

Comparison: Includes a Before / After view inside the app.

Note: Use your own test photos (anything you shoot yourself). No private datasets are required.

⏳ Option C: On-Device TFLite Detector - [IN PROGRESS]
Integration of a public TFLite object detection model on the live camera stream.

Preprocessing: Resizing and letterboxing logic.

Inference: Running model inference directly on-device.

Custom NMS: Implementing Non-Max Suppression manually (not a ready-made package).

Extra Requirement: A small unit test for NMS using a “toy example” output tensor to verify expected final boxes.

📱 General App Features
Tab Navigation: Easy access to switch between different app functionalities.

Metrics Display: Real-time dashboard showing:

Processed frames vs. Accepted frames.

Average quality scores.

Current FPS.

Processing time per frame.

📱 Device Information & Performance
Device model: Realme 9i

Average FPS: ~4 FPS

Average inference time per frame: ~155 ms (approximate)

🔧 Biggest Issues Faced & Solutions
Camera Lifecycle Management: * Problem: The camera would block or stop working if the app was left without properly closing the camera.

Solution: Implemented proper lifecycle management to initialize and dispose of the camera when the app is paused, inactive, or resumed.

Performance Challenges with Frame Processing: * Problem: The first frames were unstable due to camera warm-up, resulting in low FPS and inconsistent results.

Solution: Skipped the initial frames during the warm-up period and processed a fixed number of frames per second to stabilize performance.

Threshold and Metrics Calibration: * Problem: Determining accurate thresholds for metrics like sharpness, exposure, and motion was challenging.

Solution: Iteratively tested multiple values until achieving reasonably accurate results. Calculating metrics for frames was complex but improved with experimentation.

🚀 How to Run
Clone or Unzip: Clone the repository or unzip the project folder.

IDE: Open the project in Android Studio or VS Code with Flutter support.

Permissions: Ensure your device has camera permission enabled.

Run: Execute flutter run or use your IDE's run button.

Test: Use the on-screen buttons to start filtering or scanning and navigate between tabs to access all features.

⚠️ Important: Allow camera access when prompted; otherwise, the app cannot function correctly.
