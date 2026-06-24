# GitHub CI/CD Setup & Rule Deployment
The GitHub Actions setup uses a self-hosted runner to automatically update the Wazuh custom rules file on the Ubuntu VM

## GitHub CI/CD Setup
1. **Configure Self-Hosted Runner:** Navigate to `Settings > Actions > Runners` in your GitHub repository and follow the "New self-hosted runner" instructions. Ensure the runner is tagged with `wazuh`.
2. **Add Repository Secrets:** Configure the following secrets in `Settings > Secrets and variables > Actions`:
    - `SSH_PRIVATE_KEY`: Private key for SSH access to the Wazuh VM.
    - `WAZUH_VM_IP`: The IP address of the Ubuntu VM.
    - `WAZUH_VM_USER`: The username for SSH authentication.
3. **Copy the Deployment Script:** Manually transfer the script located at `scripts/deploy-wazuh-rules.sh` to the Wazuh VM and make it executable. You can do this from your local machine using the following commands (replace the variables with your actual VM IP and SSH user):
    ```bash
    # 1. Copy the file to the VM's temporary directory
    scp scripts/deploy-wazuh-rules.sh your_ci_user@<WAZUH_VM_IP>:/tmp/
    
    # 2. Move it to the correct restricted path, set ownership to root, and make it executable
    ssh your_ci_user@<WAZUH_VM_IP> "sudo mv /tmp/deploy-wazuh-rules.sh /usr/local/bin/ && sudo chown root:root /usr/local/bin/deploy-wazuh-rules.sh && sudo chmod +x /usr/local/bin/deploy-wazuh-rules.sh"
    ```
4. **Configure NOPASSWD Sudo Access:** The pipeline SSH user requires passwordless `sudo` access to run the deployment script. On the Wazuh VM, run `sudo visudo` and append the following line (replace `your_ci_user` with the value of `WAZUH_VM_USER`):
    ```text
    your_ci_user ALL=(ALL) NOPASSWD: /usr/local/bin/deploy-wazuh-rules.sh
    ```

## Automated Rule Deployment Pipeline
The CI/CD pipeline (found in `.github/workflows/deploy-rules.yml`) automatically deploys files from the `custom_rules/` directory to the Wazuh rules folder.

1. **Trigger:** Push to `main` branch affecting `custom_rules/**`.
2. **Validation:** The pipeline creates a temporary file under the rules folder and validates it using `/var/ossec/bin/wazuh-analysisd -t` to detect syntax errors.
3. **Deployment:** Once validation passes, the temp file replaces the custom rule file `/var/ossec/etc/rules/local_rules.xml`. The `wazuh-manager` service is then restarted and its status is checked afterwards.
