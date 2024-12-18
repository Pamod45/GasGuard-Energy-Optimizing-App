# GasGuard-Energy-Optimizing-App

GasGuard is a smart IoT-enabled mobile application designed to monitor and optimize gas cylinder usage in homes and businesses. By leveraging real-time gas monitoring, predictive analytics, and actionable notifications, the system promotes energy efficiency and responsible gas consumption.

Developed as part of the **Higher National Diploma in Software Engineering (HNDE)** final project, GasGuard integrates IoT devices and AI-powered solutions to address challenges in domestic gas management.

---

## Table of Contents 📚

- [Introduction](#introduction-)
- [Features](#features-)

- [Technology Stack](#technology-stack)

- [Testing Strategies](#testing-strategies-)
- [Challenges and Solutions](#challenges-and-solutions-)
- [Future Directions](#future-directions-)
- [Team](#team-)
- [Contributors](#contributors-)

---

## Introduction 📋

GasGuard tackles the inefficiencies in gas management, such as:
- Difficulty in **monitoring gas levels** accurately.
- Lack of **predictions** for gas consumption patterns.
- Unexpected gas depletion causing disruptions.
- Wastage of energy and increased costs.

### Key Objectives:
- Provide **real-time monitoring** of gas levels using IoT sensors.
- Use **AI-powered analytics** to predict days remaining for gas usage.
- Send timely **refill notifications** and consumption tips.
- Promote energy savings and sustainability.

---

## Features 🔧

### General Features:
- **Real-Time Monitoring**: IoT-enabled weight sensors measure gas levels.
- **Predictive Analytics**: AI models estimate the remaining days of gas usage.
- **Refill Alerts**: Users receive notifications before gas runs out.
- **Custom Reports**: View daily, monthly, and custom gas usage analysis.

### User-Specific Features:

#### Home Users:
- Add and track multiple gas cylinders.
- Monitor gas usage history and patterns.
- Receive refill reminders and tips.

#### Business Users:
- Analyze aggregated gas usage data for better decision-making.
- Optimize gas consumption to reduce costs.
- Predict gas requirements to prevent overstocking or shortages.

---

## Technology Stack 🛠️

- **Frontend**: Flutter (Dart)
- **Backend**: Firebase
- **IoT Integration**: Arduino (weight sensors and Bluetooth HC-05 module)
- **Machine Learning**: TensorFlow (LSTM predictive model)
- **Development Tools**:
  - Android Studio
  - Visual Studio Code
  - Figma (UI/UX design)
- **Database**: Firebase Realtime Database
- **Version Control**: GitHub

---

## System Design 🗃️

The system follows a modular and layered architecture:

1. **IoT Layer**: Weight sensors collect real-time data and communicate via Bluetooth.
2. **Application Layer**: Flutter-based mobile app displays data, notifications, and forecasts.
3. **Database Layer**: Firebase handles storage and data processing.
4. **AI Module**: TensorFlow-based LSTM model analyzes and predicts gas usage trends.

### UML Diagrams:
- **Use Case Diagram**: Captures user interactions.
- **Class Diagram**: Defines object-oriented relationships.
- **ER Diagram**: Database schema for structured storage.

---

## Setup and Installation ⚙️

1. Clone this repository:
   ```bash
   git clone https://github.com/your-username/gasguard.git
   
2. Open the project in Android Studio or Visual Studio Code.
   
3. Install Flutter dependencies:
   ```bash
   flutter pub get
   
4. Connect your IoT device (HC-05 Bluetooth module and weight sensors).
   
5. Run the application on an Android device or emulator:
   ```bash
   flutter run

---

## Testing Strategies 🧪

To ensure reliability and accuracy, the following testing strategies were employed:

1. Functional Testing:
    - Verified gas level readings.
    - Ensured notifications trigger at appropriate thresholds.
2. Integration Testing:
    - Tested IoT-Bluetooth communication and Firebase data synchronization.
3. Load Testing:
    - Simulated heavy data loads to ensure system stability.
4. Usability Testing:
    - Conducted user feedback sessions to improve UI/UX.
  
---

## Challenges and Solutions 🚀

### Challenges

1. **IoT Connectivity**: Ensuring stable Bluetooth communication.
2. **AI Model Accuracy**: Training the LSTM model with limited gas usage data.
3. **Database Optimization**: Handling real-time updates without delays.

### Solutions

1. Optimized Bluetooth module data transfer.
2. Collected gas usage datasets for better model training.
3. Used Firebase for scalable and efficient database management.

---

## Future Directions 🔮

1. Integrate renewable energy sources for advanced sustainability.
2. Add support for multi-platform deployments (iOS, Web).
3. Enhance AI recommendations for better consumption efficiency.
4. Introduce multi-user role management for businesses

---

## Team 🫂
1. T.H.P.P. Perera - COHNDSE232F-084
2. K.V.K. Perera - COHNDSE232F-087
3. N.D. Wickramaarachchi - COHNDSE232F-089

- Supervisor: Mr. Keerthi Kodithuwakku

---

## Contributors ✨
  We welcome contributions to improve GasGuard!
  - Report bugs or suggest enhancements via issues.
  - Open a pull request with detailed explanations for significant changes.

---

## Acknowledgement 🙏
  - Special thanks to our supervisor Mr. Keerthi Kodithuwakku for his invaluable guidance and continuous support.

---


