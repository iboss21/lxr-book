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

# 📚 LXR Book System - Overview

## 🐺 Purpose

LXR Books is a complete book creation and reading system for RedM, built with full **LXRCore** and **rsg-core** integration. It allows authorized jobs to create, manage, and publish interactive books composed of image-based pages, which can then be bound to physical in-game items.

Each book becomes **fully self-contained** when bound, storing its pages directly in item metadata—ensuring books remain readable by any player, even if the original configuration is deleted or the creator is offline.

## ✨ Key Features

### 📚 Book Creation System
- **Job-restricted book builder** with full LXRCore and rsg-core integration
- Players can **create and manage multiple books**
- **Image-based pages** with configurable max limits
- **Visual editor** with page management
- **Save drafts** before binding to items

### 📕 Physical Book Items
- Books are **bound to inventory items**
- **Pages stored in item metadata** (fully portable)
- Books remain readable even if **configs are deleted**
- **Tradable and usable** by any player
- **Offline-safe** - no server config dependency

### 🛡️ Durability System
- **Configurable uses** per book
- **Durability decreases** on each read
- Books become **unusable at zero condition**
- Visual **condition bar** in viewer
- Balanced for roleplay longevity

### 🖥️ User Interface
- **Smooth page-turning viewer** using Turn.js
- **Western / parchment styled** interface
- **Fixed action buttons** with scrollable editors
- **Responsive design** for various resolutions
- **Clean, branded UI** matching wolves.land style

### 🌍 Multi-Framework Support
- **LXR-Core** (Primary)
- **RSG-Core** (Primary)
- **VORP Core** (Supported)
- **Auto-detection** on startup
- **Unified adapter layer** for compatibility
- **Standalone fallback** if no framework detected

### 🔒 Security Features
- **Job-based access control** for book creation
- **URL validation** and whitelist
- **Rate limiting** on book binding
- **Server-side validation** for all operations
- **Anti-exploit measures**
- **Suspicious activity logging**

### 🌐 Localization
- **Full locale support** (English & Georgian included)
- **Easy to add** new languages
- **UI and notifications** fully localized
- **Consistent translation** across all systems

### ⚡ Performance Optimized
- **Minimal server overhead**
- **Client FPS impact** minimized
- **Efficient metadata storage**
- **Cleanup routines** for old data
- **Caching support** for frequently used books

## 🎯 Use Cases

### Perfect For:
- 📖 **Manuals and Guides** - Create instruction books for crafting, hunting, etc.
- 📜 **Journals and Diaries** - Record character stories and events
- ⛪ **Religious Texts** - Bibles, prayer books, religious documents
- 🏪 **Catalogs** - Store catalogs, price lists, product guides
- 📋 **Contracts** - Legal documents, agreements, deeds
- 🎭 **Lore Content** - Server lore, history, world-building
- 🗺️ **Maps and Diagrams** - Visual guides using images
- 📰 **Newspapers** - Server news and announcements

## 🏗️ Architecture

### Framework Adapter Pattern
All core gameplay logic uses unified functions that are framework-agnostic:
- `Framework.Notify()` - Notifications
- `Framework.GetPlayer()` - Player data
- `Framework.GetJob()` - Job information
- `Framework.AddItem()` - Add inventory items
- `Framework.RemoveItem()` - Remove inventory items

The adapter layer automatically maps these to the correct framework-specific calls.

### Metadata Storage
Books are stored entirely in item metadata:
```lua
metadata = {
    title = "My Book",
    pages = {
        {url = "https://i.imgur.com/example1.png"},
        {url = "https://i.imgur.com/example2.png"}
    },
    durability = 30,
    maxDurability = 31
}
```

This ensures **portability** and **offline operation**.

## 📊 System Requirements

- RedM Server
- One of: LXR-Core, RSG-Core, or VORP Core (optional - standalone mode available)
- ox_lib (recommended for notifications)
- Modern web browser support for clients

## 🔗 Related Documentation

- [Installation Guide](installation.md)
- [Configuration Guide](configuration.md)
- [Framework Support](frameworks.md)
- [Events & API](events.md)
- [Security Guide](security.md)
- [Performance Guide](performance.md)
- [Screenshots](screenshots.md)

## 🐺 wolves.land

**Server:** The Land of Wolves 🐺  
**Discord:** https://discord.gg/CrKcWdfd3A  
**Website:** https://www.wolves.land  
**Developer:** iBoss21 / The Lux Empire  
**GitHub:** https://github.com/iBoss21

═══════════════════════════════════════════════════════════════════════════════
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
═══════════════════════════════════════════════════════════════════════════════
