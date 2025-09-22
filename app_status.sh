#!/bin/bash

# ===============================
# Application Uptime Checker
# ===============================

# URL of the application to check
APP_URL="$1"

# Log file
LOG_FILE="$HOME/app_status.log"

# Function to log messages
log_status() {
    local status="$1"
    local msg="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $status - $msg" | tee -a "$LOG_FILE"
}

# Check if URL is provided
if [ -z "$APP_URL" ]; then
    echo "Usage: $0 <application_url>"
    exit 1
fi

# Get HTTP status code using curl
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" "$APP_URL")

# Determine status
if [[ "$HTTP_CODE" =~ ^2|3 ]]; then
    # 2xx or 3xx means application is UP
    log_status "UP" "Application at $APP_URL is responding with HTTP $HTTP_CODE"
    exit 0
else
    # 4xx or 5xx or no response means DOWN
    log_status "DOWN" "Application at $APP_URL is not responding properly. HTTP $HTTP_CODE"
    exit 1
fi

