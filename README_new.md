# 🛡️ Cyber Buddy

**Cyber Buddy** is a comprehensive cybersecurity education platform that combines an intuitive Flutter desktop application with a powerful AI-driven backend. Designed for cybersecurity enthusiasts, students, and professionals, it serves as an intelligent assistant for learning cybersecurity concepts, analyzing logs, and getting expert guidance on security tools and techniques.

## ✨ Key Highlights

- 🤖 **AI-Powered Learning**: Groq API with Llama 3.3 70B for expert cybersecurity guidance
- 🖥️ **Cross-Platform Desktop**: Native Flutter app for Windows, macOS, and Linux
- 📊 **Log Analysis**: Automated security log parsing and threat detection
- 🎨 **Modern UI**: Cyberpunk-themed interface with animated particles
- 🔧 **Production Ready**: Docker containerization and comprehensive API documentation

## 🚀 Features

### 💬 **AI-Powered Cybersecurity Assistant**
- Intelligent chat interface with specialized cybersecurity knowledge
- Powered by LangChain and Groq API (Llama 3.3 70B) for accurate, contextual responses
- Beginner-friendly explanations with advanced technical details
- Real-world examples, CLI commands, and configuration snippets
- Multi-tab chat interface for organizing different conversations

### 📊 **Log Analysis & Monitoring**
- Upload and analyze security logs automatically
- Pattern recognition for unauthorized access attempts
- Error detection and system issue identification
- Comprehensive logging system with detailed audit trails

### 📚 **Cybersecurity Knowledge Base**
- Built-in information on key cybersecurity topics
- Topics include firewalls, encryption, phishing, network scanning tools (Nmap)
- Quick access to predefined topic information
- Structured learning resources and best practices

### 🔧 **Modern Desktop Experience**
- Native Flutter desktop application for Windows, macOS, and Linux
- Custom window management with hidden title bar
- Responsive design with animated particles and smooth transitions
- Dark cyberpunk-themed UI optimized for cybersecurity professionals
- Sidebar navigation with multiple screens

### 🌐 **RESTful API Backend**
- FastAPI-based backend with comprehensive API documentation
- Structured endpoints for chat, information retrieval, and log analysis
- CORS-enabled for cross-platform compatibility
- Session management and security middleware
- Auto-generated OpenAPI/Swagger documentation

## 🏗️ Tech Stack

