--[[
    ██╗     ██╗  ██╗██████╗       ██████╗  ██████╗  ██████╗ ██╗  ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██╔═══██╗██╔═══██╗██║ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║   ██║██║   ██║█████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██╗██║   ██║██║   ██║██╔═██╗ 
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝╚██████╔╝╚██████╔╝██║  ██╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
    
    🐺 The Land of Wolves - LXR Book System
    © 2026 iBoss21 / The Lux Empire | wolves.land
]]

# 🔌 Framework Support & Adapter

## 📋 Overview

LXR Book System uses a **unified adapter pattern** to support multiple frameworks seamlessly. This allows the core gameplay logic to remain framework-agnostic while providing full integration with framework-specific features.

## 🎯 Supported Frameworks

### Primary Support (Tier 1)

#### LXR-Core
- **Status:** ✅ Full Support
- **Resource Name:** `lxr-core`
- **Priority:** 1
- **Features:**
  - Player data integration
  - Job system integration
  - Inventory integration
  - Notification system (ox_lib)
  - Callback system

#### RSG-Core
- **Status:** ✅ Full Support
- **Resource Name:** `rsg-core`
- **Priority:** 2
- **Features:**
  - Player data integration
  - Job system integration
  - Inventory integration
  - Notification system (ox_lib)
  - Callback system

### Supported (Tier 2)

#### VORP Core
- **Status:** ✅ Supported
- **Resource Name:** `vorp_core`
- **Priority:** 3
- **Features:**
  - Basic player data
  - Job system
  - Inventory integration
  - VORP notifications
  - Manual callback implementation

### Fallback

#### Standalone
- **Status:** ⚠️ Limited Functionality
- **Use Case:** Testing or non-framework servers
- **Features:**
  - Print-based notifications
  - No inventory integration
  - No job restrictions
  - Basic functionality only

---

## 🔄 Auto-Detection System

### How It Works

The framework adapter automatically detects the running framework on resource start:

```lua
-- Detection Priority Order:
1. LXR-Core (lxr-core resource)
2. RSG-Core (rsg-core resource)
3. VORP Core (vorp_core resource)
4. Standalone (fallback)
```

### Configuration

```lua
-- Automatic (Recommended)
Config.Framework = 'auto'

-- Manual Override
Config.Framework = 'lxr-core'  -- or 'rsg-core', 'vorp_core', 'standalone'
```

**When to use manual mode:**
- Auto-detection fails
- Multiple frameworks installed
- Testing specific framework behavior

---

## 🏗️ Adapter Architecture

### Unified API Functions

The adapter provides these framework-agnostic functions:

#### Server-Side Functions

```lua
-- Get player object
Framework.GetPlayer(source)

-- Get player identifier
Framework.GetIdentifier(source)

-- Get player job
Framework.GetJob(source)

-- Add item to inventory
Framework.AddItem(source, item, amount, metadata)

-- Remove item from inventory
Framework.RemoveItem(source, item, amount, metadata)

-- Get item metadata
Framework.GetItemMetadata(source, item, slot)

-- Create server callback
Framework.CreateCallback(name, callback)
```

#### Client-Side Functions

```lua
-- Get player data
Framework.GetPlayerData()

-- Get player job
Framework.GetJob()

-- Check if player is loaded
Framework.IsPlayerLoaded()

-- Trigger server callback
Framework.TriggerCallback(name, callback, ...)

-- Send notification
Framework.Notify(message, type, duration)
```

### Example Usage

```lua
-- Core logic remains the same across frameworks
local job = Framework.GetJob(source)

if job == 'sheriff' then
    Framework.AddItem(source, 'badge', 1)
    Framework.Notify('You received a badge', 'success')
end
```

The adapter automatically translates these calls to framework-specific implementations.

---

## 🔧 Framework-Specific Implementations

### LXR-Core

```lua
-- Server
function Framework.GetPlayer(source)
    local LXRCore = exports['lxr-core']:GetCoreObject()
    return LXRCore.Functions.GetPlayer(source)
end

-- Client
function Framework.GetPlayerData()
    local LXRCore = exports['lxr-core']:GetCoreObject()
    return LXRCore.Functions.GetPlayerData()
end
```

**Events:**
- `LXRCore:Client:OnPlayerLoaded`
- `LXRCore:Client:OnPlayerUnload`
- `lxr-core:client:UseItem`

### RSG-Core

```lua
-- Server
function Framework.GetPlayer(source)
    local RSGCore = exports['rsg-core']:GetCoreObject()
    return RSGCore.Functions.GetPlayer(source)
end

-- Client
function Framework.GetPlayerData()
    local RSGCore = exports['rsg-core']:GetCoreObject()
    return RSGCore.Functions.GetPlayerData()
end
```

