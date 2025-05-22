#!/bin/bash

# ==== Configuration ====
API_TOKEN=""     # Replace with your API token
PROJECT_KEY=""              # Replace with your LaunchDarkly project key
ENVIRONMENT="test"                        # Choose environment: test, development, production, etc.
USE_EU=false               # Set to true to use EU endpoint, false for US endpoint

# List of flag keys to check
FLAGS=("")  # Replace with your actual flag keys

# Set base URL based on region
if [ "$USE_EU" = true ]; then
  BASE_URL="https://app.eu.launchdarkly.com"
else
  BASE_URL="https://app.launchdarkly.com"
fi

# ==== Iterate Over Flags ====
for FLAG_KEY in "${FLAGS[@]}"; do
  echo "Turning on flag in $ENVIRONMENT: $FLAG_KEY"

  # Turn on the flag in specified environment
  RESPONSE=$(curl -s -i \
    -H "Authorization: $API_TOKEN" \
    -H "Content-Type: application/json" \
    -H "Accept: application/json" \
    -X PATCH \
    -d '[{
      "op": "add",
      "path": "/environments/'$ENVIRONMENT'/on",
      "value": true
    }]' \
    "$BASE_URL/api/v2/flags/$PROJECT_KEY/$FLAG_KEY")

  # Split headers and body
  RESPONSE_HEADERS=$(echo "$RESPONSE" | sed -n '/^[[:space:]]*$/q;p')
  RESPONSE_BODY=$(echo "$RESPONSE" | sed '1,/^[[:space:]]*$/d')

  # Get current time in seconds
  CURRENT_TIME=$(date +%s)
  
  # Process each rate limit header
  echo "$RESPONSE_HEADERS" | grep -i 'X-Ratelimit' | while read -r line; do
    if [[ $line =~ ^[[:space:]]*x-ratelimit-(auth-token-)?reset: ]]; then
      # Extract the epoch milliseconds value and convert to seconds
      reset_time_ms=$(echo "$line" | sed -E 's/.*: *([0-9]+).*/\1/')
      # Convert milliseconds to seconds by dividing by 1000
      reset_time=$((reset_time_ms / 1000))
      # Calculate seconds remaining
      if [ $reset_time -gt $CURRENT_TIME ]; then
        seconds_remaining=$((reset_time - CURRENT_TIME))
        # Preserve the original header name
        if [[ $line =~ auth-token-reset ]]; then
          echo "  x-ratelimit-auth-token-reset: $seconds_remaining seconds remaining"
        else
          echo "  x-ratelimit-reset: $seconds_remaining seconds remaining"
        fi
      else
        # Preserve the original header name
        if [[ $line =~ auth-token-reset ]]; then
          echo "  x-ratelimit-auth-token-reset: 0 seconds remaining"
        else
          echo "  x-ratelimit-reset: 0 seconds remaining"
        fi
      fi
    else
      # Print other rate limit headers as is
      echo "  $line"
    fi
  done

  # Print the response body
  echo "Response:"
  echo "$RESPONSE_BODY" | jq '.' 2>/dev/null || echo "$RESPONSE_BODY"
  echo
done 