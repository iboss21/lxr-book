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

# 🔧 Installation Guide

## 📋 Prerequisites

Before installing LXR Book System, ensure you have:

1. **RedM Server** (latest version recommended)
2. **Framework** (one of the following):
   - LXR-Core (Primary support)
   - RSG-Core (Primary support)
   - VORP Core (Supported)
   - Or run in Standalone mode

3. **Optional Dependencies:**
   - `ox_lib` - For enhanced notifications (recommended)

## 📦 Installation Steps

### Step 1: Download the Resource

```bash
cd resources
git clone https://github.com/iboss21/lxr-book.git
```

Or download the ZIP file and extract to your resources folder.

**IMPORTANT:** The folder MUST be named `lxr-book` (not `lxr-book-main` or anything else).

### Step 2: Install Turn.js Library

The resource requires the Turn.js library for page-turning functionality.

1. Download Turn.js from: http://turnjs.com or https://github.com/blasten/turn.js/
2. Extract and locate `turn.min.js`
3. Replace `/html/turn.min.js` with the actual library file

### Step 3: Add to server.cfg

Add the following line to your `server.cfg`:

```cfg
ensure lxr-book
```

**Load Order Recommendations:**
```cfg
# Framework
ensure lxr-core  # or rsg-core, or vorp_core

# Libraries
ensure ox_lib

# LXR Book
ensure lxr-book
```

### Step 4: Database Setup (Framework-Specific)

#### For LXR-Core / RSG-Core:

Add the book item to your items table:

```sql
INSERT INTO `items` 
(`item`, `label`, `limit`, `can_remove`, `type`, `usable`, `metadata`, `description`, `weight`)
VALUES
('lxr_book', 'Book', 10, 1, 'item_standard', 1, '{}', 'A book that can be read', 0.25);
```

#### For VORP:

```sql
INSERT INTO `items` 
VALUES (NULL, 'lxr_book', 'Book', 10, 1, 1, 1, 0.25, NULL, 'item_standard', '{}', 'A book that can be read', 0, NULL);
```

**Note:** Adjust the SQL based on your specific framework's item structure.

### Step 5: Configure the Resource

Edit `config.lua` to customize:

1. **Book Settings:**
```lua
Config.BookItemName = "lxr_book"      -- Your item name
Config.MaxPages = 50                   -- Maximum pages per book
Config.BookMaxDurability = 31          -- Uses before worn out
```

2. **Job Restrictions:**
```lua
Config.BuilderJobLock = true           -- Enable job lock
Config.BuilderAllowedJobs = {
    "sheriff",
    "marshal",
    "admin"
}
```

3. **Security Settings:**
```lua
Config.Security.allowedImageHosts = {
    'i.imgur.com',
    'cdn.discordapp.com',
    'media.discordapp.net',
    'i.postimg.cc'
}
```

4. **Language:**
```lua
Config.Lang = 'en'  -- 'en' or 'ge'
```

### Step 6: Restart Server

```bash
restart lxr-book
```

Or restart your entire server to ensure proper loading order.

## ✅ Verification

### Check Console Output

You should see:
```
════════════════════════════════════════════════════
🐺 BOOK SYSTEM - SUCCESSFULLY LOADED
════════════════════════════════════════════════════
Version:         1.0.0
Framework:       Auto-detect enabled
Max Pages:       50
Durability:      31 uses
```

### Test In-Game

1. Join the server with a job listed in `BuilderAllowedJobs`
2. Run command: `/bookbuilder`
3. The book builder UI should open

### Test Book Creation

1. Enter a book title
2. Add a page with an image URL (try: https://i.imgur.com/example.png)
3. Click "Save Book"
4. Ensure you have an `lxr_book` item in inventory
5. Click "Bind to Item"
6. The book should appear in your inventory with metadata
7. Use the book item to open the viewer

## 🔧 Troubleshooting

### Resource Name Mismatch Error

**Error:** 
```
❌ CRITICAL ERROR: RESOURCE NAME MISMATCH ❌
Expected: lxr-book
Got: lxr-book-main
```

**Solution:** Rename the folder to exactly `lxr-book`

### Framework Not Detected

**Symptom:** Console shows "Framework: standalone" when you have a framework installed

**Solution:**
1. Ensure your framework resource is started BEFORE lxr-book
2. Check framework resource name matches config:
   - LXR-Core: `lxr-core`
   - RSG-Core: `rsg-core`
   - VORP: `vorp_core`

### No Permission to Use /bookbuilder

**Symptom:** Error message when running command

**Solution:**
1. Check `Config.BuilderJobLock` is set correctly
2. Verify your job is in `Config.BuilderAllowedJobs`
3. Set `Config.BuilderJobLock = false` to disable job restriction (testing only)

### Book Builder UI Not Opening

**Solution:**
1. Check F8 console for JavaScript errors
2. Verify all HTML/JS files are present in `/html/` folder
3. Ensure Turn.js library is properly installed
4. Check browser console (F12) for errors

### Book Item Not Creating

**Solution:**
1. Verify the item exists in your database
2. Check `Config.BookItemName` matches your item name exactly
3. Ensure you have an empty book item in inventory before binding

### Images Not Loading in Viewer

**Solution:**
1. Check image URLs are from allowed hosts (config.lua)
2. Verify images are publicly accessible
3. Use direct image links (ending in .jpg, .png, .gif)
4. Test URLs in browser first

## 📞 Support

If you continue to experience issues:

- **Discord:** https://discord.gg/CrKcWdfd3A
- **GitHub Issues:** https://github.com/iboss21/lxr-book/issues
- **Documentation:** https://www.wolves.land

═══════════════════════════════════════════════════════════════════════════════
© 2026 iBoss21 / The Lux Empire | All Rights Reserved
═══════════════════════════════════════════════════════════════════════════════
