# Hubert Zych - DevOps Portfolio

![CI/CD Pipeline](https://github.com/nihilx/my_page/workflows/CI/CD%20Pipeline/badge.svg)
![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E5.svg?style=for-the-badge&logo=githubactions&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)

## 🚀 DevOps Portfolio Website

A modern, responsive portfolio website showcasing DevOps engineering skills through practical implementation of CI/CD pipelines, containerization, and automated deployment.

### 🌐 Live Demo
- **Website**: [https://nihilxi.github.io](https://nihilxi.github.io)
- **Status**: ✅ Deployed with automated CI/CD

## 🛠️ Technology Stack

### Frontend
- **HTML5** - Semantic markup with accessibility features
- **CSS3** - Modern styling with Flexbox/Grid and animations
- **JavaScript** - Interactive features and smooth UX
- **Responsive Design** - Mobile-first approach

### DevOps & Infrastructure
- **Docker** - Containerized application with multi-stage builds
- **GitHub Actions** - Automated CI/CD pipeline
- **Nginx** - High-performance web server with security headers
- **GitHub Pages** - Static site hosting with custom domain support

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Developer     │    │   GitHub Actions │    │  GitHub Pages   │
│   Push Code     │───▶│   CI/CD Pipeline │───▶│   Live Website  │
└─────────────────┘    └──────────────────┘    └─────────────────┘
                                │
                                ▼
                       ┌──────────────────┐
                       │ Docker Container │
                       │    Testing       │
                       └──────────────────┘
```

## 🚀 Quick Start

### Prerequisites
- Docker installed on your system
- Git for version control
- (Optional) Docker Compose for orchestration

### Local Development

1. **Clone the repository**
   ```bash
   git clone git@github.com:nihilxi/nihilxi.github.io.git
   cd nihilxi.github.io
   ```

2. **Build Docker image**
   ```bash
   sudo docker build -t portfolio:latest .
   ```

3. **Run container**
   ```bash
   sudo docker run -d -p 8080:80 --name portfolio-app portfolio:latest
   ```

4. **Access the website**
   ```
   http://localhost:8080
   ```

### Using Docker Compose

```bash
# Development mode
sudo docker-compose up -d

# Production mode with proxy
sudo docker-compose --profile production up -d
```

## 🔄 CI/CD Pipeline

The automated pipeline includes:

### 1. **Code Quality Checks**
- HTML validation with HTMLHint
- CSS linting with Stylelint
- JavaScript linting with ESLint
- Security scanning with Trivy

### 2. **Docker Build & Test**
- Multi-stage Docker build
- Container security scanning
- Health check validation
- Automated testing

### 3. **Deployment**
- Automated deployment to GitHub Pages
- Release creation with versioning
- Notification system

### 4. **Monitoring**
- Container health checks
- Performance monitoring
- Error tracking

## 📁 Project Structure

```
nihilxi.github.io/
├── .github/
│   └── workflows/
│       └── ci-cd.yml          # GitHub Actions pipeline
├── index.html                 # Main website file
├── styles.css                 # Styling and responsive design
├── script.js                  # Interactive features
├── Dockerfile                 # Container configuration
├── docker-compose.yml         # Multi-container setup
├── nginx.conf                 # Web server configuration
├── .dockerignore             # Docker build exclusions
└── README.md                 # This file
```

## 🔧 DevOps Features Demonstrated

### Containerization
- **Dockerfile** with multi-stage builds
- **Health checks** and container monitoring
- **Security best practices** and minimal attack surface
- **Resource optimization** with Alpine Linux

### CI/CD Pipeline
- **Automated testing** with multiple quality gates
- **Security scanning** for vulnerabilities
- **Container orchestration** with Docker Compose
- **Infrastructure as Code** principles

### Monitoring & Observability
- **Health check endpoints** for monitoring
- **Structured logging** for debugging
- **Performance optimization** with Nginx
- **Security headers** and best practices

## 🛡️ Security Features

- **Security headers** implementation
- **Content Security Policy** (CSP)
- **Container vulnerability scanning**
- **Minimal base images** (Alpine Linux)
- **Non-root container execution**

## 📊 Performance Optimizations

- **Gzip compression** for faster loading
- **Static asset caching** with appropriate headers
- **Image optimization** and lazy loading
- **Minified CSS/JS** for production builds

## 🎯 Learning Outcomes

This project demonstrates practical knowledge of:

- **Container Orchestration** - Docker and Docker Compose
- **CI/CD Pipelines** - GitHub Actions automation
- **Infrastructure as Code** - Configuration management
- **Web Server Configuration** - Nginx optimization
- **Security Best Practices** - Container and web security
- **Monitoring & Logging** - Health checks and observability

## 🚀 Deployment

The website is automatically deployed through GitHub Actions:

1. **Code push** triggers the CI/CD pipeline
2. **Quality checks** ensure code standards
3. **Docker build** creates optimized container
4. **Security scanning** validates container safety
5. **Automated deployment** to GitHub Pages
6. **Monitoring** ensures successful deployment

## 📬 Contact

**Hubert Zych**
- 📍 Wrocław, Poland
- 🎓 Computer Engineering Student at Wrocław University of Science and Technology
- 💼 Specialization: Computer Networks & DevOps

---

*This portfolio showcases practical DevOps skills through real-world implementation of modern development and deployment practices.*
