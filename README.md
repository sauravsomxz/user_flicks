# User Flicks

User Flicks is an app that dislays the list of users on Home Screen and as the user list of movies when tapped and a movie detail screen when further explored. This app was made as a part of my assignment.

## Run Locally

Clone the project

```bash
  git clone https://github.com/sauravsomxz/user_flicks
```

Go to the project directory

```bash
  cd user_flicks
```

Install dependencies & generate .g.dart files

```bash
  flutter pub get
  flutter pub run build_runner build
```

Start the server

```bash
  flutter run --dart-define=env=dev for development
  flutter run --dart-define=env=prod for production

  Defaulting to dev environment
```

## Environment Variables

To run this project, you will need to edit the following environment variables to your .env file:
`.env.dev` for Development & `.env.prod` for Production

```
USERS_BASE_URL=https://reqres.in/api
USERS_API_KEY=reqres-free-v1 [Only for free requests]
MOVIES_BASE_URL=https://api.themoviedb.org/3/
MOVIES_IMAGES_BASE_URL=https://image.tmdb.org/t/p/w185
THE_MOVIES_DB_API_KEY=your_the_movies_db_api_key
```

## 🛠️ Tech Stack

| Package                | What it's used for                                                            |
| ---------------------- | ----------------------------------------------------------------------------- |
| `http`                 | To make network/API calls easily                                              |
| `flutter_dotenv`       | To manage different environments like dev and prod with separate config files |
| `provider`             | For managing app-wide state in a clean way                                    |
| `cached_network_image` | To load and cache images efficiently                                          |
| `go_router`            | To handle navigation and routing between screens                              |
| `intl`                 | To format and parse dates and numbers                                         |
| `url_launcher`         | To open external links like websites or emails from the app                   |
| `hive`                 | A super-fast local database to store data offline                             |
| `hive_flutter`         | Makes it easy to use Hive with Flutter apps                                   |
| `connectivity_plus`    | To check if the internet is available or not                                  |
| `workmanager`          | To schedule background tasks that run even when the app is closed             |

### 🧪 Dev Dependencies

| Package          | What it's used for                                         |
| ---------------- | ---------------------------------------------------------- |
| `hive_generator` | Generates boilerplate code for Hive to save custom models  |
| `build_runner`   | Runs the code generator like Hive or JSON model generators |

## 📚 What I Learned

What did you learn while building this project? What challenges did you face and how did you overcome them?

While building this project, I explored and implemented several best practices and concepts that strengthened my understanding of Flutter development.

- 🔄 **Clean API Handling**:  
  I learned how to structure network calls in a modular and scalable way. By separating services, repositories, and view models, I was able to keep the code clean, testable, and easy to maintain.

- ⏰ **Using WorkManager for Background Tasks**:  
  Integrating `workmanager` helped me understand how to schedule tasks that can run in the background, like syncing data or checking connectivity—even when the app is closed.

- 💾 **Generic Local Storage with Hive**:  
  I created a reusable, generic class for handling local storage using Hive. This made saving and retrieving data much simpler and more consistent throughout the app. Understanding how Hive works under the hood, especially with adapters and type casting, was a valuable takeaway.

These learnings have improved the way I think about state, background execution, and data persistence in mobile apps.

## 🔌 APIs Used Across the App

```env
USERS_BASE_URL=https://reqres.in/api
USERS_API_KEY=reqres-free-v1 [Only for free API calls]

MOVIES_BASE_URL=https://api.themoviedb.org/3/
MOVIES_IMAGES_BASE_URL=https://image.tmdb.org/t/p/w185
THE_MOVIES_DB_API_KEY=<your_tmdb_api_key_here>
```

### 🔐 API Notes

- All API keys are passed through request headers for added security and cleaner code.
- The MoviesDB API doesn't work on JIO Fibre or JIO Mobile Data Network, it works perfect on Airtel Fibre or Airtel Hotspot & sometimes on BSNL networks as well.
- For **The Movie DB** APIs, you must include the following header:

```http
"accept": "application/json",
```

- For **POST requests to the Users API**, you must include the following header:

```http
Content-Type: application/json
```

- Pagination is supported for both users and movies endpoints (default page is `1`).

```http
GET /users?page=1
GET /trending/movie/day?language=en-US&page=1
```

## Directory Structure

```
├── lib
│   ├── app.dart
│   ├── core
│   │   ├── app_enums.dart
│   │   ├── app_routes.dart
│   │   ├── config
│   │   │   └── app_config.dart
│   │   ├── helpers
│   │   │   └── app_helpers.dart
│   │   ├── network
│   │   │   ├── api_client.dart
│   │   │   ├── network_exceptions.dart
│   │   │   └── network_response.dart
│   │   └── theme
│   │       ├── app_theme.dart
│   │       └── colors.dart
│   ├── external
│   │   ├── cached_image.dart
│   │   ├── connectivity_service.dart
│   │   ├── local_user_storage_service.dart
│   │   └── url_launcher.dart
│   ├── features
│   │   ├── add_user
│   │   │   ├── model
│   │   │   │   ├── add_user_data_hive_data_model.dart
│   │   │   │   ├── add_user_data_hive_data_model.g.dart
│   │   │   │   ├── add_user_request_data_model.dart
│   │   │   │   └── add_user_response.dart
│   │   │   ├── repository
│   │   │   │   └── add_user_repository.dart
│   │   │   ├── view
│   │   │   │   └── add_user_view.dart
│   │   │   └── view_model
│   │   │       └── add_user_view_model.dart
│   │   ├── home
│   │   │   ├── model
│   │   │   │   ├── user_data_model.dart
│   │   │   │   └── user_response.dart
│   │   │   ├── repository
│   │   │   │   └── home_repository.dart
│   │   │   ├── view
│   │   │   │   └── home_view.dart
│   │   │   └── view_model
│   │   │       └── home_view_model.dart
│   │   ├── movie_details_screen
│   │   │   ├── model
│   │   │   │   └── movie_details_data_model.dart
│   │   │   ├── repository
│   │   │   │   └── movie_details_repository.dart
│   │   │   ├── view
│   │   │   │   └── movie_details_view.dart
│   │   │   ├── view_model
│   │   │   │   └── movie_details_vm.dart
│   │   │   └── widgets
│   │   │       ├── details_row.dart
│   │   │       ├── movie_detail_header.dart
│   │   │       ├── movie_detail_info_row.dart
│   │   │       └── section_title.dart
│   │   └── movies
│   │       ├── model
│   │       │   └── list_of_movies_data_model.dart
│   │       ├── repository
│   │       │   └── list_of_movies_repository.dart
│   │       ├── view
│   │       │   └── movie_screen.dart
│   │       ├── view_model
│   │       │   └── list_of_movies_vm.dart
│   │       └── widgets
│   │           └── movie_card.dart
│   ├── main.dart
│   └── widgets
│       ├── custom_bottomsheet.dart
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       └── edge_state.dart
```

## Authors

- [@Sourav Maharana - LinkedIn](http://linkedin.com/in/sourav-ranjan-maharana/)
