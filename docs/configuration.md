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

# ⚙️ Configuration Guide

This guide explains all configuration options available in `config.lua`.

## 📋 Table of Contents

1. [Server Information](#server-information)
2. [Framework Configuration](#framework-configuration)
3. [Book System Settings](#book-system-settings)
4. [Durability & Usage](#durability--usage)
5. [Job Restrictions](#job-restrictions)
6. [Security Settings](#security-settings)
7. [Performance Options](#performance-options)
8. [Notifications & UI](#notifications--ui)
9. [Debug Mode](#debug-mode)

---

## 🏢 Server Information

```lua
Config.ServerInfo = {
    name = 'The Land of Wolves 🐺',
    tagline = 'Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!',
    description = 'ისტორია ცოცხლდება აქ!',
    type = 'Serious Hardcore Roleplay',
    -- ... more fields
}
```

**Purpose:** Branding information displayed in startup banner.

**Customization:** Change these values to match your server's identity.

---

## 🔧 Framework Configuration

### Auto-Detection (Recommended)

```lua
Config.Framework = 'auto'
```

The resource will automatically detect:
1. LXR-Core (Priority 1)
2. RSG-Core (Priority 2)
3. VORP Core (Priority 3)
4. Standalone (Fallback)

### Manual Override

```lua
Config.Framework = 'lxr-core'  -- or 'rsg-core', 'vorp_core', 'standalone'
```

Use manual mode if auto-detection fails or you want to force a specific framework.

### Framework Settings

```lua
Config.FrameworkSettings = {
    ['lxr-core'] = {
        resource = 'lxr-core',
        notifications = 'ox_lib',
        inventory = 'lxr-inventory',
        events = {
            server = 'lxr-core:server:%s',
            client = 'lxr-core:client:%s',
            callback = 'lxr-core:callback:%s'
        }
    },
    -- ... other frameworks
}
```

**Purpose:** Defines framework-specific resource names, notification systems, and event patterns.

**Customization:** Modify if you use custom framework builds with different naming.

---

## 📚 Book System Settings

```lua
Config.BookItemName = "lxr_book"
```
**Purpose:** The inventory item name for books.
**Must Match:** Your database item entry exactly.

```lua
Config.MaxPages = 50
```
**Purpose:** Maximum pages allowed per book.
**Recommended:** 20-50 pages (balance between content and performance).
**Impact:** More pages = more metadata storage.

---

## 🛡️ Durability & Usage

```lua
Config.BookMaxDurability = 31
```
**Purpose:** Total uses for a fresh book.
**Note:** Binding counts as +1 use.
**Example:** 31 durability = binding + 30 reads.

```lua
Config.BookUseCost = 1
```
**Purpose:** Durability consumed per read.
**Recommendation:** Keep at 1 for standard wear.
**Advanced:** Set to 0 for unlimited uses (not recommended for roleplay balance).

---

## 🔒 Job Restrictions

```lua
Config.BuilderJobLock = true
```
**Purpose:** Enable job-based access control for `/bookbuilder` command.
**Values:**
- `true` - Only allowed jobs can create books
- `false` - Anyone can create books

```lua
Config.BuilderAllowedJobs = {
    "sheriff",
    "marshal",
    "curandeiro",
    "governo",
    "admin"
}
```
**Purpose:** List of jobs allowed to use book builder.
**Customization:** Add/remove jobs based on your roleplay setup.
**Example Use Cases:**
- `"sheriff"` - Law enforcement reports
- `"doctor"` - Medical journals
- `"priest"` - Religious texts
- `"journalist"` - Newspapers

---

## 🔐 Security Settings

### Enable Security

```lua
Config.Security.enabled = true
```
**Purpose:** Master switch for all security features.
**Recommendation:** Always keep `true` on production servers.

### URL Validation

```lua
Config.Security.validateUrls = true
```
**Purpose:** Validate image URLs before accepting them.

```lua
Config.Security.maxUrlLength = 500
```
**Purpose:** Maximum characters allowed in image URLs.

```lua
Config.Security.allowedImageHosts = {
    'i.imgur.com',
    'cdn.discordapp.com',
    'media.discordapp.net',
    'i.postimg.cc',
    'postimg.cc'
}
```
**Purpose:** Whitelist of allowed image hosting domains.
**Why:** Prevents malicious or inappropriate content from untrusted sources.
**Customization:** Add your trusted image hosts here.

### Rate Limiting

```lua
Config.Security.rateLimitBinds = true
```
**Purpose:** Prevent spam book creation.

```lua
Config.Security.maxBindsPerMinute = 5
```
**Purpose:** Maximum books a player can bind per minute.
**Recommendation:** 3-5 for normal use.

### Exploit Protection

```lua
Config.Security.logSuspiciousActivity = true
```
**Purpose:** Log potential exploits to console.

```lua
Config.Security.kickOnExploit = false
Config.Security.banOnExploit = false
```
**Purpose:** Automatic punishment for detected exploits.
**Recommendation:** Keep `false` initially, enable after testing.

---

## ⚡ Performance Options

```lua
Config.Performance.cacheBooks = true
```
**Purpose:** Cache book data on client for faster loading.

```lua
Config.Performance.maxCachedBooks = 10
```
**Purpose:** Maximum books to cache per player.

```lua
Config.Performance.cleanupInterval = 600000
```
**Purpose:** Cleanup old data every 10 minutes (in milliseconds).
**Value:** 600000 ms = 10 minutes.

```lua
Config.Performance.preloadImages = false
```
**Purpose:** Preload all book images when opening viewer.
**Warning:** May cause lag on first open. Recommended: `false`.

---

## 🔔 Notifications & UI

```lua
Config.Notifications = {
    position = 'top-right',
    duration = 5000,
    showIcon = true
}
```

**Options:**
- `position`: Notification position on screen
- `duration`: How long notifications stay visible (milliseconds)
- `showIcon`: Show icons in notifications (if supported)

---

## 🌐 Language Configuration

```lua
Config.Lang = 'en'  -- 'en' or 'ge'
```

**Available Languages:**
- `en` - English
- `ge` - Georgian (ქართული)

**Adding New Languages:**
1. Create `/locales/[lang].lua` (e.g., `/locales/es.lua` for Spanish)
2. Copy structure from `en.lua`
3. Translate all strings
4. Set `Config.Lang = 'es'`

---

## 🐛 Debug Mode

```lua
Config.Debug = false
```

**Purpose:** Enable detailed console logging.

**When to Use:**
- Troubleshooting issues
- Development
- Testing new features

**Output Example:**
```
[LXR-Book Debug] Opening book builder
[LXR-Book Debug] Saving book: My Title
[LXR-Book Debug] Book saved: My Title (ID: book_1738717200_1234)
```

**Recommendation:** Keep `false` on production servers (performance impact).

---

## 📝 Configuration Best Practices

### Security First
✅ Always keep `Config.Security.enabled = true`  
✅ Use URL validation and whitelisting  
✅ Enable rate limiting  
✅ Monitor logs for suspicious activity  

### Performance Balance
✅ Set reasonable max pages (20-50)  
✅ Enable caching for frequently read books  
✅ Use cleanup intervals to prevent memory bloat  
✅ Avoid preloading images unless necessary  

### Roleplay Balance
✅ Restrict book creation to appropriate jobs  
✅ Set realistic durability values  
✅ Consider the economic impact of book creation  
✅ Use books for meaningful content  

### Testing Workflow
1. Set `Config.Debug = true`
2. Set `Config.BuilderJobLock = false`
3. Test all features
4. Check console for errors
5. Re-enable security before production
6. Set `Config.Debug = false`

---

## 📞 Support

Need help with configuration?

- **Discord:** https://discord.gg/CrKcWdfd3A
- **Documentation:** https://www.wolves.land
- **GitHub:** https://github.com/iboss21/lxr-book

═══════════════════════════════════════════════════════════════════════════════
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
═══════════════════════════════════════════════════════════════════════════════
