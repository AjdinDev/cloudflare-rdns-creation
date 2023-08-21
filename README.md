# Cloudflare rDNS Record Automation Script

This script is designed to automate the process of creating `A` records within Cloudflare for a specified IPv4 range. The primary use case is for creating rDNS entries, but it can be adapted for various other DNS needs.

## Features

- Generate and create `A` records for IPs within a given range.
- Dynamically create rDNS format based on provided `BASE_IP`.
- Dry-run mode available to preview operations without committing any changes.
- Utilizes Cloudflare's API tokens for authentication.

## Pre-requisites

1. **jq**: A lightweight and flexible command-line JSON processor.
   - Installation (Ubuntu/Debian): `sudo apt install jq`
   - Installation (macOS): `brew install jq`

2. A Cloudflare API token with permissions to create DNS records for desired domain.

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/AjdinDev/cloudflare-rdns-creation.git
   ```

2. Navigate to the repository directory:
   ```bash
   cd cloudflare-rdns-creation
   ```

3. Make the script executable:
   ```bash
   chmod +x script.sh
   ```

4. Edit the script:
   - Add your Cloudflare API token and zone ID.
   - Set the `BASE_IP` variable to the first three octets of your IP range.
   - Adjust the IP range by changing the loop range (default is `{0..255}` for a /24 subnet).

5. Run the script:
   - Dry run (no changes will be made):
     ```bash
     ./script.sh --dry-run
     ```
   - Actual run:
     ```bash
     ./script.sh
     ```

## Adjusting the IP Range

By default, the script is set to work with a /24 subnet, meaning it will generate and create records for all IPs from `x.x.x.0` to `x.x.x.255`. If you need to work with a different range, adjust the loop in the script. For example, `{0..15}` will cover IPs from `x.x.x.0` to `x.x.x.15`.

## Safety and Security

- **Never hard-code API tokens** in scripts or code. Instead, consider using environment variables or configuration files to manage secrets.
- Always run the script in dry-run mode first to ensure that the expected operations match your intent.

## Contributions

Contributions are welcome! If you found a bug, want to propose a feature, or feel the urge to refactor some code, please feel free to do so.
