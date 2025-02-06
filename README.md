# BNH Meals on Wheels Delivery App  

## Overview
The **BNH Meals on Wheels Delivery App** is a Flutter-based mobile application designed to streamline the delivery process for the BNH Meals on Wheels program. The app enables delivery personnel to capture delivery details using their phone camera, process the captured data for delivery addresses and recipient names, and manage delivery statuses efficiently.

## Features
- **Camera Integration**: Capture images of delivery documents using the device's camera.
- **OCR (Optical Character Recognition)**: Extract recipient names and addresses from captured images using Google ML Kit.
- **Delivery Management**: Display delivery information in a list and allow status toggling between "Not Delivered" and "Delivered".
- **Navigation Integration**: Directly navigate to the recipient's address using Google Maps.

## Technologies Used
- **Flutter**: Cross-platform mobile application framework.
- **Google ML Kit**: For text recognition from images.
- **Camera**: For capturing delivery document images.
- **Path Provider**: For managing file storage and retrieval.

## Installation

### Prerequisites
Ensure the following tools are installed:
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- Xcode (for iOS development)
- Android Studio (for Android development)

### Steps
1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/delivery_app.git
   cd delivery_app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   - For iOS:
     ```bash
     flutter run -d ios
     ```
   - For Android:
     ```bash
     flutter run -d android
     ```

## Usage
1. **Capture Delivery Document**:
   - Tap on "Capture Delivery Image" to use the camera and take a photo of the delivery document.
2. **Process Captured Data**:
   - The app will automatically extract delivery details (names, addresses) from the photo.
3. **Manage Deliveries**:
   - View all deliveries in a list.
   - Toggle delivery statuses between "Not Delivered" and "Delivered".
4. **Navigate to Addresses**:
   - Tap the "Navigate" button to open Google Maps with the recipient's address pre-filled.

## Project Structure
```
lib/
├── main.dart            # Application entry point
├── screens/
│   └── delivery_home.dart  # Main UI for managing deliveries
├── services/
│   ├── camera_service.dart # Camera-related logic
│   └── ocr_service.dart    # OCR processing logic
└── models/
    └── delivery.dart       # Data model for deliveries
```

## Contributing
Contributions are welcome! To contribute:
1. Fork this repository.
2. Create a feature branch: `git checkout -b feature-name`
3. Commit your changes: `git commit -m 'Add feature'`
4. Push to the branch: `git push origin feature-name`
5. Submit a pull request.

## License
This project is licensed under the [MIT License](LICENSE).

## Acknowledgments
- [Google ML Kit](https://developers.google.com/ml-kit) for OCR.
- [Flutter](https://flutter.dev/) for providing an amazing cross-platform framework.
