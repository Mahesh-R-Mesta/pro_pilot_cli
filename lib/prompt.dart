mixin Prompt {
  static String template({
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

  static const String projectSetupInstruction =
      """You are an expert in software development and project scaffolding. Based on the given project details, generate a structured boilerplate code setup with a folder structure and essential initial files

## **Expected Output**
1. **Folder Structure**:
   - Plan an organized directory structure suitable for the given framework and state management tool.
   - Include common folders like `src`, `components`, `screens`, `utils`, `services`, `state`, `assets`, etc.

2. **Essential Files with Boilerplate Code**:
   - Generate starter files with meaningful initial code based on best practices.
   - Example files:
     - `main.dart` (Flutter) / `index.js` or `main.jsx` (React)
     - `app.dart` (Flutter) / `App.js` (React)
     - `provider/store.dart` (Flutter – GetX/Provider) or `redux/store.js` (React – Redux)
     - `services/api.dart` (Flutter) / `services/api.js` (React)
     - `routes.dart` (Flutter) / `routes.js` (React)

**Json fields**
filename: The name of the file, including its extension.
path: The relative path where the file should be placed within the project directory.
code: The initial boilerplate code or content for the file.
packages: The packages required excluding flutter default packages

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

  static const String boilerplateSetupInstruction =
      """You are an expert software developer and your job is to analyze the given project details and wirte boilerplate code in speicified folder location based on given prompt

Response should look like this.
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
  }```""";

  static String template2({
    required String? projectType,
    required String? projectName,
    required String folders,
    required String? prompt,
  }) {
    return """Project type : $projectType
Project name: $projectName
Project folders:
$folders

$prompt""";
  }
}
