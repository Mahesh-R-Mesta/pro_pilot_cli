# 🚀 Pro Pilot – AI-Powered Project Scaffolding CLI  

**Pro Pilot** is a command-line tool that helps developers quickly set up **Flutter** and **React** projects with boilerplate code using AI.  

## 📌 Features  
✅ Generate a fully structured **Flutter** project.  
✅ Set up a **React** project with best practices.  
✅ Create **boilerplate code** in the specified folder inside a project.  
✅ AI-powered scaffolding for a clean and efficient setup.  

## 📦 Installation  
1. Clone this repository:

   ```sh
   git clone https://github.com/Mahesh-R-Mesta/pro_pilot.git
   cd pro_pilot

2. Build the CLI tool (make sure you have dart installed)
   ```sh
     dart compile exe bin/pro_pilot.dart -o pro_pilot # For Linux
     dart compile exe bin/pro_pilot.dart # For Windows
   ```
   
3. Move the executable to a directory in your system’s
   ```sh
   mv pro_pilot /usr/local/bin  # For Linux/macOS
   move pro_pilot.exe C:\Windows\System32  # For Windows (or set environment path)
   ```

## Usage 
   1. Generate a Flutter project
   ```sh
   .\pro_pilot project flutter
   ```
  2. Generate a React project
   ```sh
   .\pro_pilot project react
   ```
  3. Generating boilerplate code for existing project
   ```sh
   .\pro_pilot append
   ```

## 🛠️ Requirements
Dart SDK installed<br/>
Node.js & npm (for React projects)<br/>
Flutter SDK (for Flutter projects)<br/>

## Demo
![demo image](https://github.com/Mahesh-R-Mesta/pro_pilot_cli/blob/master/workdemo.gif)
