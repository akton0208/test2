#!/bin/bash

# Function to install Sonaric
function install_sonaric() {
    echo -e "${BLUE}Installing Sonaric...${NC}"
    sh -c "$(curl -fsSL http://get.sonaric.xyz/scripts/install.sh)"
    return_to_menu
}

# Function to get node information
function get_node_info() {
    echo -e "${BLUE}Getting node information...${NC}"
    sonaric node-info
    return_to_menu
}

# Function to reinstall Sonaric
function reinstall_sonaric() {
    echo -e "${BLUE}Reinstalling Sonaric...${NC}"
    sh -c "$(curl -fsSL http://get.sonaric.xyz/scripts/install.sh)"
    return_to_menu
}

# Function to export identity
function export_identity() {
    read -p "Enter node name: " node_name
    echo -e "${BLUE}Exporting identity...${NC}"
    sonaric identity-export -o ${node_name}.identity
    return_to_menu
}

# Function to import identity
function import_identity() {
    read -p "Enter node name: " node_name
    echo -e "${BLUE}Importing identity...${NC}"
    sonaric identity-import -i ${node_name}.identity
    return_to_menu
}

# Function to show Sonaric points
function show_sonaric_points() {
    echo -e "${BLUE}Showing Sonaric points...${NC}"
    sonaric points
    return_to_menu
}

# Function to rename Sonaric node
function rename_node() {
    read -p "Enter current node name: " current_name
    read -p "Enter new node name: " new_name
    echo -e "${BLUE}Renaming node from ${current_name} to ${new_name}...${NC}"
    sonaric node-rename -i ${current_name} -n ${new_name}
    return_to_menu
}

# Function to uninstall Sonaric
function uninstall_sonaric() {
    echo -e "${RED}Uninstalling Sonaric...${NC}"
    sudo apt remove --purge sonaricd sonaric
    return_to_menu
}

# Function to register Sonaric node
function register_node() {
    echo -e "${YELLOW}Please go to the official Discord and enter /addnode to get your registration code.${NC}"
    read -p "Enter your registration code: " registration_code
    echo -e "${BLUE}Registering node with code ${registration_code}...${NC}"
    sonaric node-register ${registration_code}
    return_to_menu
}

# Function to sign a message
function sign_message() {
    echo -e "${YELLOW}Please complete step 9 (Register Sonaric node) before signing a message.${NC}"
    read -p "Enter the message to sign: " message
    echo -e "${BLUE}Signing message '${message}'...${NC}"
    sonaric sign "${message}"
    return_to_menu
}

# Function to return to the main menu
function return_to_menu() {
    read -p "Press any key to return to the main menu..." -n1 -s
    main_menu
}

# Main menu
function main_menu() {
    clear
    echo -e "${RED}-----------------Sonaric Script Menu--------------------${NC}"
    echo "Please select an option:"
    echo "1. Install Sonaric"
    echo "2. Get node information"
    echo "3. Reinstall Sonaric"
    echo "4. Export identity"
    echo "5. Import identity"
    echo "6. Show Sonaric points"
    echo "7. Rename Sonaric node"
    echo "8. Uninstall Sonaric"
    echo -e "9. Register Sonaric node ${YELLOW}Please complete step 9 (Register Sonaric node) before signing a message.${NC}"
    echo "10. Sign a message"
    echo "11. Exit"
    read -p "Enter option (1-11): " option

    case $option in
        1) install_sonaric ;;
        2) get_node_info ;;
        3) reinstall_sonaric ;;
        4) export_identity ;;
        5) import_identity ;;
        6) show_sonaric_points ;;
        7) rename_node ;;
        8) uninstall_sonaric ;;
        9) register_node ;;
        10) sign_message ;;
        11) exit 0 ;;
        *) echo "Invalid option. Please select a number between 1 and 11." ;;
    esac
}

# Run the main menu
main_menu
