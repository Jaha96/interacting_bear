# Talking Bear Flutter App

Welcome to the Talking Bear Flutter app! This project aims to recreate the delightful experience of the talking Tom game from our childhood using the latest technologies available to us. The app utilizes [Rive](https://rive.app/) for animations, Riverpod for state management, [Google Cloud Text-to-Speech AI](https://cloud.google.com/text-to-speech) for text-to-speech and device's built in speech-to-text functionalities, and [Chat GPT API](https://platform.openai.com/docs/api-reference/chat) for generating interesting and random responses. The primary goal is to create an interactive and cute application that listens, interacts, and generates exciting results for kids.

## Demo
https://github.com/Jaha96/interacting_bear/assets/18748558/47503d50-ed7e-4050-99f8-1fc9bee3d3e0

## Story

As a kid, I enjoyed playing the talking Tom game, which was cute and interactive. Now, inspired by this idea, I wanted to build a similar app using the most up-to-date technologies. Initially, I considered developing a 3D game using Unity. My chosen stack included Unity for the mobile app, Blender for creating character animations, and Mixamo for finding characters and animations. However, I soon realized that this combination was challenging for first-time users.

In my search for a more accessible solution, I consulted with my UI/UX designer friends, and they introduced me to the Rive platform. Upon discovering Rive, I fell in love with its capabilities. It is lightweight, efficient, and has a thriving community with numerous animations and characters. You might have noticed Rive being used in popular apps like Duolingo and Figma.

Ultimately, I decided to switch my stack to Rive for animations and Flutter for the application development. Additionally, I integrated Google Cloud for text-to-speech, used device's built in speech-to-text functionality to enhance the user experience. To add an extra layer of fun and excitement, I used [Chat GPT API](https://platform.openai.com/docs/api-reference/chat) to generate interesting and random responses, making the interactions with the cute polar bear character even more engaging for kids.

## Requirements
- Flutter 3.10.4
- Dart 3.0.3
- [Google Cloud API key](https://support.google.com/googleapi/answer/6158862)
- [OpenAI API key](https://help.openai.com/en/articles/4936850-where-do-i-find-my-secret-api-key)

## Getting Started

To run the project, follow these steps:

1. Clone the repository to your local machine.
2. Ensure you have Flutter installed. If not, you can download it from the official Flutter website.
3. Navigate to the project directory in your terminal.
4. Run `flutter pub get` to install the required dependencies.
5. Replace `.env.example` filename into `.env` and update your OpenAI API, Google Cloud API credentials 
6. To generate Riverpod, .ENV codes, run `dart run build_runner watch -d`.

To generate launcher icons
```flutter pub run flutter_launcher_icons```


## Features

- Cute and interactive polar bear character with various animations like hearing, waving, and talking.
- Real-time text to speech using [Google Cloud Text-to-Speech AI](https://cloud.google.com/text-to-speech) for accurate and seamless user interactions.
- [Rive](https://rive.app/) animations for smooth and resource-efficient character movements.
- Riverpod state management to ensure a clean and organized codebase.
- [Chat GPT API](https://platform.openai.com/docs/api-reference/chat) for generating interesting and random responses, adding an element of surprise for kids.

## Demo

Showcase some use cases and interactions of the application, highlighting the engaging and unpredictable responses from the polar bear character.
- [Rive animation](https://rive.app/community/5628-11215-wave-hear-and-talk) used in this project.
- App demo usage: Coming soon....

## Language Support

The app supports both English and Japanese languages. However, for the purpose of this summit project, we will focus on the English language first.

## Contribution

Contributions to this project are welcome! Feel free to create pull requests or open issues for bug fixes, feature requests, or any other improvements.

## License

This project is licensed under the [MIT License](LICENSE).

---

Thank you for your interest in the Talking Bear Flutter app! We hope you enjoy exploring the code and interacting with our cute polar bear character. If you have any questions or feedback, please don't hesitate to reach out to us. Happy coding!
