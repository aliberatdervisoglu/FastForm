# ⚡ Fast Form

![Swift](https://img.shields.io/badge/Swift-FA7343?style=for-the-badge&logo=swift&logoColor=white)
![SwiftUI](https://img.shields.io/badge/SwiftUI-000000?style=for-the-badge&logo=swift&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=for-the-badge&logo=firebase&logoColor=black)
![Architecture](https://img.shields.io/badge/Architecture-MVVM-blueviolet?style=for-the-badge)

**Fast Form**, is a modern, dynamic, and highly scalable iOS form builder application. It allows users to create custom forms, share them instantly, and track real-time responses with a beautifully crafted native SwiftUI interface.

## ✨ Key Features

* 🔍 **Direct Search & Access:** No more scrolling through endless lists. Instantly find and access any form directly by its title using the powerful search mechanism.
* 👁️ **Pixel-Perfect Preview Mode:** View submitted responses exactly as the respondent filled them out. The details view acts as a perfect replica of the original form, locking the UI into a gorgeous, read-only state.
* 🏗️ **Dynamic Form Builder:** Supports 6 different question types (Short Answer, Paragraph, Multiple Choice, Checkboxes, Dropdown, Toggle). Designed with an extensible architecture, making it incredibly easy to add new question types in the future with minimal code changes.
* 👻 **Anonymous Submissions:** Respects user privacy with a built-in toggle to collect responses completely anonymously without storing user credentials.
* 🎨 **Premium UI/UX:** Ditching the rigid standard iOS `List` views for custom-built, gradient-filled, and softly shadowed cards. Complete with interactive spring animations and seamless transitions.

## 🧠 Data Architecture: The Dictionary Approach

At the core of Fast Form is a highly optimized data structure. Instead of rigid, hardcoded data models, responses are handled using a **Dictionary-based mapping (`[String: Answer]`)**:

```swift
var answers: [String: Answer] // Mapping QuestionID directly to its Answer
```
**Why is this powerful?**
1. **O(1) Time Complexity:** Fetching a specific answer for a specific question happens instantly.
2. **Ultimate Scalability:** Whether a form has 2 questions or 200, the data model remains perfectly flat and lightweight.
3. **Future-Proof:** Adding a "Date Picker" or "Slider" question type tomorrow requires **zero** changes to the database schema. The dictionary simply accepts the new payload dynamically.

## 🛠️ Tech Stack

* **UI Framework:** SwiftUI (iOS 26.2+)
* **Architecture:** MVVM (Model-View-ViewModel)
* **Backend & Database:** Firebase Cloud Firestore (NoSQL)
* **Authentication:** Firebase Auth (Email & Password)
* **Version Control:** Git & GitHub

## 👨‍💻 Author

Developed with passion by **Ali Berat Dervişoğlu**
