--[[
    ██╗     ██╗  ██╗██████╗       ██████╗  ██████╗  ██████╗ ██╗  ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██╔═══██╗██╔═══██╗██║ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║   ██║██║   ██║█████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██╗██║   ██║██║   ██║██╔═██╗ 
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝╚██████╔╝╚██████╔╝██║  ██╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
                                                                    
    🐺 LXR Book - FiveM Resource Manifest
    
    This manifest file defines the scope and structure of the LXR Book System.
    It declares all scripts, files, dependencies, and metadata for the resource.
    
    ═══════════════════════════════════════════════════════════════════════════════
    SERVER INFORMATION
    ═══════════════════════════════════════════════════════════════════════════════
    
    Server:      The Land of Wolves 🐺
    Tagline:     Georgian RP 🇬🇪 | მგლების მიწა - რჩეულთა ადგილი!
    Description: ისტორია ცოცხლდება აქ! (History Lives Here!)
    Type:        Serious Hardcore Roleplay
    Access:      Discord & Whitelisted
    
    Developer:   iBoss21 / The Lux Empire
    Website:     https://www.wolves.land
    Discord:     https://discord.gg/CrKcWdfd3A
    GitHub:      https://github.com/iBoss21
    Store:       https://theluxempire.tebex.io
    Server:      https://servers.redm.net/servers/detail/8gj7eb
    
    ═══════════════════════════════════════════════════════════════════════════════
    
    Version: 1.0.0
    Performance Target: Optimized for minimal server overhead and client FPS impact
    
    Tags: RedM, Georgian, SeriousRP, Books, LXR, Publishing, Crafting
    
    Framework Support:
    - LXR Core (Primary)
    - RSG Core (Primary)
    - VORP Core (Supported)
    
    ═══════════════════════════════════════════════════════════════════════════════
    CREDITS
    ═══════════════════════════════════════════════════════════════════════════════
    
    Script Author: iBoss21 / The Lux Empire for The Land of Wolves
    Turn.js Library: Emmanuel Garcia (http://turnjs.com)
    Inspired by: Book and publishing systems in roleplay
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FXMANIFEST - RESOURCE DECLARATION
-- ═══════════════════════════════════════════════════════════════════════════════

fx_version   'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources WILL become incompatible once RedM ships.'
game         'rdr3'
lua54        'yes'

-- ═══════════════════════════════════════════════════════════════════════════════
-- METADATA
-- ═══════════════════════════════════════════════════════════════════════════════

name         'lxr-book'
author       'iBoss21 / The Lux Empire'
description  'Complete book creation and reading system with Turn.js integration for RedM'
version      '1.0.0'
repository   'https://github.com/iboss21/lxr-book'

-- ═══════════════════════════════════════════════════════════════════════════════
-- SHARED SCRIPTS - Loaded on both client and server
-- ═══════════════════════════════════════════════════════════════════════════════

shared_scripts {
    'config.lua',
    'locales/*.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- CLIENT SCRIPTS - Loaded on client only
-- ═══════════════════════════════════════════════════════════════════════════════

client_scripts {
    'shared/framework.lua',
    'client/client.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- SERVER SCRIPTS - Loaded on server only
-- ═══════════════════════════════════════════════════════════════════════════════

server_scripts {
    'shared/framework.lua',
    'server/server.lua'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- UI FILES - HTML/CSS/JS for NUI interface
-- ═══════════════════════════════════════════════════════════════════════════════

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/ui.css',
    'html/ui.js',
    'html/turn.min.js',
    'html/assets/**/*'
}

-- ═══════════════════════════════════════════════════════════════════════════════
-- DEPENDENCIES - Optional framework dependencies
-- ═══════════════════════════════════════════════════════════════════════════════

-- No hard dependencies - multi-framework auto-detect handles this

-- ═══════════════════════════════════════════════════════════════════════════════
-- SCOPE & RESPONSIBILITY
-- ═══════════════════════════════════════════════════════════════════════════════

--[[
    This resource provides:
    
    - Job-restricted book builder with image-based pages
    - Physical inventory items bound to books
    - Durability and limited uses per book
    - Turn.js powered page-turning viewer
    - Full LXRCore and RSG-Core integration
    - Multi-framework support with auto-detection
    - Offline-safe metadata storage
    - Secure server-side validation
    - Localized UI and notifications
    
    Books created here are fully portable and can be read by any player,
    even if the original configuration is deleted or the creator is offline.
]]
