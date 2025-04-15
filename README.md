# Recipe
Build a **Recipe** app using SwiftUI + Concurrency.

## Summary

This iOS app displays a list of recipes with detailed information.  
Recipes are grouped by category (cuisine) and sorted alphabetically, with a search feature for easy filtering.  
Users can refresh the list via pull-to-refresh, and images are cached in both memory and disk for improved performance.  

### Screenshots

> Add here

---

## Focus Areas

I focused on writing maintainable and testable code using a modern SwiftUI + Swift Concurrency approach. And implementing stable and efficient caching logic.

- Declarative UI design with SwiftUI
- Clean separation of concerns using View - ViewModel - Repository - Data Source layers
- Asynchronous programming with async/await
- Custom image caching implementation (without third-party libraries)
- Dependency injection for maintainability and testability

---

## Time Spent

I spent approximately 20 hours on the project during 4 days.

- **UI**: 30%
- **Networking, caching, business logic**: 50%
- **Testing and refactoring**: 20%

Time was also spent researching SwiftUI, and design caching logic from scratch.

---

## Trade-offs and Decisions

- **Error handling**: Just used `print` for error cases. In a production setting, I would log and categorize errors properly.
- **Detail view**: Current version only shows Site and YouTube link. With more time, I could embed the video or show full recipe information.
- **Caching**: Features like expiration (removing outdated files from disk) and download cancellation (handling duplicate requests or canceling ongoing downloads) were not included. These would be important to add for better stability and scalability in a more complex production app.

Initially considered but not implemented
- **Pagination and prefetching**: Considered but not implemented due to the small dataset and endpoints don't support pagination.
- **Search optimization**: Did not use debouncing (Combine) since we do not call api during search.

---

## Weakest Part of the Project

- The image caching could be improved:
  - Memory cache is a singleton pattern. Simple but it may not be the optimal solution.
  - No expiration policy for disk cache.
  - No cancellation or reuse of previous network requests.
- Error handling could be more user-friendly.
- Error could be logged.
- The search feature could be enhanced (e.g., history).

---

## Additional Information

Although not mentioned in the requirements, I implemented a custom memory caching to improve image performance.

It was a valuable experience to build an image cache from scratch and verify its effectiveness using Xcode tools like Instruments and Debug Navigator.

This project helped me enhance best practices around testable architecture, SwiftUI design, and better performance.