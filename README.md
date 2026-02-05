```
    ██╗     ██╗  ██╗██████╗       ██████╗  ██████╗  ██████╗ ██╗  ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██╔═══██╗██╔═══██╗██║ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║   ██║██║   ██║█████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██╗██║   ██║██║   ██║██╔═██╗ 
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝╚██████╔╝╚██████╔╝██║  ██╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
```

# 🐺 LXR Book System

**Complete book creation and reading system for RedM**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![RedM](https://img.shields.io/badge/RedM-Compatible-red)](https://redm.gg/)
[![Framework](https://img.shields.io/badge/Framework-Multi-blue)](https://github.com/iboss21/lxr-book)

---

## 🌟 Overview

LXR Books is a complete book creation and reading system for RedM, built with full **LXRCore** and **rsg-core** integration. It allows authorized jobs to create, manage, and publish interactive books composed of image-based pages, which can then be bound to physical in-game items.

Each book becomes **fully self-contained** when bound, storing its pages directly in item metadata—ensuring books remain readable by any player, even if the original configuration is deleted or the creator is offline.

**Developed by:** iBoss21 / The Lux Empire  
**For:** The Land of Wolves 🐺 (wolves.land)

---

## ✨ Features

### 📚 Book Creation System
- 🔹 Job-restricted book builder with full framework integration
- 🔹 Players can create and manage multiple books
- 🔹 Image-based pages with configurable max limits
- 🔹 Save drafts before binding to items

### 📕 Physical Book Items
- 🔹 Books are bound to inventory items
- 🔹 Pages stored in item metadata (fully portable)
- 🔹 Books remain readable even if configs are deleted
- 🔹 Tradable and usable by any player

### 🛡️ Durability System
- 🔹 Configurable uses per book
- 🔹 Durability decreases on each use
- 🔹 Books become unusable at zero condition
- 🔹 Visual condition indicator

### 🖥️ UI & Viewer
- 🔹 Smooth page-turning viewer using Turn.js
- 🔹 Western / parchment styled interface
- 🔹 Fixed action buttons with scrollable editors
- 🔹 Clean, branded UI

### 🌍 Multi-Framework Support
- 🔹 **LXR-Core** (Primary)
- 🔹 **RSG-Core** (Primary)
- 🔹 **VORP Core** (Supported)
- 🔹 **Standalone** (Fallback)
- 🔹 Auto-detection on startup

### 🔒 Security Features
- 🔹 Job-based access control
- 🔹 URL validation and whitelist
- 🔹 Rate limiting
- 🔹 Server-side validation
- 🔹 Anti-exploit measures

### 🌐 Localization
- 🔹 Full locale support
- 🔹 English & Georgian included
- 🔹 Easy to add new languages

---

## 📦 Installation

### Quick Start

1. **Clone the repository:**
```bash
cd resources
git clone https://github.com/iboss21/lxr-book.git
```

2. **Install Turn.js:**
   - Download from: http://turnjs.com
   - Replace `/html/turn.min.js` with actual library

3. **Add to server.cfg:**
```cfg
ensure lxr-book
```

4. **Add database item:**
```sql
INSERT INTO `items` 
(`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `metadata`, `description`, `weight`)
VALUES
('lxr_book', 'Book', 10, 1, 'item_standard', 1, '{}', 'A book that can be read', 0.25);
```

5. **Configure and restart**

📖 **Full installation guide:** [docs/installation.md](docs/installation.md)

---

## ⚙️ Configuration

Edit `config.lua` to customize:

```lua
Config.BookItemName = "lxr_book"
Config.MaxPages = 50
Config.BookMaxDurability = 31
Config.BuilderJobLock = true
Config.BuilderAllowedJobs = {
    "sheriff",
    "marshal",
    "admin"
}
```

📖 **Full configuration guide:** [docs/configuration.md](docs/configuration.md)

---

## 🎮 Usage

### For Players

**Creating Books (Job Required):**
1. Use command: `/bookbuilder`
2. Enter book title
3. Add pages with image URLs
4. Save draft or bind to item

**Reading Books:**
1. Use book item from inventory
2. Navigate pages with arrow buttons
3. Close with ESC or close button

### For Administrators

**Setup Jobs:**
```lua
Config.BuilderAllowedJobs = {
    "your_job_name"
}
```

**Adjust Security:**
```lua
Config.Security.allowedImageHosts = {
    'your-image-host.com'
}
```

---

## 📚 Documentation

- [📖 Overview](docs/overview.md) - System overview and features
- [🔧 Installation](docs/installation.md) - Installation instructions
- [⚙️ Configuration](docs/configuration.md) - Configuration options
- [🔌 Frameworks](docs/frameworks.md) - Framework support details
- [📡 Events & API](docs/events.md) - Events and callbacks
- [🔒 Security](docs/security.md) - Security features
- [⚡ Performance](docs/performance.md) - Performance optimization
- [📸 Screenshots](docs/screenshots.md) - Screenshot requirements

---

## 🎯 Use Cases

Perfect for:
- 📖 Manuals and guides
- 📜 Journals and diaries
- ⛪ Religious texts (Bibles, prayer books)
- 🏪 Store catalogs
- 📋 Contracts and documents
- 🎭 Server lore content
- 🗺️ Maps and diagrams
- 📰 Newspapers

---

## 🛠️ Technical Details

### Architecture
- **Pattern:** Framework Adapter / Bridge
- **Storage:** Item metadata (no database overhead)
- **UI:** NUI with Turn.js
- **Style:** Western/Parchment themed

### File Structure
```
lxr-book/
├── client/          # Client scripts
├── server/          # Server scripts
├── shared/          # Framework adapter
├── locales/         # Language files
├── html/            # UI files
├── docs/            # Documentation
├── config.lua       # Configuration
└── fxmanifest.lua   # Manifest
```

---

## 🤝 Support

### The Land of Wolves 🐺

**Server:** The Land of Wolves  
**Website:** https://www.wolves.land  
**Discord:** https://discord.gg/CrKcWdfd3A  
**GitHub:** https://github.com/iBoss21  
**Store:** https://theluxempire.tebex.io  

### Issues & Contributions

- **Report bugs:** [GitHub Issues](https://github.com/iboss21/lxr-book/issues)
- **Feature requests:** [GitHub Discussions](https://github.com/iboss21/lxr-book/discussions)
- **Pull requests:** Welcome!

---

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details

---

## 🙏 Credits

**Author:** iBoss21 / The Lux Empire  
**Turn.js:** Emmanuel Garcia (http://turnjs.com)  
**Inspiration:** Book and publishing systems in roleplay  

**Made with ❤️ for The Land of Wolves 🐺**

═══════════════════════════════════════════════════════════════════════════════
© 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
═══════════════════════════════════════════════════════════════════════════════
