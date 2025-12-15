# GitHub Actions Self-hosted Runner

This directory contains scripts to provision a self-hosted runner for the HomeLab CI/CD pipeline.

## Prerequisites
- A Raspberry Pi (Pi 4 or Pi 5) running Linux (ARM64).
- Internet connection.
- A GitHub Personal Access Token (PAT) or Runner Token.

## Logic Overview
The runner connects to GitHub and listens for jobs labeled `self-hosted`. When a job appears (like `Deploy to Server`), it executes the steps locally on the Pi.

## 🧠 Concepts & Cost

### What is a Self-hosted Runner?
It is a small application installed on **your own server** (Raspberry Pi/VPS) to execute GitHub Actions workflows. Instead of using GitHub's cloud servers, the code runs directly on your machine.

### How it works
1.  **Polling:** The runner connects to GitHub (via HTTPS) and constantly asks: "Do you have work for me?".
2.  **Execution:** When you push code, GitHub sees `runs-on: self-hosted` in your YAML.
3.  **Dispatch:** GitHub sends the job to your Raspberry Pi.
4.  **Action:** The Pi clones the code, builds the docker image, and runs it locally.

### 💰 Cost Analysis
*   **Software:** **Free**. You don't pay GitHub for self-hosted runner minutes (unlike GitHub-hosted runners which have limits).
*   **Hardware:** You pay for your own hardware (Pi) and electricity.
*   **Performance:** Often **faster** because:
    *   No queue times.
    *   Persistent cache (docker layers stay on disk).
    *   Direct access to your local network (LAN) for deployment.

### ⚙️ How to Control (runs-on)
It is **NOT** automatic. You explicitly tell GitHub where to run each job in your `.github/workflows/ci.yml` file using the `runs-on` keyword.

| Value | Meaning | Description |
| :--- | :--- | :--- |
| `runs-on: ubuntu-latest` | **GitHub Cloud** | Runs on GitHub's Azure servers. Good for linting, building, testing. (Free tier limits apply). |
| `runs-on: self-hosted` | **Your Server** | Runs on your Raspberry Pi. Essential for **Deploy** jobs that need to reach your internal network. |

**Example:**
```yaml
jobs:
  lint:
    runs-on: ubuntu-latest  # ☁️ Runs on Cloud
    steps: ...

  deploy:
    runs-on: self-hosted    # 🏠 Runs on your Pi
    steps: ...
```

## Installation

1.  **Get a Token**:
    *   Go to GitHub Repo -> Settings -> Actions -> Runners -> New self-hosted runner.
    *   Copy the **Token** shown in the "Configure" section.

2.  **Run the script**:
    ```bash
    chmod +x install.sh
    ./install.sh https://github.com/nguyenvanphuc0497/HomeLab <YOUR_TOKEN> raspi4-runner
    ```

3.  **Start the service**:
    ```bash
    cd actions-runner
    sudo ./svc.sh start
    ```

## Post-Install verification
Go to GitHub Repo -> Settings -> Actions -> Runners. You should see `raspi4-runner` (Active).
