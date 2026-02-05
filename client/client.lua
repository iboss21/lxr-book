--[[
    ██╗     ██╗  ██╗██████╗       ██████╗  ██████╗  ██████╗ ██╗  ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██╔═══██╗██╔═══██╗██║ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║   ██║██║   ██║█████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██╗██║   ██║██║   ██║██╔═██╗ 
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝╚██████╔╝╚██████╔╝██║  ██╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
                                                                    
    🐺 LXR Book - Client Script
    
    Client-side logic for book system:
    - Book builder command and UI
    - Book viewer NUI
    - Page management
    - Item usage handling
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 VARIABLES & STATE
-- ═══════════════════════════════════════════════════════════════════════════════

local PlayerLoaded = false
local CurrentBook = nil
local BookBuilderOpen = false
local BookViewerOpen = false

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UTILITY FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

local function GetLocale(key, ...)
    if Locale and Locale[Config.Lang] and Locale[Config.Lang][key] then
        return string.format(Locale[Config.Lang][key], ...)
    end
    return key
end

local function DebugPrint(message)
    if Config.Debug then
        print('^3[LXR-Book Debug]^7 ' .. message)
    end
end

local function Notify(message, type)
    Framework.Notify(message, type or 'info', Config.Notifications.duration)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK EVENTS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Wait for player to load
CreateThread(function()
    while not Framework.Ready do
        Wait(100)
    end
    
    if Framework.ActiveFramework == 'lxr-core' then
        RegisterNetEvent('LXRCore:Client:OnPlayerLoaded', function()
            PlayerLoaded = true
            DebugPrint('Player loaded (LXR-Core)')
        end)
        
        RegisterNetEvent('LXRCore:Client:OnPlayerUnload', function()
            PlayerLoaded = false
        end)
    elseif Framework.ActiveFramework == 'rsg-core' then
        RegisterNetEvent('RSGCore:Client:OnPlayerLoaded', function()
            PlayerLoaded = true
            DebugPrint('Player loaded (RSG-Core)')
        end)
        
        RegisterNetEvent('RSGCore:Client:OnPlayerUnload', function()
            PlayerLoaded = false
        end)
    elseif Framework.ActiveFramework == 'vorp_core' then
        RegisterNetEvent('vorp:SelectedCharacter', function()
            PlayerLoaded = true
            DebugPrint('Player loaded (VORP)')
        end)
    else
        -- Standalone - always loaded
        PlayerLoaded = true
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 BOOK BUILDER COMMAND
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterCommand('bookbuilder', function()
    if not PlayerLoaded then
        return
    end
    
    OpenBookBuilder()
end, false)

function OpenBookBuilder()
    DebugPrint('Opening book builder')
    
    -- Get player's saved books
    Framework.TriggerCallback('lxr-book:server:getBooks', function(books)
        -- Send data to NUI
        SetNuiFocus(true, true)
        BookBuilderOpen = true
        
        SendNUIMessage({
            action = 'openBuilder',
            books = books,
            maxPages = Config.MaxPages,
            locale = Locale[Config.Lang]
        })
        
        Notify(GetLocale('builder_opened'), 'success')
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 BOOK VIEWER
-- ═══════════════════════════════════════════════════════════════════════════════

function OpenBookViewer(bookData)
    DebugPrint('Opening book viewer: ' .. bookData.title)
    
    CurrentBook = bookData
    BookViewerOpen = true
    SetNuiFocus(true, true)
    
    SendNUIMessage({
        action = 'openViewer',
        book = bookData,
        locale = Locale[Config.Lang]
    })
    
    Notify(GetLocale('viewer_opened'), 'success')
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 NUI CALLBACKS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Close builder/viewer
RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    BookBuilderOpen = false
    BookViewerOpen = false
    CurrentBook = nil
    cb('ok')
end)

-- Save book
RegisterNUICallback('saveBook', function(data, cb)
    DebugPrint('Saving book: ' .. data.title)
    
    Framework.TriggerCallback('lxr-book:server:saveBook', function(success, bookId)
        cb({success = success, bookId = bookId})
    end, data)
end)

-- Delete book
RegisterNUICallback('deleteBook', function(data, cb)
    DebugPrint('Deleting book: ' .. data.bookId)
    
    Framework.TriggerCallback('lxr-book:server:deleteBook', function(success)
        cb({success = success})
    end, data.bookId)
end)

-- Bind book to item
RegisterNUICallback('bindBook', function(data, cb)
    DebugPrint('Binding book: ' .. data.title)
    
    Framework.TriggerCallback('lxr-book:server:bindBook', function(success)
        cb({success = success})
    end, data)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 ITEM USAGE
-- ═══════════════════════════════════════════════════════════════════════════════

-- Register item usage based on framework
if Framework.ActiveFramework == 'lxr-core' then
    RegisterNetEvent('lxr-core:client:UseItem', function(item)
        if item.name == Config.BookItemName then
            UseBook(item)
        end
    end)
elseif Framework.ActiveFramework == 'rsg-core' then
    RegisterNetEvent('rsg-core:client:UseItem', function(item)
        if item.name == Config.BookItemName then
            UseBook(item)
        end
    end)
elseif Framework.ActiveFramework == 'vorp_core' then
    -- VORP item usage
    RegisterNetEvent('vorp:use:' .. Config.BookItemName, function()
        -- Get item data from VORP
        UseBook({name = Config.BookItemName, info = {}})
    end)
end

function UseBook(itemData)
    DebugPrint('Using book item')
    
    -- Request book data from server
    Framework.TriggerCallback('lxr-book:server:useBook', function(success, bookData)
        if success and bookData then
            OpenBookViewer(bookData)
        end
    end, itemData.slot, itemData)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 NOTIFICATIONS FROM SERVER
-- ═══════════════════════════════════════════════════════════════════════════════

RegisterNetEvent('lxr-book:client:notify', function(message, type)
    Notify(message, type)
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 KEYBINDS
-- ═══════════════════════════════════════════════════════════════════════════════

-- Close viewer with ESC key
CreateThread(function()
    while true do
        Wait(0)
        
        if BookViewerOpen then
            if IsControlJustPressed(0, Config.Keys.close) then
                SendNUIMessage({action = 'closeViewer'})
                SetNuiFocus(false, false)
                BookViewerOpen = false
                CurrentBook = nil
            end
        else
            Wait(500)
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 STARTUP MESSAGE
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(2000)
    print('^2[LXR-Book]^7 Client initialized successfully')
    print('^2[LXR-Book]^7 Framework: ' .. Framework.ActiveFramework)
    print('^2[LXR-Book]^7 Use /bookbuilder to create books')
end)
