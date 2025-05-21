# 🛡️ Cyber Buddy

**Cyber Buddy** is a generative AI-powered cybersecurity assistant desktop application designed to help users explore, understand, and manage cybersecurity tools and practices. With an intuitive Flutter-based UI and AI-driven backend, it empowers users to stay informed and secure in the digital world.

## 🚀 Features

* 💬 **AI Chat Assistant**: Get answers to cybersecurity-related queries like firewalls, phishing, encryption, and more.
* 📜 **Script Generator**: Generate useful scripts for automation, firewall setup, scanning, and more.
* 🔍 **Tool Recommender**: Discover top tools for penetration testing, network security, malware analysis, and system hardening.
* 📘 **Cybersecurity Knowledge Base**: Learn from an in-app collection of cybersecurity principles and standards.
* 🎯 **Skill Building**: Includes daily challenges, learning tips, and tutorials to improve cybersecurity knowledge.
* 💡 **Minimal, Aesthetic Design**: Built with Flutter to provide a clean and smooth desktop experience.

## 🏗️ Tech Stack

* **Frontend**: [Flutter](https://flutter.dev/) (Desktop)
* **Backend**: Python 3, integrated with a generative AI model (e.g., OpenAI API or local LLM)
* **State Management**: Provider / Riverpod / BLoC (as used)
* **Communication**: REST API or Platform Channels (for Python-Flutter interaction)
* **Storage**: SQLite / Shared Preferences / Local Filesystem

## 📦 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/cyber-buddy.git
cd cyber-buddy
```

### 2. Set Up Flutter Desktop

Ensure [Flutter](https://docs.flutter.dev/desktop) is set up for your OS:

```bash
flutter doctor
```

### 3. Install Dependencies

```bash
flutter pub get
```

### 4. Run the App

```bash
flutter run -d windows  # or macos/linux based on your OS
```

### 5. (Optional) Run Backend

Make sure your Python backend is running:

```bash
cd backend
python app.py
```

## 💬 Example Queries

* “Explain how ransomware works.”
* “Generate a PowerShell script to disable USB ports.”
* “Suggest a tool to analyze suspicious network traffic.”
* “What is the difference between symmetric and asymmetric encryption?”

## 📁 Project Structure

```
cyber-buddy/
│
├── lib/                      # Flutter frontend code
│   ├── screens/              # UI Screens
│   ├── services/             # API handlers
│   ├── models/               # Data models
│   └── main.dart             # App entry
├── backend/                  # Python backend with AI logic
│   └── app.py
├── assets/                   # Icons, images
└── README.md
```

## 🛡️ Privacy & Security

Cyber Buddy processes user input securely and does not store sensitive data unless explicitly permitted. API communication is encrypted.

## 🧠 License

MIT License — see `LICENSE` file for details.

## 🤝 Contributing

We welcome all contributions! Feel free to fork, create issues, or submit PRs to enhance Cyber Buddy.

