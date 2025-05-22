# LaunchDarkly API Rate Limit Testing Scripts

This project contains a set of scripts designed to test and monitor the rate limits of LaunchDarkly API calls. The scripts help you understand the rate limits imposed by LaunchDarkly and when they reset.

> **Note**: The rate limit values shown in the examples are purely for demonstration purposes. LaunchDarkly does not publish or guarantee specific rate limits. These values may vary based on your account type and usage patterns.

## Scripts Overview

### 1. `ratelimitget.sh`
- **Purpose**: Retrieves the current state of specified feature flags
- **Expected Output**:
  ```
  Checking flag: your-flag-key
    x-ratelimit-auth-token-limit: 1000
    x-ratelimit-auth-token-remaining: 994
    x-ratelimit-auth-token-reset: 3 seconds remaining
    x-ratelimit-reset: 3 seconds remaining
    x-ratelimit-route-limit: 5
    x-ratelimit-route-remaining: 0
  Response:
  {flag details...}
  ```

### 2. `ratelimitoff.sh`
- **Purpose**: Turns off specified feature flags in a given environment
- **Expected Output**:
  ```
  Turning off flag in test: your-flag-key
    x-ratelimit-auth-token-limit: 1000
    x-ratelimit-auth-token-remaining: 994
    x-ratelimit-auth-token-reset: 3 seconds remaining
    x-ratelimit-reset: 3 seconds remaining
    x-ratelimit-route-limit: 5
    x-ratelimit-route-remaining: 0
  Response:
  {flag update confirmation...}
  ```

### 3. `ratelimiton.sh`
- **Purpose**: Turns on specified feature flags in a given environment
- **Expected Output**:
  ```
  Turning on flag in test: your-flag-key
    x-ratelimit-auth-token-limit: 1000
    x-ratelimit-auth-token-remaining: 994
    x-ratelimit-auth-token-reset: 3 seconds remaining
    x-ratelimit-reset: 3 seconds remaining
    x-ratelimit-route-limit: 5
    x-ratelimit-route-remaining: 0
  Response:
  {flag update confirmation...}
  ```

## Configuration

Each script requires the following configuration variables:

```bash
API_TOKEN=""              # Your LaunchDarkly API token
PROJECT_KEY=""           # Your LaunchDarkly project key
ENVIRONMENT="test"       # Environment to operate in (test, development, production, etc.)
USE_EU=false            # Set to true to use EU endpoint, false for US endpoint
FLAGS=("")              # Array of flag keys to operate on
```

## Rate Limit Headers

The scripts process and display three types of rate limit headers:

1. **Authentication Token Rate Limits**
   - `x-ratelimit-auth-token-limit`: Total requests allowed
   - `x-ratelimit-auth-token-remaining`: Remaining requests
   - `x-ratelimit-auth-token-reset`: Time until limit resets

2. **General API Rate Limits**
   - `x-ratelimit-reset`: Time until general rate limit resets

3. **Route-specific Rate Limits**
   - `x-ratelimit-route-limit`: Total requests allowed for specific route
   - `x-ratelimit-route-remaining`: Remaining requests for specific route

## Usage

1. Make the scripts executable:
   ```bash
   chmod +x ratelimitget.sh ratelimitoff.sh ratelimiton.sh
   ```

2. Configure the scripts with your LaunchDarkly credentials and flag keys

3. Run the desired script:
   ```bash
   ./ratelimitget.sh    # To check flag states
   ./ratelimitoff.sh    # To turn off flags
   ./ratelimiton.sh     # To turn on flags
   ```

## Requirements

- Bash shell
- `curl` for making HTTP requests
- `jq` for JSON formatting (optional, but recommended for better output formatting)

## Endpoints

The scripts support both US and EU LaunchDarkly endpoints:

- US Endpoint (default): `https://app.launchdarkly.com`
- EU Endpoint: `https://app.eu.launchdarkly.com`

To use the EU endpoint, set `USE_EU=true` in the script configuration. 