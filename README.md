# LaunchDarkly API Rate Limit Testing

This is a test project to monitor and understand the rate limits of LaunchDarkly API calls and their reset times. The project consists of three Bash scripts that interact with the LaunchDarkly API to check flag states and toggle flags on/off.

**Note:** The rate limit values shown in the examples below are purely for demonstration purposes. LaunchDarkly does not publish nor guarantee specific rate limits, as these may vary based on your account type and usage patterns.

## Scripts

### 1. ratelimitget.sh
Retrieves the current state of a flag and displays rate limit information.

**Expected Output:**
```
Checking flag: your-flag-key
  x-ratelimit-auth-token-limit: 1000
  x-ratelimit-auth-token-remaining: 994
  x-ratelimit-auth-token-reset: 3 seconds remaining
  x-ratelimit-reset: 3 seconds remaining
  x-ratelimit-route-limit: 5
  x-ratelimit-route-remaining: 0
Response:
{
  "name": "Your Flag",
  "key": "your-flag-key",
  "environments": {
    "test": {
      "on": true,
      ...
    }
  }
  ...
}
```

### 2. ratelimitoff.sh
Turns off a flag in a specified environment and displays rate limit information.

**Expected Output:**
```
Turning off flag in test: your-flag-key
  x-ratelimit-auth-token-limit: 1000
  x-ratelimit-auth-token-remaining: 994
  x-ratelimit-auth-token-reset: 3 seconds remaining
  x-ratelimit-reset: 3 seconds remaining
  x-ratelimit-route-limit: 5
  x-ratelimit-route-remaining: 0
Response:
{
  "name": "Your Flag",
  "key": "your-flag-key",
  "environments": {
    "test": {
      "on": false,
      ...
    }
  }
  ...
}
```

### 3. ratelimiton.sh
Turns on a flag in a specified environment and displays rate limit information.

**Expected Output:**
```
Turning on flag in test: your-flag-key
  x-ratelimit-auth-token-limit: 1000
  x-ratelimit-auth-token-remaining: 994
  x-ratelimit-auth-token-reset: 3 seconds remaining
  x-ratelimit-reset: 3 seconds remaining
  x-ratelimit-route-limit: 5
  x-ratelimit-route-remaining: 0
Response:
{
  "name": "Your Flag",
  "key": "your-flag-key",
  "environments": {
    "test": {
      "on": true,
      ...
    }
  }
  ...
}
```

## Configuration

Before using the scripts, you need to configure:

1. `API_TOKEN`: Your LaunchDarkly API token
2. `PROJECT_KEY`: Your LaunchDarkly project key
3. `FLAGS`: Array of flag keys to check/modify
4. `ENVIRONMENT` (for ratelimitoff.sh and ratelimiton.sh): The environment to modify (test, development, production, etc.)

Example configuration:
```bash
API_TOKEN="your-api-token"
PROJECT_KEY="your-project-key"
FLAGS=("flag1" "flag2")
ENVIRONMENT="test"
```

## Rate Limit Headers

The scripts process and display several types of rate limit headers:

1. Authentication Token Rate Limits:
   - `x-ratelimit-auth-token-limit`: Total number of requests allowed
   - `x-ratelimit-auth-token-remaining`: Number of requests remaining
   - `x-ratelimit-auth-token-reset`: Time until the token rate limit resets

2. General API Rate Limits:
   - `x-ratelimit-reset`: Time until the general API rate limit resets

3. Route-specific Rate Limits:
   - `x-ratelimit-route-limit`: Total number of requests allowed for this route
   - `x-ratelimit-route-remaining`: Number of requests remaining for this route

All time-based limits are displayed in seconds remaining.

## Usage

1. Make the scripts executable:
```bash
chmod +x ratelimitget.sh ratelimitoff.sh ratelimiton.sh
```

2. Run the scripts:
```bash
./ratelimitget.sh  # Check flag state
./ratelimitoff.sh  # Turn flag off
./ratelimiton.sh   # Turn flag on
```

## Requirements

- Bash
- curl
- jq (for JSON formatting) 