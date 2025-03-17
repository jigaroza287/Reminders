# Reminders

A SwiftUI-based Reminders application with Core Data for persistent reminders management.

![RemindersApp](https://github.com/user-attachments/assets/d5f96b5a-9d75-4604-9b2a-b28ec03f3bb7)

## Features

- Add, delete, and update reminders with optional notes and priorities.
- Search reminders with real-time updates using Combine and debouncing.
- Reminder priority management with visual indicators for high, medium, and low priorities.
- Persistent data storage using Core Data.
- Preview and mock data for development and testing.
- Animated reminder completion toggle.
- Unit tests for viewModels

## Tech Stack

- **Language**: Swift
- **Frameworks**: SwiftUI, Combine, Core Data
- **Architecture**: MVVM (Model-View-ViewModel)
- **Storage**: Core Data with NSPersistentContainer
- **Authentication**: Biometric authentication using LocalAuthentication framework
- **Notification**: Local notification for reminders using UserNotifications framework

---

## Code Organization

### Key Components

1. **`PersistenceController.swift`**
   - Manages Core Data setup, including in-memory stores for previewing.
   - Automatically merges changes to the main context.

2. **`ReminderModel.swift`**
   - Core Data entity extension for the `Reminder` model.
   - Defines `ReminderPriority` enumeration for reminder priorities.

3. **`ReminderViewModel.swift`**
   - ObservableObject that manages fetching, searching, and modifying reminders.
   - Integrates Combine for debounced search functionality.
   - Provides methods for CRUD operations on reminders.

4. **`ReminderListView.swift`**
   - Main SwiftUI view for listing, searching, and adding reminders.
   - Includes a picker for selecting reminder priority.

5. **`ReminderRowView.swift`**
   - Subview for individual reminder rows.
   - Displays reminder details with priority indicators and completion toggles.

6. **`NewReminderView.swift`**
   - Subview for reminder list.
   - Allows adding new reminder by adding Reminder name, Notes and Priority.

7. **`ReminderSearchView.swift`**
   - Subview for reminder list.
   - Displays Search bar to filter reminders by reminder name.

8. **`BiometricAuthManager.swift`**
   - Handles biometric authentication for security.
   - Asks user to authenticate with default biometric authentication set in device, i.e. Passcode or FaceId.

9. **`NotificationManager.swift`**
   - Responsible to set and remove local notifications based on Due date selected for a reminder.

---

## Installation and Setup

1. Clone the repository:
   
   ```
   git clone https://github.com/jigaroza287/Reminders.git
   cd Reminders
   ```

2. Open `Reminders.xcodeproj` in Xcode.

3. Run the app on a simulator or device.

---

## Usage

1. **PersistenceController.swift:**
    - Enter a reminder title and optional note.
    - Select a priority (Low, Medium, High).
    - Tap the "+" button to save the reminder.
2. **Search Reminders:**
    - Use the search bar to filter reminders by title.
    - Clear the search by tapping the "X" icon.
3. **Mark Reminder as Complete/Incomplete:**
    - Tap the checkmark icon to toggle reminder completion.
4. **Delete Reminders:**
    - Swipe left on a reminder row to delete it.

---

## Optimization Highlights

- **Authentication:** Uses LocalAuthentication framework to add an extra security layer for biometric authentication.
- **Debounced Search:** Uses Combine to debounce search queries with .removeDuplicates().
- **Efficient Data Loading:** Core Data fetch requests are optimized using predicates.
- **Preview Data:** In-memory Core Data store supports testing and SwiftUI previews.
- **Priority Labels:** Reminder priorities visually differentiated for better reminder management.

---

## Development Notes

- **Core Data:**

  - Core Data operations (e.g., fetch, add, delete) are encapsulated in `ReminderViewModel`.
  - Persistent container is shared across the app for consistency.

- **Combine:**

  - @Published properties like searchQuery trigger UI updates.
  - Debouncing ensures efficient search handling.

- **SwiftUI Previews:**

  - PersistenceController.preview provides mock data for seamless previewing.

---

## License
This project is licensed under the MIT License.
