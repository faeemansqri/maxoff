#!/bin/bash

# MaxOff - OSINT Tool Installer for Termux
# Created by: Mando
# Installation script for Android Termux environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Display banner
echo -e "${CYAN}"
echo "╔════════════════════════════════════════╗"
echo "║         MAXOFF TERMUX INSTALLER        ║"
echo "║    OSINT Phone Information Tool        ║"
echo "║         Created by: Mando             ║"
echo "╚════════════════════════════════════════╝"
echo "   GitHub: https://github.com/faeemansqri/maxoff"
echo -e "${NC}"

# Function to print status messages
print_status() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}❌${NC} $1"
}

print_info() {
    echo -e "${YELLOW}⏳${NC} $1"
}

# Check if running on Termux
if [ ! -f "$PREFIX/bin/termux-setup-storage" ] && [ ! -d "$PREFIX" ]; then
    print_error "This script is designed for Termux. Please run on Termux environment."
    exit 1
fi

print_info "Starting MaxOff installation for Termux..."
sleep 1

# Update package manager
print_info "Updating package manager..."
apt update -y
print_status "Package manager updated"

# Install Python dependencies
print_info "Installing Python dependencies..."
pip install requests rich
print_status "Python dependencies installed"

# Create installation directory
INSTALL_DIR="$HOME/maxoff"
print_info "Creating installation directory at $INSTALL_DIR..."

if [ -d "$INSTALL_DIR" ]; then
    print_info "Directory already exists, updating existing installation..."
    cd "$INSTALL_DIR"
else
    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR"
    print_status "Installation directory created"
fi

# Download the latest MaxOff files directly from GitHub
REPO_BASE="https://raw.githubusercontent.com/faeemansqri/maxoff/main"
print_info "Setting up MaxOff files from $REPO_BASE..."

curl -fsSL "$REPO_BASE/main.py" -o "$INSTALL_DIR/main.py"
curl -fsSL "$REPO_BASE/requirements.txt" -o "$INSTALL_DIR/requirements.txt"
curl -fsSL "$REPO_BASE/README.md" -o "$INSTALL_DIR/README.md"

print_status "MaxOff files downloaded"

# Create launcher script
cat > "$PREFIX/bin/maxoff" << 'EOF'
#!/bin/bash
cd "$HOME/maxoff"
python main.py
EOF

chmod +x "$PREFIX/bin/maxoff"
print_status "Launcher script created at /bin/maxoff"

# Create README
cat > "$INSTALL_DIR/README.md" << 'EOF'
# MaxOff - OSINT Phone Information Tool

## Installation Complete! ✓

MaxOff has been successfully installed on your Termux device.

### Quick Start

Run MaxOff from anywhere:
```bash
maxoff
```

Or run directly:
```bash
cd ~/maxoff
python main.py
```

### Features
- 📱 Phone number lookup (Indian phone numbers)
- 🎨 Beautiful colored terminal output
- ✓ Input validation and proofing
- 📊 Responsive design for mobile screens
- 🔄 Multiple queries in one session

### Commands
- Enter a 10-15 digit phone number to lookup
- Type `quit`, `exit`, `q`, or `bye` to exit

### Requirements
- Python 3.x
- requests
- rich

### Created by: Mando
EOF

print_status "README created"

# Display completion message
echo ""
echo -e "${GREEN}╔════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✓ Installation Complete!             ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}Installation Details:${NC}"
echo -e "  📁 Location: ${YELLOW}$INSTALL_DIR${NC}"
echo -e "  🚀 Command:  ${YELLOW}maxoff${NC}"
echo -e "  📝 Files:    main.py, requirements.txt, README.md"
echo ""
echo -e "${YELLOW}Quick Start:${NC}"
echo -e "  Type ${CYAN}maxoff${NC} in your terminal to start"
echo ""
print_status "MaxOff is ready to use!"
echo ""
