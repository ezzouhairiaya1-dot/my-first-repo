#!/bin/bash
# env_install.sh
# Sets up a small Python development environment.
# Works on Linux (apt) and macOS (Homebrew).

# Feature 1: pretty printing (blank lines around the message, printf)
pretty_print() {
    printf "\n%s\n\n" "$1"
}

# Feature 2: operating system detection with OSTYPE
detect_os() {
    case "$OSTYPE" in
        darwin*) echo "macos" ;;
        linux*)  echo "linux" ;;
        *)       echo "unknown" ;;
    esac
}

OS="$(detect_os)"
pretty_print "Detected operating system: $OS"

if [ "$OS" = "unknown" ]; then
    pretty_print "Unsupported system: $OSTYPE. Use Linux, macOS or WSL."
    exit 1
fi

# Refresh the package list once on Linux
if [ "$OS" = "linux" ]; then
    pretty_print "Updating the package list (apt)..."
    sudo apt update
fi

# Feature 3: Python install check
if command -v python3 > /dev/null 2>&1; then
    pretty_print "Python is already installed: $(python3 --version)"
else
    pretty_print "Python 3 not found. Installing it..."
    if [ "$OS" = "macos" ]; then
        brew install python3
    else
        sudo apt install -y python3
    fi
    if ! command -v python3 > /dev/null 2>&1; then
        pretty_print "Python installation failed. Stopping."
        exit 1
    fi
    pretty_print "Python installed: $(python3 --version)"
fi

# Feature 4: pip version verification
if python3 -m pip --version > /dev/null 2>&1; then
    pretty_print "pip is available: $(python3 -m pip --version)"
else
    pretty_print "pip not found. Installing it..."
    if [ "$OS" = "macos" ]; then
        brew reinstall python3
    else
        sudo apt install -y python3-pip
    fi
    pretty_print "pip: $(python3 -m pip --version)"
fi

# Feature 5: Jupyter Notebook installation (depends on the OS)
pretty_print "Installing Jupyter Notebook..."
if [ "$OS" = "macos" ]; then
    brew install jupyter
else
    sudo apt install -y jupyter-notebook
fi

if command -v jupyter > /dev/null 2>&1; then
    pretty_print "Jupyter installed: $(jupyter --version | head -n 1)"
else
    pretty_print "Jupyter command not found after installation."
fi

# Feature 6: macOS only, check that Homebrew is healthy
if [ "$OS" = "macos" ]; then
    pretty_print "Checking Homebrew health..."
    brew doctor
fi

pretty_print "Done. Environment is ready."
