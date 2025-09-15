# my_todos_application

📝 Flutter Todo App

A simple and elegant Todo Manager built with Flutter and SQLite.
This app allows users to add, edit, delete, and mark tasks as complete, with completed tasks grouped by date for better organization.

✨ Features

➕ Add new tasks

🖊️ Edit existing tasks

❌ Delete tasks (tap & long-press options)

✅ Mark tasks as complete/incomplete

📂 View Completed Todos in a separate screen

📅 Group completed tasks into Today, Yesterday, and Other Days

💾 Persistent storage using SQLite (sqflite package)

🎨 Modern Material 3 UI with custom theme

📸 Screenshots

(Add your own screenshots here after running the app 🙂)

screenshots/
├── home.png
├── add_task.png
├── completed.png


Example placeholders:




🛠️ Tech Stack

Flutter (Dart)

SQLite (via sqflite)

path (for local database path)

intl (for date formatting)

📂 Project Structure

lib/
├── main.dart # Entry point
├── model/
│ └── todo.dart # Todo model (id, task, isDone, createdOn, updatedOn)
├── screens/
│ ├── todos_screen.dart # Main screen (add, edit, toggle, delete todos)
│ └── completed_todos.dart # Completed todos screen (group by date, delete)
└── services/
└── database_services.dart # SQLite database service (CRUD operations)



---

## 🚀 Getting Started

### Prerequisites
- Install **Flutter**
- A connected device or emulator

### Installation
```bash
# Clone this repository
git clone https://github.com/your-username/todo-app.git

# Navigate to project directory
cd todo-app

# Install dependencies
flutter pub get

# Run the app
flutter run


📦 Dependencies
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.3.0
  path: ^1.8.3
  intl: ^0.18.0