### **Frontend**
* **Framework**: [Flutter](https://flutter.dev/) 3.7.2+ (Multi-platform Desktop)
* **State Management**: Provider pattern
* **Window Management**: window_manager, bitsdojo_window
* **HTTP Client**: Built-in HTTP package for API communication
* **Local Storage**: SharedPreferences for user settings
* **Routing**: GoRouter for navigation
* **UI Libraries**: Lucide Icons, Cupertino Icons
* **File System**: path_provider for file access

### **Backend**
* **Framework**: [FastAPI](https://fastapi.tiangolo.com/) with Python 3.9+
* **AI Integration**: 
  - [LangChain](https://langchain.com/) for AI orchestration
  - [Groq API](https://groq.com/) with Llama 3.3 70B model
* **API Documentation**: Auto-generated OpenAPI/Swagger docs
* **Middleware**: CORS, Session management
* **Logging**: Comprehensive audit logging with rotation
* **Data Validation**: Pydantic models for request/response validation

### **DevOps & Deployment**
* **Containerization**: Docker with Docker Compose
* **Environment**: Environment variable configuration
* **Dependencies**: Automated dependency management
* **Server**: Uvicorn ASGI server for production deployment

## 📦 Installation & Setup

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) 3.7.2 or higher
- [Python](https://www.python.org/downloads/) 3.9 or higher
- [Docker](https://www.docker.com/get-started) (optional, for containerized deployment)

### 1. Clone the Repository

```bash
git clone https://github.com/nidhisingh5958/cyber_buddy.git
cd cyber_buddy
```

### 2. Backend Setup

#### Option A: Docker Deployment (Recommended)

```bash
# Build and run the backend using Docker Compose
docker-compose up --build
```

#### Option B: Manual Setup

```bash
cd backend

# Create a virtual environment (optional but recommended)
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Set up environment variables
cp .env.example .env
# Edit .env file with your Groq API key and other configurations

# Run the backend server
python main.py
```

### 3. Frontend Setup

```bash
cd frontend

# Verify Flutter installation
flutter doctor

# Install dependencies
flutter pub get

# Run the application
flutter run -d macos  # or windows/linux based on your OS
```

### 4. Environment Configuration

Create a `.env` file in the backend directory with the following variables:

```env
GROQ_API_KEY=your_groq_api_key_here
DEFAULT_MODEL=llama-3.3-70b-versatile
SESSION_SECRET_KEY=your_secret_key_here
```

## 🔌 API Endpoints

The backend provides the following RESTful API endpoints:

- **`POST /chat/`** - Send messages to the AI cybersecurity assistant
- **`GET /info/{topic}`** - Retrieve information about specific cybersecurity topics
- **`POST /logs/`** - Upload and analyze security log files
- **`GET /`** - Health check endpoint

### API Documentation
When the backend is running, visit `http://localhost:8000/docs` for interactive API documentation.

## 💻 Usage Examples

### Chat Interface
```bash
curl -X POST "http://localhost:8000/chat/" \
     -H "Content-Type: application/json" \
     -d '{"prompt": "Explain how firewalls work"}'
```

### Topic Information
```bash
curl -X GET "http://localhost:8000/info/encryption"
```

### Log Analysis
```bash
curl -X POST "http://localhost:8000/logs/" \
     -F "file=@/path/to/your/logfile.log"
```

## 💬 Example Queries

Ask Cyber Buddy about various cybersecurity topics:

* "Explain how firewalls work and their different types"
* "What are the key differences between symmetric and asymmetric encryption?"
* "How can I use Nmap for network reconnaissance?"
* "What are common phishing attack vectors and how to prevent them?"
* "Explain SQL injection attacks and mitigation strategies"
* "What are the best practices for password security?"
* "How does network intrusion detection work?"

## 📁 Project Structure

```
cyber_buddy/
│
├── frontend/                 # Flutter desktop application
│   ├── lib/
│   │   ├── screens/         # UI screens (home, chat, tools, etc.)
│   │   ├── services/        # API communication services
│   │   ├── models/          # Data models
│   │   ├── widgets/         # Custom widgets and components
│   │   └── utils/           # Routing and utilities
│   ├── pubspec.yaml         # Flutter dependencies
│   └── ...
│
├── backend/                  # FastAPI backend with AI integration
│   ├── app/
│   │   ├── routes/          # API route handlers
│   │   ├── services/        # Business logic (AI, log parsing)
│   │   ├── models/          # Pydantic models
│   │   └── utils.py         # Utilities and logging
│   ├── logs/                # Application logs
│   ├── main.py              # FastAPI application entry point
│   ├── requirements.txt     # Python dependencies
│   └── Dockerfile           # Docker configuration
│
├── docker-compose.yml       # Docker Compose configuration
└── README.md               # Project documentation
```

## 🛠️ Architecture Overview

### Frontend Architecture
- **Flutter Desktop**: Multi-platform desktop application
- **State Management**: Provider pattern for reactive state updates
- **API Integration**: HTTP services for backend communication
- **UI Components**: Custom widgets with animated particles and modern design

### Backend Architecture
- **FastAPI**: Modern, fast web framework for building APIs
- **LangChain Integration**: AI orchestration framework
- **Groq API**: Large language model inference
- **Modular Design**: Separate routes, services, and models
- **Logging System**: Comprehensive audit trails and error tracking

## 🔒 Security Features

- **Input Validation**: Pydantic models for request validation
- **CORS Protection**: Configured for secure cross-origin requests
- **Session Management**: Secure session handling
- **Environment Variables**: Sensitive data protection
- **Comprehensive Logging**: Security event tracking and monitoring

## 🚀 Deployment

### Docker Deployment

```bash
# Clone the repository
git clone https://github.com/nidhisingh5958/cyber_buddy.git
cd cyber_buddy

# Create environment file
cp backend/.env.example backend/.env
# Edit .env with your API keys

# Build and run with Docker Compose
docker-compose up --build
```

### Manual Deployment

1. **Backend Deployment**:
   ```bash
   cd backend
   pip install -r requirements.txt
   python main.py
   ```

2. **Frontend Deployment**:
   ```bash
   cd frontend
   flutter pub get
   flutter build <platform>  # windows, macos, or linux
   ```

## 🛡️ Privacy & Security

- Cyber Buddy processes user input securely and does not store sensitive data unless explicitly permitted
- API communication uses HTTPS in production environments
- All user interactions are logged for security auditing
- Environment variables protect sensitive API keys and configuration

## 🤝 Contributing

We welcome contributions to Cyber Buddy! Here's how you can help:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit your changes**: `git commit -m 'Add amazing feature'`
4. **Push to the branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

### Development Guidelines

- Follow Flutter and Python best practices
- Add tests for new features
- Update documentation as needed
- Ensure code is properly formatted

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev/) for the amazing cross-platform framework
- [FastAPI](https://fastapi.tiangolo.com/) for the high-performance web framework
- [LangChain](https://langchain.com/) for AI orchestration capabilities
- [Groq](https://groq.com/) for powerful language model inference
- The cybersecurity community for inspiration and knowledge sharing

## 📧 Support

If you have any questions, issues, or suggestions, please:

- Open an issue on GitHub
- Check the [documentation](http://localhost:8000/docs) when the backend is running
- Review existing issues before creating new ones

---

**Built with ❤️ for the cybersecurity community**
