# GitExplore
An iOS app for exploring the list of trending repositories on day, week and month basis. It also has search repository feature to see search specific repositories.

## Overview
GitExplore - iOS is a native iOS app which communicates with Github API (https://api.github.com) and third party API (https:// hackertab.pupubird.com) for loading Git repositories related details and present those details with a minimal user interface.

## Objective
Objective of GitExplore iOS project is to demonstrate my native iOS engineering practices including,
1. SOLID principal based design and implementation
2. Clean architecture - Dependency injection, loose coupling,
protocols, testability, etc
3. Custom networking framework using advanced concepts like
Generics, Decodable, Protocols, Enums, etc
4. Use of NSOperation API for concurrent API calls
5. View layer creation and design purely with code without the
need of Storyboards or Xibs
6. Unit testing

## Features
It calls third party Rest API (https://hackertab.pupubird.com) for loading list of trending Github repositories with short overview like repository name, author name and star count. Github API doesn’t have its official API for trending repositories therefore this third party API has been used.

User can view the trending repository list based on Day, Weak and Month duration as they select respective tab. If user taps on any of the trending repository in the list, app opens repository details view for showing more details about the selected repository.
Repository details view shows the Github link of the repository, users can tap on that link to open Github project in the default iPhone browser.

The app shows a search bar at the top of the home view which users can use this search bar to search for Github repositories.The search bar shows an inline list view to show the search result, users can tap on any listed repository to see more details about it. 
  
## Technology Stack
The whole app is written with custom code using Apple iOS framework, no third party library like AlamoFire, SnapKit, etc has been used in the project.
Here is the technology stack of the project,
1. Swift 5.0
2. Xcode 12.2
3. Networking with URLSession API
4. JSON
5. XCTest
6. Git

## Unit Testing
Native XCTest framework has been used to write and execute unit tests for core components of the application.
The code coverage percent is low due to the time restriction, however the unit testing approach (mock services, mock data, etc) can be reused to cover rest of the modules with unit tests.
Test run result is 100% and looks like this,
 
## Future Scope
The app has several scope of improvements. Due to limited time, the app is developed as a minimal version.
In future, we could work on adding below listed improvements to the app,
1. Enhanced search feature - The current search feature works well but sometimes, it works slow. It would be great to optimise the search workflow so that search feature works with improved speed.
2. More unit tests - It would be really great to cover all of the view models, data services, views with unit tests. At present, only a few core modules are covered with unit tests.
3. UI/UX design update - The app UI is very basic which definitely needs enhancements in terms of colour scheme, custom fonts, icons, effects/filters and animation. It would be great to work on it in future.
4. Add UI tests - UI tests would help in automating functional testing, therefore we could think of adding it to the project in future.

## References
Github API - https://api.github.com
Pupubird API - https://hackertab.pupubird.com
