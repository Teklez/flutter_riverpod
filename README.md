# BetEbet - Mobile Application
BetEbet is a mobile application designed to provide users with a platform to explore various betting games. Whether you're interested in sports betting, casino games, or other forms of gambling entertainment, BetEbet offers a convenient way to see what people say about the games.

# Features

## Authentication
Users can create accounts and securely log in to the app.
Authentication ensures that only registered users can access the app's features.
## Authorization
Different roles (user, admin) have distinct access levels to features and data.
Users can review and rate games, while admins have additional privileges for game management.
User Registration
New users can easily register by providing essential information such as username, email, and password.
The registration process ensures the integrity and security of user data.
# Role Assignment
Upon registration, users are assigned a default role (user).
Admins have the ability to assign roles to users, granting additional permissions as needed.
# Game Review and Rating
Create: Users can write reviews and rate games.
Read: Users can view game details, including reviews and ratings from other users.
Update: Users can edit or update their reviews and ratings.
Delete: Users can delete their reviews if they wish to remove them from the app.
## Game Management
Create: Admins can add new games to the app's database, providing details such as title and description.
Read: Admins and users can browse the list of available games, viewing their details and reviews.
Update: Admins can edit existing game details, such as title or description.
Delete: Admins can remove games.

## State Management with Riverpod
To efficiently manage the state of the application, BetEbet utilizes Riverpod, a state management library for Flutter. Riverpod offers a more robust and flexible way to handle state compared to traditional methods like Bloc. Here’s an overview of how Riverpod is integrated into BetEbet:

## Benefits of Using Riverpod
Simplified State Management: Riverpod simplifies the process of managing state in a Flutter application, making it easier to read and maintain.
Improved Performance: With Riverpod, state is only rebuilt when necessary, improving the performance of the app.
Increased Flexibility: Riverpod provides more flexibility for handling complex state management scenarios.
Implementation
Providers: Riverpod uses providers to manage the state. Different types of providers (e.g., Provider, StateProvider, FutureProvider, StreamProvider) are used based on the requirements.
Scoped State: State can be scoped to different parts of the widget tree, ensuring that only the necessary parts of the UI are rebuilt.
Dependency Injection: Riverpod makes it easy to manage dependencies and inject them where needed.

# Contributors
Name	ID No.
1	Biruk Maru Asnakew	UGR/4775/13
2	Nardos Amakele Demissie	UGR/6957/14
3	Zemenu Mekuria Embiale	UGR/5017/14
