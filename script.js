// Enhanced interactivity for the portfolio
document.addEventListener('DOMContentLoaded', function() {
    // Smooth scrolling for navigation
    const sections = document.querySelectorAll('.section');
    
    // Add animation on scroll
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };
    
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animation = 'slideInUp 0.6s ease forwards';
            }
        });
    }, observerOptions);
    
    sections.forEach(section => {
        observer.observe(section);
    });
    
    // Add click effects to tech stack items
    const techItems = document.querySelectorAll('.tech');
    techItems.forEach(item => {
        item.addEventListener('click', function() {
            this.style.transform = 'scale(0.95)';
            setTimeout(() => {
                this.style.transform = 'scale(1)';
            }, 150);
        });
    });
    
    // Add hover effects to project cards
    const projects = document.querySelectorAll('.project');
    projects.forEach(project => {
        project.addEventListener('mouseenter', function() {
            this.style.borderLeftWidth = '8px';
        });
        
        project.addEventListener('mouseleave', function() {
            this.style.borderLeftWidth = '4px';
        });
    });
    
    // Pipeline status animation
    const statusBadges = document.querySelectorAll('.status-badge');
    let delay = 0;
    
    statusBadges.forEach(badge => {
        setTimeout(() => {
            badge.style.animation = 'pulse 1s ease-in-out';
        }, delay);
        delay += 200;
    });
    
    // Console log for DevOps demonstration
    console.log('🚀 DevOps Portfolio Loaded Successfully!');
    console.log('📦 Containerized with Docker');
    console.log('🔄 CI/CD Pipeline: GitHub Actions');
    console.log('🌐 Deployed on: GitHub Pages');
    console.log('👨‍💻 Built by: Hubert Zych');
});

// Add CSS animations dynamically
const style = document.createElement('style');
style.textContent = `
    @keyframes slideInUp {
        from {
            opacity: 0;
            transform: translateY(30px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    @keyframes pulse {
        0%, 100% {
            transform: scale(1);
        }
        50% {
            transform: scale(1.05);
        }
    }
    
    .section {
        opacity: 0;
        transform: translateY(30px);
    }
`;
document.head.appendChild(style);
