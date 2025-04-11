# Cybrahimi-tool
tool about dos attack

# 🚨 Cybrahimi DoS Tool (Educational)  
*A multi-vector Denial-of-Service (DoS) testing tool for cybersecurity research.*  


![Uploading 2025-04-11 20_11_30-kali-linux-2024.3-vmware-amd64 - VMware Workstation 16 Player.png…]()

---

 📌 **Description**  
**Cybrahimi** is a **proof-of-concept** DoS (Denial-of-Service) testing tool designed to demonstrate different attack vectors in a controlled environment. It uses `hping3`, `ping`, and other networking tools to simulate various low to high-level DoS attacks.  

⚠ **This tool is for educational and authorized penetration testing only.**  

---

 🔥 **Features**  
✔ **8+ Attack Methods** (SYN, ACK, FIN, RST, UDP, ICMP, HTTP, Ping)  
✔ **IP/Domain Targeting** (Auto-resolves domains to IP)  
✔ **Port Customization** (Adjustable for TCP/UDP attacks)  
✔ **Multi-Vector Mode** (Sequential attack testing)  
✔ **Clean Bash Implementation** (No bloat, just raw networking)  

---

 ⚠ **Legal & Ethical Disclaimer**  
❌ **Illegal Use Prohibited**: This tool must **only** be used on systems you own or have explicit permission to test.  
🔒 **Educational Purpose**: Designed for cybersecurity students, researchers, and penetration testers.  
⚖ **Liability**: The developer is **not responsible** for misuse. Unauthorized DoS attacks are **criminal offenses** in most countries.  

---

 🛠 **Installation**  
```bash
git clone https://github.com/abderrahimhb20/Cybrahimi-tool.git
cd cybrahimi
chmod +x cybrahimi.sh
sudo ./cybrahimi.sh
```
**Dependencies**:  
- `hping3` (`sudo apt install hping3` on Debian/Ubuntu)  
- `dig` (usually pre-installed)  

---

 🎯 **Usage**  
1. **Run the tool**:  
   ```bash
   sudo ./cybrahimi.sh
   ```
2. **Enter target** (IP or domain).  
3. **Select attack method**:  
   - SYN, ACK, FIN, RST (TCP floods)  
   - UDP, ICMP (Network-layer floods)  
   - HTTP (Layer 7 flood)  
   - **ALL** (Runs all attacks sequentially)  
4. **Set port** (if applicable).  
5. **Attack executes** (Press `Ctrl+C` to stop).  

---

 📊 **Attack Comparison**  
| Attack | Layer | Protocol | Best For | Detection Level |
|--------|-------|----------|----------|-----------------|
| **SYN** | 4 (Transport) | TCP | Exhausting connection tables | Medium |
| **ACK** | 4 | TCP | CPU exhaustion | Medium |
| **FIN** | 4 | TCP | Stealthy session termination | High |
| **UDP** | 4 | UDP | Bandwidth flooding | Low |
| **HTTP** | 7 (Application) | HTTP | Web server crashing | High |
| **ICMP** | 3 (Network) | ICMP | Basic ping flooding | Very Low |

---

 📜 **License**  
**MIT License** – Free for educational use, but **NO WARRANTY**.  

---

### 🔗 **Contribute**  
🔹 Found a bug? Open an **Issue**.  
🔹 Want to improve it? Submit a **PR**.  

🚀 **Happy ethical hacking!**  


