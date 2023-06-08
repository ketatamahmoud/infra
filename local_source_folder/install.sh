#!/bin/bash

businessGroupId=$1
client_id=$2
client_secret=$3
envName=$4
nexusBaseAuth=$5
serverName=$6

print_separator() {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | sed "s/ /$(tput setaf 81)#$(tput sgr0)/g"
}

line=`printf '#%.0s' {1..200}`



echo_secret() {
  prefix=$(echo $1 | cut -c1-3)
  suffix_length=$(( ${#1} - 3 ))
  suffix=$(printf '%*s' "$suffix_length" '' | tr ' ' '*')
  masked="${prefix}${suffix}"
  echo $masked
}




echo_step() {

  print_separator
  echo -e "\e[38;2;141;191;65m$1($envName)\e[0m"
  print_separator

}
echo_success() {
  local message="$1....($envName)"
  local green='\033[0;32m'
  local bold='\033[1m'
  local reset='\033[0m'

  echo -e "${green}${bold}✓ Success:${reset} ${message}"
}
echo "businessGroupId => "echo_secret "$businessGroupId"
echo "client_id => "echo_secret "$client_id"
echo "client_secret => "echo_secret "$client_secret"
echo "envName => "echo_secret " $envName"
echo "nexusBaseAuth => "echo_secret "$nexusBaseAuth"
echo "serverName => "echo_secret "$serverName"

echo_step "Step 1: Installing dependencies..."

sudo apt update
sudo apt -y upgrade
sudo apt -y install curl
sudo apt -y install unzip
sudo apt -y install default-jdk
sudo apt -y install jq
sudo apt -y install curl
export JAVA_HOME=/usr/lib/jvm/java-11.0.18-openjdk-amd64

echo_step "Step 2: Get the accses token..."

response=$(curl -s -w "\n%{http_code}" -H 'Content-Type: application/json' -d '{ "client_id":"'$client_id'","client_secret":"'$client_secret'","grant_type":"client_credentials"}' -X POST https://anypoint.mulesoft.com/accounts/api/v2/oauth2/token)

# Extract the response body and HTTP status code
resonance=$(echo "$response" | sed '$d')
http_code=$(echo "$response" | tail -n 1)

# Check if the HTTP status code is numeric
if [[ $http_code =~ ^[0-9]+$ ]]; then
  # Check if the HTTP status code is 200 (OK)
  if [ "$http_code" -eq 200 ]; then
    access_token=$(echo "$resonance" | jq -r '.access_token')
    echo "access_token => "echo_secret "$access_token"
    echo_success "Step 2: Get the accses token..."
  else
    echo "Error: HTTP status $http_code"
    echo "$resonance"
    exit 1
  fi
else
  echo "Error: Invalid HTTP status code: $http_code"
  echo "$resonance"
  exit 1
fi
echo_step "Step 3: Get the envId..."

response=$(curl -s -w "\n%{http_code}" -X GET "https://anypoint.mulesoft.com/accounts/api/organizations/$businessGroupId/environments" -H "authorization: bearer $access_token")

# Extract the response body and HTTP status code
resonance=$(echo "$response" | sed '$d')
http_code=$(echo "$response" | tail -n 1)

# Check if the HTTP status code is numeric
if [[ $http_code =~ ^[0-9]+$ ]]; then
  # Check if the HTTP status code is 200 (OK)
  if [ "$http_code" -eq 200 ]; then
    envId=$(echo "$resonance" | jq --arg envName "$envName" '.data[] | select((.name | ascii_upcase)==($envName | ascii_upcase)) | .id')
    envId=$(echo $envId | tr -d '"')
    echo "envId => "echo_secret "$envId"
    echo_success "Step 3: Get the envId..."
  else
    echo "Error: HTTP status $http_code"
    echo "$resonance"
    exit 1
  fi
else
  echo "Error: HTTP status $http_code"
  echo "$resonance"
  exit 1
fi
echo_step "Step 4: Get the serverToken..."

response=$(curl -s -w "\n%{http_code}" -X GET https://anypoint.mulesoft.com/hybrid/api/v1/servers/registrationToken -H "authorization: bearer $access_token" -H "x-anypnt-env-id:$envId" -H "x-anypnt-org-id:$businessGroupId")

# Extract the response body and HTTP status code
resonance=$(echo "$response" | sed '$d')
http_code=$(echo "$response" | tail -n 1)

# Check if the HTTP status code is numeric
if [[ $http_code =~ ^[0-9]+$ ]]; then
  # Check if the HTTP status code is 200 (OK)
  if [ "$http_code" -eq 200 ]; then
    serverToken=$(echo $resonance | jq -r '.data')
    echo "server Token=> "$(echo_secret "$serverToken")
    echo_success "Step 4: Get the serverToken..."
  else
    echo "Error: HTTP status $http_code"
    echo "$resonance"
    exit 1
  fi
else
  echo "Error: Invalid HTTP status code: $http_code"
  echo "$resonance"
  exit 1
fi

echo_step "Step 5: Downloading muleruntime..."

curl -H 'Authorization: Basic '$nexusBaseAuth -O http://20.19.191.220:8081/repository/mulesoft/runtime/mule-enterprise-standalone-4.4.0-20230217.zip

echo_step "Step 6: Extracting muleruntime..."

sudo unzip -o mule-enterprise-standalone-4.4.0-20230217.zip

#sudo mv mule-enterprise-standalone-4.4.0-20230217.zip muleruntime
echo_step "Step 7: Setting up Anypoint Management Center (AMC)..."
UUID=$(sudo dmidecode | grep UUID | awk '{print $2}')
SUB_UUID=$(echo $UUID | cut -c10-17)
serverName="$serverName-$SUB_UUID"
echo $serverName

sudo ./mule-enterprise-standalone-4.4.0-20230217/bin/amc_setup -H $serverToken $serverName
echo_step "Step 8: Starting Mule Runtime..."

sudo ./mule-enterprise-standalone-4.4.0-20230217/bin/mule start
# Command to be executed on startup

echo_step "Step 9: Configuring startup command..."

# Create the systemd service unit file
service_file="/etc/systemd/system/startup_command.service"
cat <<EOT > "$service_file"
[Unit]
Description=<project description>

[Service]
User=root
WorkingDirectory=/home/mahmoud/mule-enterprise-standalone-4.4.0-20230217/bin
ExecStart=/bin/bash -c ./mule start
Restart=always

[Install]
WantedBy=multi-user.target


EOT

# Reload the systemd daemon
sudo systemctl daemon-reload

# Start the service
sudo systemctl start startup_command.service

# Enable the service
sudo systemctl enable startup_command.service

# Check the service status

echo_success "Startup command has been configured."

# Reboot the system

exit 0