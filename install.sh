#!/bin/bash

# Color codes for formatting
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print section headers
print_header() {
    echo -e "${PURPLE}"
    echo "╔════════════════════════════════════════════════════════════════╗"
    echo "║$1║"
    echo "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# Function to print status messages
print_status() {
    echo -e "${CYAN}⟹${NC} $1"
}

# Function to print success messages
print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

# Function to print error messages
print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Function to print warning messages
print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Function to print progress bar
print_progress() {
    local current=$1
    local total=$2
    local message=$3
    local width=50
    local percentage=$((current * 100 / total))
    local completed=$((current * width / total))
    local remaining=$((width - completed))
    
    printf "\r${BLUE}[%3d%%]${NC} %s ${GREEN}[%*s${NC}%*s]" \
        $percentage "$message" $completed "$(printf '%*s' $completed | tr ' ' '█')" $remaining ""
}

# Function to execute command with error handling
execute_command() {
    local step=$1
    local command=$2
    local message=$3
    
    print_status "$message"
    if eval $command; then
        print_success "Step $step completed successfully"
        return 0
    else
        print_error "Step $step failed"
        return 1
    fi
}

# Main installation function
main() {
    clear
    print_header "           🚀 BOT DEPENDENCIES INSTALLATION SCRIPT           "
    echo ""
    print_warning "This script will install various dependencies for bot development"
    print_warning "It may take several minutes to complete"
    echo ""
    
    # Total steps for progress tracking
    local total_steps=15
    local current_step=0
    
    # Step 1: Update system
    ((current_step++))
    print_progress $current_step $total_steps "Updating system packages..."
    execute_command 1 "sudo apt update -y && sudo apt upgrade -y" "System update and upgrade"
    echo ""
    
    # Step 2: Install git and curl
    ((current_step++))
    print_progress $current_step $total_steps "Installing git and curl..."
    execute_command 2 "sudo apt install git -y && sudo apt install curl -y" "Git and curl installation"
    echo ""
    
    # Step 3: Install multimedia tools
    ((current_step++))
    print_progress $current_step $total_steps "Installing multimedia tools..."
    execute_command 3 "sudo apt install ffmpeg -y && sudo apt install webp -y && sudo apt install imagemagick -y" "Multimedia tools installation"
    echo ""
    
    # Step 4: Install zip tools
    ((current_step++))
    print_progress $current_step $total_steps "Installing zip utilities..."
    execute_command 4 "sudo apt install zip -y && sudo apt install unzip -y" "Zip utilities installation"
    echo ""
    
    # Step 5: Install Node.js
    ((current_step++))
    print_progress $current_step $total_steps "Installing Node.js..."
    execute_command 5 "sudo apt-get install nodejs -y" "Node.js installation"
    echo ""
    
    # Step 6: Install NVM
    ((current_step++))
    print_progress $current_step $total_steps "Installing Node Version Manager (NVM)..."
    execute_command 6 "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash" "NVM installation"
    echo ""
    
    # Step 7: Load NVM configuration
    ((current_step++))
    print_progress $current_step $total_steps "Loading NVM configuration..."
    execute_command 7 "source ~/.bashrc" "NVM configuration load"
    echo ""
    
    # Step 8: Install Node.js 20 via NVM
    ((current_step++))
    print_progress $current_step $total_steps "Installing Node.js 20..."
    execute_command 8 "nvm install 20" "Node.js 20 installation via NVM"
    echo ""
    
    # Step 9: Switch to Node.js 20
    ((current_step++))
    print_progress $current_step $total_steps "Switching to Node.js 20..."
    execute_command 9 "nvm use 20" "Node.js version switch"
    echo ""
    
    # Step 10: Install PM2 globally
    ((current_step++))
    print_progress $current_step $total_steps "Installing PM2 process manager..."
    execute_command 10 "npm i pm2 -g" "PM2 global installation"
    echo ""
    
    # Step 11: Install Yarn
    ((current_step++))
    print_progress $current_step $total_steps "Installing Yarn package manager..."
    execute_command 11 "curl -o- -L https://yarnpkg.com/install.sh | bash" "Yarn installation"
    echo ""
    
    # Step 12: Add Yarn repository key
    ((current_step++))
    print_progress $current_step $total_steps "Adding Yarn repository key..."
    execute_command 12 "curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -" "Yarn repository key addition"
    echo ""
    
    # Step 13: Install Yarn via apt
    ((current_step++))
    print_progress $current_step $total_steps "Installing Yarn via package manager..."
    execute_command 13 "sudo apt install yarn -y" "Yarn installation via apt"
    echo ""
    
    # Step 14: Install neofetch
    ((current_step++))
    print_progress $current_step $total_steps "Installing neofetch system info tool..."
    execute_command 14 "sudo apt install neofetch -y" "Neofetch installation"
    echo ""
    
    # Step 15: Additional installations
    ((current_step++))
    print_progress $current_step $total_steps "Installing additional dependencies..."
    execute_command 15 "nvm install 20 && nvm use 20 && npm i pm2 -g && npm install gyp -g && sudo apt-get install g++ -y" "Additional dependencies installation"
    echo ""
    
    # Final progress completion
    print_progress $total_steps $total_steps "Installation completed!"
    echo -e "\n"
    
    # Verification section
    print_header "              ✅ INSTALLATION VERIFICATION               "
    
    echo -e "${BLUE}📊 Checking installed versions:${NC}"
    echo ""
    
    # Node.js version check
    if command -v node &> /dev/null; then
        echo -e "${GREEN}✓ Node.js:${NC} $(node --version)"
    else
        echo -e "${RED}✗ Node.js: Not installed${NC}"
    fi
    
    # npm version check
    if command -v npm &> /dev/null; then
        echo -e "${GREEN}✓ npm:${NC} $(npm --version)"
    else
        echo -e "${RED}✗ npm: Not installed${NC}"
    fi
    
    # PM2 version check
    if command -v pm2 &> /dev/null; then
        echo -e "${GREEN}✓ PM2:${NC} $(pm2 --version)"
    else
        echo -e "${RED}✗ PM2: Not installed${NC}"
    fi
    
    # Yarn version check
    if command -v yarn &> /dev/null; then
        echo -e "${GREEN}✓ Yarn:${NC} $(yarn --version)"
    else
        echo -e "${RED}✗ Yarn: Not installed${NC}"
    fi
    
    # FFmpeg version check
    if command -v ffmpeg &> /dev/null; then
        echo -e "${GREEN}✓ FFmpeg:${NC} $(ffmpeg -version | head -n1 | cut -d' ' -f1-3)"
    else
        echo -e "${RED}✗ FFmpeg: Not installed${NC}"
    fi
    
    # Git version check
    if command -v git &> /dev/null; then
        echo -e "${GREEN}✓ Git:${NC} $(git --version | cut -d' ' -f3)"
    else
        echo -e "${RED}✗ Git: Not installed${NC}"
    fi
    
    echo ""
    print_header "              🎉 INSTALLATION COMPLETED!                "
    echo ""
    echo -e "${GREEN}All dependencies have been installed successfully!${NC}"
    echo ""
    echo -e "${YELLOW}📝 Next steps:${NC}"
    echo -e "  • Run ${CYAN}source ~/.bashrc${NC} or restart your terminal"
    echo -e "  • Create your bot project directory"
    echo -e "  • Initialize your project with ${CYAN}npm init${NC}"
    echo -e "  • Start your bot with ${CYAN}pm2 start${NC}"
    echo ""
    echo -e "${BLUE}💡 Tip: Run ${CYAN}neofetch${NC} to see system information${NC}"
    echo ""
}

# Run main function
main