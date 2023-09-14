#!/bin/bash

# Define ANSI escape codes for colors
RED="\033[0;31m"
GREEN="\033[38;5;46m"
YELLOW="\033[0;33m"
RESET="\033[0m"  # Reset text color to default

# ASCII art banner
ascii_art="
________                __     _______         .__   
\\______ \\ _____ _______|  | __ \\   _  \\__  _  _|  |  
 |    |  \\\\__    \\\\_  __ |  |/ / /  /_\\  \\ \\/ \\/ |  |  
 |    '   \\/ __ \\|  | \\|    <  \\  \\_/   \\     /|  |__
/_______  (____  |__|  |__|_ \\  \\_____  /\\/\\_/ |____/
        \\/     \\/           \\/        \\/              
 
       The Lazy CTF Directory Creator 
       	   and initial nmap scan
@@DarkOwl"

echo -e "${GREEN}$ascii_art${RESET}"
echo
echo
echo "Welcome to the Directory and Nmap Scanner Script"

# Ask for the location where you want to create the main directory
read -p "Enter the directory path where you want to create the main directory (or press Enter for the current directory): " location

# If the user provided a location, change to that directory; otherwise, use the current directory
if [ -n "$location" ]; then
    cd "$location"
fi

# Ask for the main directory name
read -p "Enter the main directory name: " main_dir_name

# Create the main directory
mkdir "$main_dir_name"

# Enter the main directory
cd "$main_dir_name"

# Create subdirectories
mkdir scans steps payloads screenshots

# Create an 'nmap' directory inside the 'scans' directory
mkdir scans/nmap

# Create Steps.md file in the Steps file
touch steps/Steps_"$main_dir_name".md

# Ask the user for the IP address to scan
read -p "Enter the IP address to scan: " ip_address

# Define Nmap command with --append-output and then colorize the output
nmap_command="nmap --min-rate 1000 -sC -sV -T4 -A --stats-every 5s -oA scans/nmap/$main_dir_name $ip_address"

# Run Nmap with the specified arguments
eval "$nmap_command" | {
    while IFS= read -r line; do
        # Check for specific strings in the output and colorize them
        if [[ "$line" == "Starting Nmap"* || "$line" == "Stats:"* || "$line" == "Service scan Timing:"* || "$line" == "NSE Timing:"* ]]; then
            echo -e "${GREEN}$line${RESET}"
        else
            echo -e "$line"
        fi
    done
}

echo
echo
echo -e "${YELLOW}Scan completed. Results saved in scans/nmap/${RESET}"
echo
echo -e "${RED}                   Happy Hunting ;)${RESET}"

