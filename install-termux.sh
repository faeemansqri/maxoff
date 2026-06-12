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

# Install Python and dependencies
print_info "Installing Python and required packages..."
apt install -y python pip git
print_status "Python and pip installed"

# Upgrade pip
print_info "Upgrading pip..."
pip install --upgrade pip setuptools wheel
print_status "Pip upgraded"

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

# Download main.py from GitHub or use current
print_info "Setting up MaxOff files..."

# Create main.py with MaxOff code
cat > "$INSTALL_DIR/main.py" << 'EOF'
import requests
import json
import re
from rich.console import Console
from rich.table import Table
from rich.panel import Panel
from rich.prompt import Prompt
from rich.text import Text
from rich.align import Align
from rich import box

console = Console()

def print_responsive_banner():
    """Print responsive banner using Rich's built-in features"""
    # Main title
    title = Text("MAXOFF", style="bold cyan", justify="center")
    subtitle = Text("OSINT Phone Information Tool", style="bold yellow", justify="center")
    creator = Text("Created by: Mando v1.0", style="bold green", justify="center")
    
    # Create panel with Rich's styling
    banner_panel = Panel(
        f"{title}\n{subtitle}\n{creator}",
        style="cyan",
        box=box.ROUNDED,
        padding=(1, 2),
        expand=False
    )
    
    console.print()
    console.print(Align.center(banner_panel))
    console.print()

# Display responsive banner on startup
print_responsive_banner()

def validate_phone_number(num):
    """Validate and proof phone number input"""
    if not num:
        console.print("[bold red]❌ Phone number cannot be empty![/bold red]")
        return False
    
    # Remove any spaces or hyphens
    num = re.sub(r'[\s\-]', '', num)
    
    # Check if it's numeric
    if not num.isdigit():
        console.print("[bold red]❌ Only digits allowed! Remove letters or special chars[/bold red]")
        return False
    
    # Check length (Indian phone numbers are 10 digits)
    if len(num) < 10:
        console.print(f"[bold red]❌ Phone too short! Got {len(num)} digits, need 10+[/bold red]")
        return False
    
    if len(num) > 15:
        console.print("[bold red]❌ Phone number too long! Max 15 digits[/bold red]")
        return False
    
    return num

def getnuminfo(num):
    key = "96temp&num" 
    url = f"https://anon-num-info.vercel.app/num?key={key}={num}"
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        return {"error": "Could not retrieve information."}

def format_address(addr):
    """Clean up address string"""
    return addr.replace("!", ", ").strip()

while True:
    console.print()
    user_input = Prompt.ask(
        "[bold cyan]📱 Enter phone number[/bold cyan]",
        default="",
        show_default=False
    ).strip()
    
    if not user_input:
        console.print("[bold yellow]⚠️  Please enter a valid phone number[/bold yellow]")
        continue
    
    if user_input.lower() in ['quit', 'exit', 'q', 'bye']:
        console.print("\n[bold green]✓ Thanks for using MaxOff! Goodbye 👋[/bold green]\n")
        break
    
    validated_num = validate_phone_number(user_input)
    if not validated_num:
        continue
    
    console.print("\n[bold yellow]⏳ Fetching data...[/bold yellow]")
    info = getnuminfo(validated_num)

    if "response" in info and "data" in info["response"]:
        records = info["response"]["data"]
        
        if len(records) == 0:
            console.print("[bold yellow]⚠️  No records found for this number[/bold yellow]")
            continue
        
        console.print(f"\n[bold green]✓ Found {len(records)} record(s)[/bold green]\n")
        
        for idx, record in enumerate(records, 1):
            # Create vertical table for each entry
            table = Table(
                title=f"[bold magenta]📋 RESULT #{idx} / {len(records)}[/bold magenta]",
                box=box.ROUNDED,
                show_header=True,
                header_style="bold cyan"
            )
            
            table.add_column("Field", style="cyan", width=18)
            table.add_column("Value", style="green", no_wrap=False)
            
            table.add_row("👤 Name", record.get("name", "N/A"))
            table.add_row("👨‍👨‍👦 Father's Name", record.get("fname", "N/A"))
            table.add_row("📱 Phone Number", f"[bold yellow]{record.get('num', 'N/A')}[/bold yellow]")
            table.add_row("📞 Alternate", record.get("alt", "N/A") or "—")
            table.add_row("📍 Address", format_address(record.get("address", "N/A")))
            table.add_row("🌐 Circle", f"[bold blue]{record.get('circle', 'N/A')}[/bold blue]")
            table.add_row("🆔 Aadhar", record.get("aadhar", "N/A") or "—")
            table.add_row("📧 Email", record.get("email", "N/A") or "—")
            
            console.print(table)
            console.print()
            
        # Summary panel
        summary = Panel(
            f"[bold green]✓ Retrieved {len(records)} record(s) successfully[/bold green]",
            style="bold cyan",
            expand=False
        )
        console.print(summary)
    else:
        console.print("[bold red]❌ No data found or API error occurred[/bold red]")
        if "error" in info:
            console.print(f"[dim red]Details: {info['error']}[/dim red]")
EOF

print_status "MaxOff main.py created"

# Create requirements.txt
cat > "$INSTALL_DIR/requirements.txt" << 'EOF'
requests
rich
EOF

print_status "requirements.txt created"

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
