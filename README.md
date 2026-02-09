# 📝 EverDo - Ultimate Productivity Companion

![Flutter](https://img.shields.io/badge/Flutter-3.0%2B-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-2.18%2B-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Architecture](https://img.shields.io/badge/Architecture-Clean%20Arc-4caf50?style=for-the-badge)
![State Management](https://img.shields.io/badge/State-Provider-hv?style=for-the-badge&color=blue)

**EverDo** is a comprehensive, feature-rich productivity application built with **Flutter**. It seamlessly integrates **Note-taking**, **Task Management (To-Do)**, and **Personal Diary** into a single, beautifully designed interface. 

Designed with a focus on **User Experience (UX)** and **Clean Architecture**, EverDo ensures scalability, maintainability, and a premium feel with its custom "Ice Theme" and full **Arabic Language Support**.

---

## ✨ Key Features

### 1. 📒 Smart Notes
*   **Grid View Interface**: Visually appealing card-based layout.
*   **Customization**: Color-code your notes for better organization.
*   **Rich Text Support**: (Planned/Implemented features for text styling).
*   **CRUD Operations**: Seamlessly create, read, update, and delete notes.

### 2. ✅ To-Do List Manager
*   **Quick Add**: Rapidly add tasks to your day.
*   **Swipe Actions**: Intuitive swipe-to-delete functionality.
*   **Progress Tracking**: Mark tasks as complete and track your productivity.
*   **Offline-First**: Tasks are saved locally and persist across sessions.

### 3. 📔 Personal Diary & Mood Tracker
*   **Memories**: Record your daily thoughts with timestamps.
*   **Visual Diary**: Attach photos to your entries.
*   **Mood Tracking**: Interactive slider and emoji selector to track your emotional well-being.
*   **Arabic Typography**: Beautiful custom Arabic fonts (Uthman Taha, Jomhuria).

### 4. 🔐 Advanced Security
*   **Biometric Auth**: Secure your data with Fingerprint or Face ID (`local_auth`).
*   **PIN Protection**: Fallback PIN mechanism with security questions for recovery.
*   **Privacy First**: All data is stored locally on the device using secure storage practices.

### 5. 🎨 UI/UX Excellence
*   **Theme System**: Toggle between **Light** and **Dark** modes instantly.
*   **Responsive Design**: Optimized for various screen sizes.
*   **Custom Assets**: Unique icons and professionally curated color palettes.

---

## 🏗️ Software Architecture

EverDo is built following the **Clean Architecture** principles to ensure separation of concerns and testability.

### **Layers Breakdown:**

1.  **Presentation Layer (UI)**:
    *   **Widgets**: UI components (`NotesScreen`, `TodoScreen`, `DiaryScreen`).
    *   **State Management**: Uses `Provider` (`NotesProvider`, `TodoProvider`, `DiaryProvider`) to manage state and communicate with the Domain layer.

2.  **Domain Layer (Business Logic)**:
    *   **Entities**: Pure Dart objects (`Note`, `Todo`, `DiaryEntry`).
    *   **Use Cases**: Encapsulate single business actions (e.g., `GetNotes`, `AddDiaryEntry`).
    *   **Repositories Interfaces**: Abstract definitions of data operations.
    *   *Note: This layer is completely independent of Flutter and external libraries.*

3.  **Data Layer (Data Access)**:
    *   **Models**: Data transfer objects with JSON serialization (`NoteModel`, `TodoModel`).
    *   **Data Sources**: Implementations for local storage (using `SharedPreferences`).
    *   **Repositories Implementations**: Concrete classes that coordinate data retrieval.

### **Project Structure:**
```
lib/
├── core/                   # Shared utilities, errors, and constants
├── features/               # Feature-based folder structure
│   ├── diary/              # Diary feature (Data, Domain, Presentation)
│   ├── notes/              # Notes feature
│   └── todo/               # ToDo feature
├── screen/                 # Main screens and navigation
├── providers/              # Global state providers (e.g., ThemeProvider)
└── main.dart               # Entry point and dependency injection
```

---

## 🛠️ Tech Stack

*   **Framework**: [Flutter](https://flutter.dev/)
*   **Language**: [Dart](https://dart.dev/)
*   **State Management**: `provider`
*   **Local Storage**: `shared_preferences`
*   **Authentication**: `local_auth`
*   **Functional Programming**: `dartz` (for `Either` type handling)
*   **Assets**: `image_picker`

---

## 🚀 Getting Started

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/everdo_app.git
    ```
2.  **Install dependencies**:
    ```bash
    cd everdo_app
    flutter pub get
    ```
3.  **Run the app**:
    ```bash
    flutter run
    ```

---

## 📸 Screenshots

| Splash Screen | Notes | To-Do | Diary |
|:---:|:---:|:---:|:---:|
| *(Place your screenshot here)* | *(Place your screenshot here)* | *(Place your screenshot here)* | *(Place your screenshot here)* |

---