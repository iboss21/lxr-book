--[[
    🐺 LXR Book - Security Guide
    © 2026 iBoss21 / The Lux Empire | wolves.land
]]

# 🔒 Security Guide

## Overview

LXR Book System implements multiple security layers to prevent exploits and abuse.

## Security Features

### 1. Job-Based Access Control
- `/bookbuilder` command restricted to authorized jobs
- Configurable job whitelist
- Server-side permission validation

### 2. URL Validation
- Whitelist of allowed image hosting domains
- Maximum URL length enforcement
- Server-side validation before storage

### 3. Rate Limiting
- Prevents spam book creation
- Configurable limits per player
- Per-minute tracking

### 4. Input Validation
- Title length limits
- Page count limits
- URL format validation
- Metadata sanitization

### 5. Server-Side Authority
- All rewards/items controlled server-side
- No client trust for game-changing actions
- Validation of all client requests

## Security Configuration

```lua
Config.Security = {
    enabled = true,
    validateUrls = true,
    maxTitleLength = 100,
    maxUrlLength = 500,
    requireValidImages = true,
    allowedImageHosts = {
        'i.imgur.com',
        'cdn.discordapp.com',
        'media.discordapp.net',
        'i.postimg.cc'
    },
    rateLimitBinds = true,
    maxBindsPerMinute = 5,
    logSuspiciousActivity = true
}
```

## Best Practices

1. ✅ Always keep `Config.Security.enabled = true`
2. ✅ Use URL whitelisting
3. ✅ Enable rate limiting
4. ✅ Monitor logs for suspicious activity
5. ✅ Regular security audits
6. ✅ Keep framework updated

═══════════════════════════════════════════════════════════════════════════════
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
═══════════════════════════════════════════════════════════════════════════════