**Events:**
- `RSGCore:Client:OnPlayerLoaded`
- `RSGCore:Client:OnPlayerUnload`
- `rsg-core:client:UseItem`

### VORP Core

```lua
-- Server
function Framework.GetPlayer(source)
    local VORPcore = exports.vorp_core:GetCore()
    return VORPcore.getUser(source).getUsedCharacter
end

-- Notifications
TriggerEvent('vorp:TipRight', message, duration)
```

**Events:**
- `vorp:SelectedCharacter`
- `vorp:use:lxr_book`

---

## 📦 Item Integration

### Item Registration

Books use a single inventory item: `lxr_book`

#### LXR-Core / RSG-Core

```sql
INSERT INTO `items` 
(`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `metadata`, `description`, `weight`)
VALUES
('lxr_book', 'Book', 10, 1, 'item_standard', 1, '{}', 'A book that can be read', 0.25);
```

#### VORP

```sql
INSERT INTO `items` 
VALUES (NULL, 'lxr_book', 'Book', 10, 1, 1, 1, 0.25, NULL, 'item_standard', '{}', 'A book that can be read', 0, NULL);
```

### Item Usage

When a player uses a book item:

```lua
-- LXR/RSG
RegisterNetEvent('lxr-core:client:UseItem')
AddEventHandler('lxr-core:client:UseItem', function(item)
    if item.name == 'lxr_book' then
        -- Open book viewer
    end
end)

-- VORP
RegisterNetEvent('vorp:use:lxr_book')
AddEventHandler('vorp:use:lxr_book', function()
    -- Open book viewer
end)
```

---

## 🔔 Notification Systems

### ox_lib (LXR/RSG)

```lua
exports['ox_lib']:notify({
    description = message,
    type = type,
    duration = duration
})
```

### VORP

```lua
TriggerEvent('vorp:TipRight', message, duration)
```

### Standalone

```lua
print('[LXR-Book] ' .. message)
```

---

## 🎯 Job System Integration

### How Jobs Are Checked

```lua
-- Get player's job
local job = Framework.GetJob(source)

-- Check if job is allowed
for _, allowedJob in ipairs(Config.BuilderAllowedJobs) do
    if job == allowedJob then
        -- Player has permission
    end
end
```

### Framework Differences

**LXR/RSG:**
```lua
PlayerData.job.name  -- e.g., "sheriff"
```

**VORP:**
```lua
Character.job  -- e.g., "sheriff"
```

---

## 📊 Metadata Storage

Book data is stored in item metadata (framework-agnostic):

```lua
metadata = {
    title = "Sheriff's Manual",
    pages = {
        {url = "https://i.imgur.com/page1.png"},
        {url = "https://i.imgur.com/page2.png"},
        {url = "https://i.imgur.com/page3.png"}
    },
    durability = 28,
    maxDurability = 31,
    description = "A book titled: Sheriff's Manual"
}
```

This ensures:
- ✅ **Portability** - Books can be traded
- ✅ **Persistence** - Books survive config changes
- ✅ **Offline-safe** - Works without creator online

---

## 🔍 Debug & Testing

### Enable Debug Mode

```lua
Config.Debug = true
```

### Console Output

```
[LXR-Book] Framework detected: lxr-core
[LXR-Book] Framework adapter initialized: lxr-core
[LXR-Book Debug] Opening book builder
[LXR-Book Debug] Saving book: Test Book
```

### Testing Each Framework

1. Set `Config.Framework = 'lxr-core'`
2. Restart resource
3. Test book creation
4. Test item usage
5. Repeat for each framework

---

## 🚀 Adding New Frameworks

To add support for a new framework:

1. **Add Framework Settings:**
```lua
Config.FrameworkSettings['myframework'] = {
    resource = 'myframework',
    notifications = 'ox_lib',
    inventory = 'myinventory'
}
```

2. **Update Detection:**
```lua
elseif GetResourceState('myframework') == 'started' then
    Framework.ActiveFramework = 'myframework'
```

3. **Implement Adapter Functions:**
```lua
if Framework.ActiveFramework == 'myframework' then
    -- Implementation here
end
```

4. **Test Thoroughly**

---

## 📞 Support

Framework integration issues?

- **Discord:** https://discord.gg/CrKcWdfd3A
- **GitHub Issues:** https://github.com/iboss21/lxr-book/issues

═══════════════════════════════════════════════════════════════════════════════
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
═══════════════════════════════════════════════════════════════════════════════
