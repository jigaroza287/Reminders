# ToDoApp

A SwiftUI-based To-Do List application with Core Data for persistent task management.

![To-DoListApp](https://github.com/user-attachments/assets/a69a0340-1b27-4da5-a6c6-c391f921b9b0)
![To-DoListApp-Search](https://github.com/user-attachments/assets/e6c6f1ad-397f-4112-afb9-adaee9eb9902)
![To-DoListApp-Reminder](https://github.com/user-attachments/assets/b4bc723f-04ac-49e4-860e-a9cc8c95aa14)


## Features

- Add, delete, and update tasks with optional notes and priorities.
- Search tasks with real-time updates using Combine and debouncing.
- Task priority management with visual indicators for high, medium, and low priorities.
- Persistent data storage using Core Data.
- Preview and mock data for development and testing.
- Animated task completion toggle.
- Unit tests for viewModels

## Tech Stack

- **Language**: Swift
- **Frameworks**: SwiftUI, Combine, Core Data
- **Architecture**: MVVM (Model-View-ViewModel)
- **Storage**: Core Data with NSPersistentContainer

---

## Code Organization

### Key Components

1. **`PersistenceController.swift`**
   - Manages Core Data setup, including in-memory stores for previewing.
   - Automatically merges changes to the main context.

2. **`TaskModel.swift`**
   - Core Data entity extension for the `Task` model.
   - Defines `TaskPriority` enumeration for task priorities.

3. **`TaskViewModel.swift`**
   - ObservableObject that manages fetching, searching, and modifying tasks.
   - Integrates Combine for debounced search functionality.
   - Provides methods for CRUD operations on tasks.

4. **`TaskListView.swift`**
   - Main SwiftUI view for listing, searching, and adding tasks.
   - Includes a picker for selecting task priority.

5. **`TaskRowView.swift`**
   - Subview for individual task rows.
   - Displays task details with priority indicators and completion toggles.

6. **`NewTaskView.swift`**
   - Subview for task list.
   - Allows adding new task by adding Task name, Notes and Priority.

7. **`TaskSearchView.swift`**
   - Subview for task list.
   - Displays Search bar to filter tasks by task name.

---

## Installation and Setup

1. Clone the repository:
   
   ```
   git clone https://github.com/jigaroza287/ToDoApp.git
   cd ToDoApp
   ```

2. Open `ToDoApp.xcodeproj` in Xcode.

3. Run the app on a simulator or device.

---

## Usage

1. **PersistenceController.swift:**
    - Enter a task title and optional note.
    - Select a priority (Low, Medium, High).
    - Tap the "+" button to save the task.
2. **Search Tasks:**
    - Use the search bar to filter tasks by title.
    - Clear the search by tapping the "X" icon.
3. **Mark Task as Complete/Incomplete:**
    - Tap the checkmark icon to toggle task completion.
4. **Delete Tasks:**
    - Swipe left on a task row to delete it.

---

## Optimization Highlights

- **Debounced Search:** Uses Combine to debounce search queries with .removeDuplicates().
- **Efficient Data Loading:** Core Data fetch requests are optimized using predicates.
- **Preview Data:** In-memory Core Data store supports testing and SwiftUI previews.
- **Priority Labels:** Task priorities visually differentiated for better task management.

---

## Development Notes

- **Core Data:**

  - Core Data operations (e.g., fetch, add, delete) are encapsulated in `TaskViewModel`.
  - Persistent container is shared across the app for consistency.

- **Combine:**

  - @Published properties like searchQuery trigger UI updates.
  - Debouncing ensures efficient search handling.

- **SwiftUI Previews:**

  - PersistenceController.preview provides mock data for seamless previewing.

---

## License
This project is licensed under the MIT License.
