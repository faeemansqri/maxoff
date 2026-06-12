# MaxOff Termux Installation Guide

## 📱 Installation Instructions for Termux (Android)

**GitHub Repository:** https://github.com/faeemansqri/maxoff

### One-step install

Run this single command in Termux:

```bash
curl -fsSL https://raw.githubusercontent.com/faeemansqri/maxoff/main/install-termux.sh | bash
```

This one command will:
- update Termux packages
- install Python, pip, and required tools
- download the latest MaxOff files from GitHub
- create the `maxoff` launcher command

This will:
- ✓ Update your package manager
- ✓ Install Python and pip
- ✓ Install required dependencies (requests, rich)
- ✓ Create MaxOff installation directory
- ✓ Set up the launcher command

### Step 4: Start Using MaxOff

After installation completes, simply type:

```bash
maxoff
```

## 🎯 Quick Start

1. **Launch MaxOff:**
   ```bash
   maxoff
   ```

2. **Enter a phone number** (10-15 digits)
   ```
   📱 Enter phone number: 9876543210
   ```

3. **View the results** in beautiful formatted tables

4. **Exit:** Type `quit`, `exit`, `q`, or `bye`

## 📋 Requirements

- **Android Device** with Termux installed
- **Termux Storage Access** (optional, for file operations)
- **Internet Connection** (for phone number lookups)

### Optional: Grant Storage Access

```bash
termux-setup-storage
```

## 🛠️ Manual Installation (If Script Fails)

```bash
# Update packages
apt update && apt upgrade -y

# Install Python and dependencies
apt install -y python pip git

# Create MaxOff directory
mkdir -p ~/maxoff && cd ~/maxoff

# Install Python packages
pip install requests rich

# Copy main.py to ~/maxoff/

# Create launcher
mkdir -p ~/.bin
echo 'python ~/maxoff/main.py' > ~/.bin/maxoff
chmod +x ~/.bin/maxoff

# Add to PATH (add to ~/.bashrc)
export PATH="$HOME/.bin:$PATH"
```

## 🔧 Troubleshooting

**Issue: "pip: command not found"**
```bash
apt install python-pip
```

**Issue: "requests not found"**
```bash
pip install requests
```

**Issue: "rich not found"**
```bash
pip install rich
```

**Issue: "maxoff: command not found"**
```bash
# Try the full path
python ~/maxoff/main.py
```

## 📚 Features

- 🔍 OSINT phone number lookup
- 🎨 Beautiful colored output with emojis
- ✅ Input validation and error handling
- 📊 Responsive design for mobile screens
- 🔄 Multiple queries in one session
- 📋 Vertical table formatting

## 📝 Supported Commands

| Command | Action |
|---------|--------|
| Phone number (10-15 digits) | Look up phone information |
| quit, exit, q, bye | Exit the application |

## 💡 Tips

- Install `termux-api` for enhanced features:
  ```bash
  apt install termux-api
  ```

- Save output to file:
  ```bash
  maxoff > lookup_results.txt 2>&1
  ```

- Keep MaxOff updated:
  ```bash
  cd ~/maxoff && git pull
  ```

## ❓ Need Help?

For issues or questions:
- Check Termux documentation: https://termux.dev
- Review the main README.md
- Verify all dependencies are installed

---

**Created by: Mando**
**MaxOff v1.0 - OSINT Phone Information Tool**
