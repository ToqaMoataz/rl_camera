# Smart Camera Filter App

A smart camera app that provides real-time frame analysis, scanning, and on-device object detection.

📺 Demo & Screen Recording
Video Demo: https://drive.google.com/drive/folders/1N3QJmkIwTPtoOmHpaqZHK94hOHf_l7BZ?usp=drive_link

Highlights: A 2-minute demonstration showing Option A (Smart Frame Gate), Option B (Scan Mode), Option C (On-Device TFLite Detector), and general UI navigation.

---

## ✅ Chosen Options

This project implements **Option A**, **Option B**, and **Option C**.

| Option | Feature | Status |
|--------|---------|--------|
| A | Smart Frame Gate (Quality Filter) | ✅ Complete |
| B | Scan Mode (Stabilized Capture Filter) | ✅ Complete |
| C | On-Device TFLite Detector | ✅ Complete |

---

## 🛠 Features

### ✅ Option A: Smart Frame Gate (Quality Filter)
Builds a camera preview that scores each frame and decides ACCEPT / REJECT based on:

- **Sharpness**: Blur score analysis using Laplacian variance.
- **Motion**: Shake score detection by comparing consecutive frames.
- **Exposure**: Brightness score evaluation from the Y channel.

Goal: Automatically capture the best 10 frames within 15 seconds and display live metrics.

---

### ✅ Option B: Scan Mode (Stabilized Capture Filter)
A dedicated Scan mode for cleaner image results using simple image processing:

- **Processing**: Crop to content, deskew, contrast enhancement, and adaptive thresholding.
- **Comparison**: Before / After view inside the app.

> Note: Use your own test photos. No private datasets are required.

---

### ✅ Option C: On-Device TFLite Detector
Integration of EfficientDet-Lite0 (public TFLite model) running on the live camera stream:

- **Preprocessing**: YUV→RGB conversion, letterbox resize to 300×300, tensor conversion — all offloaded to isolates for smooth performance.
- **Inference**: Running model inference fully on-device using `tflite_flutter`.
- **Coordinate Mapping**: Reversing letterbox padding and scaling boxes to screen pixels correctly.
- **Label Alignment**: COCO labels correctly aligned with model output using index offset (+1 for background class).
- **Custom NMS**: Non-Max Suppression implemented manually from scratch using IoU — no ready-made packages used.
- **Unit Test**: NMS verified with a toy example covering: overlapping boxes, non-overlapping boxes, empty input, and identical boxes — all passing ✅

---

### 📱 General App Features
- Tab Navigation: Easy switching between app functionalities.
- Metrics Display: Real-time dashboard showing processed vs accepted frames, average quality scores, FPS, and processing time per frame.

---

## 📱 Device Information & Performance

| | Option A | Option C |
|--|---------|---------|
| Device | Realme 9i | Realme 9i |
| Average FPS | ~4 FPS | ~4 FPS |
| Avg inference time | ~155 ms | ~155 ms per frame |

---

## 🔧 Biggest Issues Faced & Solutions

- **Camera Lifecycle Management**: The camera would block or stop working if the app was left without properly closing it. Fixed by implementing proper lifecycle management to initialize and dispose of the camera when the app is paused, inactive, or resumed.

- **Performance Challenges with Frame Processing**: The first frames were unstable due to camera warm-up, resulting in low FPS and inconsistent results. Fixed by skipping the initial warm-up frames, using time-based throttling instead of frame counting, and offloading heavy processing (YUV conversion, resize, tensor conversion) to Dart isolates via `compute()`.

- **False Object Detections in Option C**: The model was detecting objects that did not exist in the scene (e.g., detecting a spoon when pointing at a mouse). Fixed by correcting the preprocessing pipeline — properly reversing the letterbox padding offset when mapping model output coordinates back to screen space, and aligning COCO label indices correctly with a +1 background class offset.

---

## 🚀 How to Run

1. **Clone or Unzip**: Clone the repository or unzip the project folder.
2. **IDE**: Open the project in Android Studio or VS Code with Flutter support.
3. **Permissions**: Ensure your device has camera permission enabled.
4. **Run**: Execute `flutter run` or use your IDE's run button.
5. **Test NMS**: Run `flutter test test/nms_test.dart` to verify NMS unit tests pass.

> ⚠️ **Important**: Allow camera access when prompted; otherwise, the app cannot function correctly.

---

## Screenshots

![Intial Screen](screenshots/1.png)
![Filtiring tab one](screenshots/2.png)
![Filtiring tab two](screenshots/3.png)
![Filtiring result](screenshots/4.png)
![Scan tab one](screenshots/5.png)
![Scan tab two](screenshots/6.png)
![Scan result](screenshots/7.png)
![Detecting tab one](screenshots/8.png)
![Detecting tab two](screenshots/9.png)
