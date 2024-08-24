# System Dashboard Script

This script provides a comprehensive overview of your system’s performance and status. It displays information about CPU usage, memo>

## Features

- **Top 10 Most Used Applications:** Displays the top 10 processes by CPU and memory usage.
- **Network Monitoring:** Shows concurrent connections, packet drops, and network traffic (received and transmitted).
- **Disk Usage:** Provides details about disk usage and warnings for disks over 80% usage.
- **System Load:** Displays load averages and CPU usage statistics.
- **Memory Usage:** Shows details about memory and swap usage.
- **Process Monitoring:** Lists active processes and the top 5 processes by CPU and memory.
- **Service Monitoring:** Checks the status of essential services (e.g., sshd, nginx, apache2, iptables).

## Installation

   **Clone the repository:**
   ```bash
   git clone https://github.com/yourusername/system-dashboard.git
   cd system-dashboard
   Running the script without any switches will display the full dashboard and refresh it every 5 seconds.

RUN THE COMMANDS :-

chmod +x set-01.sh

./set-01.sh

options to run individual parts of dashboard -

-cpu: Display the system load and CPU usage.
run: ./set-01.sh -cpu

-memory: Display memory and swap usage.
run: ./set-01.sh -memory

-network: Display network monitoring details.
run: ./set-01.sh -network

-disk: Display disk usage information.
run: ./set-01.sh -disk

-process: Display active process details.
run: ./set-01.sh -process

-service: Monitor the status of essential services.
run: ./set-01.sh -service

-top: Show the top 10 most used applications by CPU and memory.
run: ./set-01.sh -top
