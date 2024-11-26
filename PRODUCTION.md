# Running in Production

Set up environment variables:
```bash
sudo touch /etc/contract-service.env
sudo chmod 660 /etc/contract-service.env
sudo chown $USER:$USER /etc/contract-service.env
```

Change the file to what you require with your favorite editor:
```conf
# Change /etc/contract-service.env
DB_NAME=contract_service_prod
DB_USER=contract_service
DB_PASSWORD=YOUR_PASSWORD_HERE
DB_HOST=localhost
DB_PORT=5432
```

Now add it into your `.bashrc` or similar and source it:
```bash
echo "source /etc/contract-service.env" >> ~/.bashrc
source /etc/contract-service.env
```

Install PostgreSQL:
```bash
sudo pacman -S postgresql
sudo su -l postgres -c "initdb --locale=C.UTF-8 --encoding=UTF8 -D '/var/lib/postgres/data'"
sudo systemctl start postgresql.service
```

Setup Database and Database User:
```bash
sudo -u postgres psql <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
\q
EOF
```

Download the project and install its dependencies
```bash
sudo mkdir /opt/contract-service
sudo chown $USER:$USER /opt/contract-service
git clone https://github.com/cs-24-sw-3-15/contract-service.git /opt/contract-service
```

Install dependencies:
```bash
sudo pacman -S ruby ruby-erb ruby-bundler rake base-devel libyaml libvips mupdf tesseract-data-dan tesseract-data-eng nodejs
cd /opt/contract-service
bundle config set --local path vendor/bundle
bundle install
```

Set up DB
```bash
rm config/master.key config/credentials.yml.enc
EDITOR=nano bin/rails credentials:edit
bin/rails db:prepare
```

Then run the server to verify it starts in production mode:
```bash
bin/rails server
...
^C
```

Create the service file:
```service
# /etc/systemd/system/contract-service.service
[Unit]
Description=Contract Service
After=network.target postgresql.service
Requires=postgresql.service

[Service]
# User and group to run the service
User=YOUR_USER
Group=YOUR_GROUP

# Set the working directory
WorkingDirectory=/opt/contract-service

# Command to start the Rails application
ExecStart=/usr/bin/bundle exec puma -C config/puma.rb

# Environment variables
EnvironmentFile=/etc/contract-service.env

# Restart policy
Restart=always
RestartSec=5

# Security and hardening settings
ProtectSystem=strict
ProtectHome=true
ReadWritePaths=/opt/contract-service
PrivateTmp=true
CapabilityBoundingSet=~CAP_SYS_ADMIN CAP_NET_ADMIN CAP_SYS_RAWIO
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
```

Start and Enable the project
```bash
sudo systemctl daemon-reload
sudo systemctl enable --now contract-service
```
