--[[
    🐺 LXR Book - Performance Guide
    © 2026 iBoss21 / The Lux Empire | wolves.land
]]

# ⚡ Performance Guide

## Overview

LXR Book System is optimized for minimal server and client impact.

## Performance Features

### Client-Side
- Efficient NUI rendering
- Minimal thread usage
- Event-driven architecture
- Cleanup routines

### Server-Side
- Lightweight callbacks
- Efficient data storage
- Periodic cleanup
- No database overhead (metadata storage)

## Configuration

```lua
Config.Performance = {
    cacheBooks = true,
    maxCachedBooks = 10,
    cleanupInterval = 600000,
    updateInterval = 100,
    preloadImages = false
}
```

## Optimization Tips

1. ✅ Limit max pages to 20-50
2. ✅ Enable caching
3. ✅ Use efficient image hosting
4. ✅ Compress images
5. ✅ Regular cleanup intervals

═══════════════════════════════════════════════════════════════════════════════
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
═══════════════════════════════════════════════════════════════════════════════
