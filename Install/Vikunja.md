## Summary

Vikunja is a free task and project management system. 
## Setup

To deploy a **Vikunja** instance using a bare-metal/virtual machine installation with **PostgreSQL** (and no Docker), you must configure a dedicated system user, set up the PostgreSQL database, structure the application environment, and manage the execution using a `systemd` service. [1](https://ramnode.com/guides/vikunja), [2](https://blog.stackademic.com/self-hosting-vikunja-board-project-on-a-raspberry-pi-the-right-way-192fd93d39b5)

Because Vikunja ships as a single compiled Go binary containing both the frontend and backend, the process is direct and highly efficient. [1](https://vikunja.io/changelog/whats-new-in-vikunja-0.23.0/), [2](https://ramnode.com/guides/vikunja), [3](https://community.vikunja.io/t/install-on-normal-hosting-environment-possible/3360)

### Step 1: Provision the PostgreSQL Database

Log into your existing PostgreSQL server or local instance to create a dedicated user and database database. [1](https://community.vikunja.io/t/db-migration-failed-when-setting-up-in-a-container-on-an-aws-ec2-instance-with-aws-rds-postgres-db/4303)

```bash
# Access the PostgreSQL interactive terminal as the superuser
sudo -u postgres psql
```

Execute the following SQL commands to build the backend layer:

```sql
-- Create a dedicated user for the application
CREATE USER vikunja WITH PASSWORD 'YourSecurePasswordHere';

-- Create the application database
CREATE DATABASE vikunja_db OWNER vikunja;

-- Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON DATABASE vikunja_db TO vikunja;

-- Exit the prompt
\q
```


### Step 2: Establish the System User and Directory Structure

Vikunja should never run as root. Set up an unprivileged system user (`vikunja`) and create the necessary directories for binary files, configurations, and user attachments. [1](https://community.vikunja.io/t/install-vikunja-from-binary-on-ubuntu-server/4353), [2](https://blog.stackademic.com/self-hosting-vikunja-board-project-on-a-raspberry-pi-the-right-way-192fd93d39b5), [3](https://vikunja.io/docs/systemd-hardening/), [4](https://webnestify.cloud/insights/open-source-solutions/vikunja-self-hosted-task-management/)

```bash
# Create a system user without a home directory or shell access
sudo useradd --system --no-create-home --shell /usr/sbin/nologin vikunja

# Build application, configuration, and file storage directories
sudo mkdir -p /opt/vikunja
sudo mkdir -p /etc/vikunja
sudo mkdir -p /var/lib/vikunja/files
```

### Step 3: Fetch and Install the Vikunja Binary

Download the latest pre-compiled architecture binary directly from the official repository. [1](https://blog.stackademic.com/self-hosting-vikunja-board-project-on-a-raspberry-pi-the-right-way-192fd93d39b5)

```bash
# Download the binary (Adjust URL matching your CPU architecture if needed)
curl -L -o vikunja https://vikunja.io

# Move the binary to the execution folder and make it executable
sudo mv vikunja /opt/vikunja/
sudo chmod +x /opt/vikunja/vikunja
```

Use code with caution.

---

Step 4: Configure the `config.yml` File

Create a new configuration file inside `/etc/vikunja/config.yml`: [1](https://community.vikunja.io/t/install-vikunja-from-binary-on-ubuntu-server/4353), [2](https://vikunja.io/docs/installing/)

bash

```
sudo nano /etc/vikunja/config.yml
```

Use code with caution.

Paste the following configurations into the file, modifying the `publicurl` and database credentials to align with your infrastructure: [1](https://community.vikunja.io/t/db-conversion-sqlite-to-postgresql/3421), [2](https://community.vikunja.io/t/db-migration-failed-when-setting-up-in-a-container-on-an-aws-ec2-instance-with-aws-rds-postgres-db/4303)

yaml

```
service:
  # The external URL where users will access your UI (Crucial for CORS validation)
  publicurl: "https://example.com"
  # Points where relative data assets should resolve
  rootpath: "/var/lib/vikunja/"

database:
  # Set database driver to postgres
  type: "postgres"
  host: "localhost:5432"
  user: "vikunja"
  password: "YourSecurePasswordHere"
  database: "vikunja_db"
  # Optional: set to "require" or "verify-full" if utilizing remote SSL database connections
  sslmode: "disable" 

files:
  # Absolute directory path where user task uploads/attachments live
  basepath: "/var/lib/vikunja/files"

log:
  enabled: true
  standard: stdout
  level: INFO
```

Use code with caution.

Fix Permissions across Directories

Assign the ownership of configurations and runtime file trees to the system user: [1](https://blog.stackademic.com/self-hosting-vikunja-board-project-on-a-raspberry-pi-the-right-way-192fd93d39b5)

bash

```bash
sudo chown -R vikunja:vikunja /etc/vikunja
sudo chown -R vikunja:vikunja /opt/vikunja
sudo chown -R vikunja:vikunja /var/lib/vikunja
```


### Step 5: Implement a `systemd` Service

To automate application lifecycle management and execute migrations safely during machine restarts, create a service definition file: [1](https://vikunja.io/docs/systemd-hardening/)

```bash
sudo nano /etc/systemd/system/vikunja.service
```

Insert the configuration below:

```toml
[Unit]
Description=Vikunja Task Management Instance
After=network.target postgresql.service
Wants=postgresql.service

[Service]
User=vikunja
Group=vikunja
WorkingDirectory=/var/lib/vikunja
ExecStart=/opt/vikunja/vikunja
Restart=always
RestartSec=5
Environment=TAGS=bindata

# Basic Systemd Security Hardening
ProtectSystem=full
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

Reload the system control unit, enable the daemon, and run the service: [1](https://vikunja.io/docs/plugins/)

```bash
sudo systemctl daemon-reload
sudo systemctl enable vikunja
sudo systemctl start vikunja
```

Use code with caution.

Verify that the process started without issue:

```bash
sudo systemctl status vikunja
```

> Note: Upon the very first initialization, Vikunja automatically queries PostgreSQL and runs database tables setup/migrations._ [1](https://vikunja.io/docs/docker-walkthrough/), [2](https://community.vikunja.io/t/docker-self-hosted-migration-failed-lookup-db-no-such-host-unable-to-find-the-ip-address-for-the-container-vikunja/3165), [3](https://lab.uberspace.de/guide_vikunja/)

### Step 6: Create Your Primary Administrator Account

Because open registrations might be undesirable or disabled initially, manually provision your master application account utilizing Vikunja's command-line binary interface: [1](https://ramnode.com/guides/vikunja), [2](https://webnestify.cloud/insights/open-source-solutions/vikunja-self-hosted-task-management/)

```bash
sudo -u vikunja /opt/vikunja/vikunja user create --username admin --email admin@example.com --password YourSuperSecretPassword
```

Use code with caution.

### Step 7: Handle Traffic Routing (Reverse Proxy)

Vikunja binds internally to port `3456`. To securely present it to clients externally over SSL/TLS, pass traffic through an edge router like **Caddy**


