mixin Prompt {
  static String createTemplate({
    required String project,
    required String projectName,
    required String stateManagement,
    required String description,
  }) =>
      """Create a $project project named $projectName with the description $description using $stateManagement for state management.

Follow best practices, structuring lib/ with:
core/ (utilities, theme, config)
data/ (models, repositories)
presentation/ (UI screens, widgets)
state/ (state management setup)
helpers/ (common utility functions)

Return a valid JSON with containing:
{
  "files":[{
  "path": File path inside lib/.
  "filename": File name.
  "code": Sample implementation.
  }],
  "packages":[list of packages]
}

Ensure the JSON is well-formatted and ensure returning only json response""";

  static const example = {
    "files": [
      {
        "path": "lib/core/theme/app_theme.dart",
        "package": "package",
        "code":
            "import 'package:flutter/material.dart';\n\nThemeData appTheme() {\n  return ThemeData(\n    primarySwatch: Colors.blue,\n    scaffoldBackgroundColor: Colors.grey[100],\n  );\n}"
      }
    ]
  };

//   static String template2({
//     required String project,
//     required String projectName,
//     required String stateManagement,
//     required String description,
//   }) =>
//       """Given the following project details:

// - **Project Type**: $project
// - **Project Name**: $projectName
// - **Project Description**: $description
// - **State management**: $stateManagement

// Generate a JSON response that outlines the project structure, including:

// 1. **A list of files** with their **paths, filenames, and initial sample implementation**.
// 2. **A structured folder hierarchy** including essential directories (e.g. ${project == 'flutter' ? 'widgets' : 'components'},helpers, utils, services, presentation).
// 3. **Helper classes** for common functionality such as API calls, local storage, state management and utilities.
// 4. **A list of required packages** based on the project type.

// Follow best practices, structuring lib/ with:
// core/ (utilities, theme, config)
// data/ (models, repositories)
// presentation/ (UI screens, widgets)
// state/ (state management setup)
// helpers/ (common utility functions)

// The JSON response should strictly follow this format:
// ```json
// {
//   "files": [
//     {
//       "path": "relative\path\to\file",
//       "filename": "\filename.ext",
//       "code": "initial sample implementation"
//     }
//   ],
//   "packages": [
//     "package1",
//     "package2"
//   ]
// }  """;

  static String template3({
    required String project,
    required String projectName,
    required String stateManagement,
    required String description,
  }) =>
      """
- Project Type: $project 
- Project Name: $projectName  
- Project Description: $description
- State management used: $stateManagement
  """;

  static String systemInstruction = """You are a expert flutter developer, and your main job is to create proper folder strucure with boilerplate 
 code for the project based on give information
response should look like this.
```json
{  
  "files": [  
    {  
      "path": "relative\path\to\file",  
      "filename": "\filename.ext",
      "code": "initial sample implementation"  
    }  
  ],  
  "packages": [  
    "package1",  
    "package2"
  ]  
}```
""";

//       """You are an expert in software development and project scaffolding. Based on the given project details, generate a structured boilerplate code setup with a folder structure and essential initial files

// ## **Expected Output**
// 1. **Folder Structure**:
//    - Plan an organized directory structure suitable for the given framework and state management tool.
//    - Include common folders like `src`, `components`, `screens`, `utils`, `services`, `state`, `assets`, etc.

// 2. **Essential Files with Boilerplate Code**:
//    - Generate starter files with meaningful initial code based on best practices.
//    - Example files:
//      - `main.dart` (Flutter) / `index.js` or `main.jsx` (React)
//      - `app.dart` (Flutter) / `App.js` (React)
//      - `provider/store.dart` (Flutter – GetX/Provider) or `redux/store.js` (React – Redux)
//      - `services/api.dart` (Flutter) / `services/api.js` (React)
//      - `routes.dart` (Flutter) / `routes.js` (React)

// **Json fields**
// filename: The name of the file, including its extension.
// path: The relative path where the file should be placed within the project directory.
// code: The initial boilerplate code or content for the file.
// packages: The packages required excluding flutter default packages

// response should look like this.
// ```json
// {
//   "files": [
//     {
//       "path": "relative\path\to\file",
//       "filename": "\filename.ext",
//       "code": "initial sample implementation"
//     }
//   ],
//   "packages": [
//     "package1",
//     "package2"
//   ]
// }```
// """;
}
