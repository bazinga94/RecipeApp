# Recipe

Build a **Recipe** app using SwiftUI + Concurrency.

## Summary

This iOS app displays a list of recipes with detailed information.  
Recipes are grouped by category (cuisine) and sorted alphabetically, with a search feature.  
Users can refresh the list via pull-to-refresh, and images are cached in both memory and disk for improved performance.  

### Requirements

- iOS 16.0+

### Screenshots

> <img src="https://github.com/user-attachments/assets/aa094716-b060-4cfa-88d2-26320d60fb90" width="250"/>
> <img src="https://github.com/user-attachments/assets/554c2c9a-420f-4105-ad45-4f931a9df458" width="250"/>
> <img src="https://github.com/user-attachments/assets/b5c36f5b-ff9d-4772-9286-ca7f88ff543f" width="250"/>
> <img src="https://github.com/user-attachments/assets/e67e0c9d-17d8-42fe-b827-3141ff4dc5cc" width="250"/>
> <img src="https://github.com/user-attachments/assets/82239ba6-66b0-4a35-950f-23ac55108c02" width="250"/>
> <img src="https://github.com/user-attachments/assets/3b5058f7-125f-4154-a4f0-c706c7001915" width="250"/>

## Focus Areas

I focused on writing maintainable and testable code using a modern SwiftUI + Swift Concurrency approach. And implementing stable and efficient caching logic.

- Declarative UI design using SwiftUI
- Clean separation of concerns using View - ViewModel - Repository - Data Source layers
- Asynchronous programming with async/await
- Efficient use of concurrency and threading
- Custom image caching implementation (without third-party libraries)
- Dependency injection for maintainability and testability
- High test coverage
- Not bad UI and design...

## Time Spent

I spent approximately 20 hours on the project during 5 days.

- **UI**: 30%
- **Networking, caching, business logic**: 50%
- **Testing and refactoring**: 20%

Time was also spent researching SwiftUI, Concurrency, and caching logic design.

## Trade-offs and Decisions

- **Download Management**: Features like download cancellation (e.g., handling duplicate requests or canceling ongoing downloads) were not implemented. These would be important for improving stability and performance in a more complex app.
- **LRU(LFU) Caching**: LRU(LFU) caching would be a good option for better cache management, but it was a bit too complicated for this project. Instead, I used the file creation date as metadata to manage cache expiration.
- **Design system**: If there were a defined design system, I would have set up shared styles and components like fonts, colors, and common views. For this project,  I kept things simple and handled them inline.
- **Error handling**: Just used `print` for error cases. In a production setting, I would log, handle, and categorize errors properly.
- **Detail view**: Current version only shows Site and YouTube link. With more time, I could embed the video or show full recipe information for better usability.

Initially considered but not implemented
- **Pagination and prefetching**: Due to the small dataset and endpoints don't support pagination.
- **Search optimization**: Did not use debouncing (Combine) since we do not call api during search.

## Weakest Part of the Project

- The image caching could be improved:
  - Memory cache is a singleton pattern. Simple but it may not be the optimal solution.
  - No cancellation or reuse of previous network requests.
- Reusable color, font, and view components
- Error handling could be more user-friendly.
- The search feature could be enhanced (e.g., history).

## Additional Information

- Although not mentioned in the requirements, I implemented a custom **memory caching** to improve image performance.
- In addition, I added a simple **expiration logic** for the disk cache to make sure outdated files don’t stay in the cache over time.
- It was a valuable experience to build an image cache from scratch and verify its effectiveness using Xcode tools like Instruments and Debug Navigator.
- I really enjoyed working. It was a fun challenge and a great opportunity to learn more about SwiftUI, Architecture, and Caching.
