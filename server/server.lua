--[[
    ██╗     ██╗  ██╗██████╗       ██████╗  ██████╗  ██████╗ ██╗  ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██╔═══██╗██╔═══██╗██║ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║   ██║██║   ██║█████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██╗██║   ██║██║   ██║██╔═██╗ 
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝╚██████╔╝╚██████╔╝██║  ██╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
                                                                    
    🐺 LXR Book - Server Script
    
    Server-side logic for book system:
    - Book binding and item creation
    - Durability management
    - Security validation
    - Job permission checks
    - Rate limiting
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 VARIABLES & STORAGE
-- ═══════════════════════════════════════════════════════════════════════════════

local PlayerBooks = {} -- Store player's book data
local RateLimitTracker = {} -- Track player actions for rate limiting

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

local function ValidateUrl(url)
    if not Config.Security.validateUrls then
        return true
    end
    
    if not url or #url > Config.Security.maxUrlLength then
        return false
    end
    
    -- Check if URL contains allowed image host
    local isAllowed = false
    for _, host in ipairs(Config.Security.allowedImageHosts) do
        if string.find(url, host, 1, true) then
            isAllowed = true
            break
        end
    end
    
    return isAllowed
end

local function CheckJobPermission(source)
    if not Config.BuilderJobLock then
        return true
    end
    
    local job = Framework.GetJob(source)
    
    for _, allowedJob in ipairs(Config.BuilderAllowedJobs) do
        if job == allowedJob then
            return true
        end
    end
    
    return false
end

local function CheckRateLimit(source, action)
    if not Config.Security.rateLimitBinds then
        return true
    end
    
    local playerKey = 'player_' .. source .. '_' .. action
    local currentTime = os.time()
    
    if not RateLimitTracker[playerKey] then
        RateLimitTracker[playerKey] = {count = 0, timestamp = currentTime}
    end
    
    local data = RateLimitTracker[playerKey]
    
    -- Reset counter if more than a minute has passed
    if currentTime - data.timestamp > 60 then
        data.count = 0
        data.timestamp = currentTime
    end
    
    -- Check if exceeded rate limit
    if data.count >= Config.Security.maxBindsPerMinute then
        return false
    end
    
    data.count = data.count + 1
    return true
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 BOOK MANAGEMENT
-- ═══════════════════════════════════════════════════════════════════════════════

-- Save book to player's data
Framework.CreateCallback('lxr-book:server:saveBook', function(source, cb, bookData)
    DebugPrint('Save book request from player ' .. source)
    
    -- Validate player has permission
    if not CheckJobPermission(source) then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('no_permission'), 'error')
        cb(false)
        return
    end
    
    -- Validate book data
    if not bookData or not bookData.title or #bookData.title == 0 then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('book_title_required'), 'error')
        cb(false)
        return
    end
    
    if not bookData.pages or #bookData.pages == 0 then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('book_pages_required'), 'error')
        cb(false)
        return
    end
    
    if #bookData.pages > Config.MaxPages then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('book_max_pages', Config.MaxPages), 'error')
        cb(false)
        return
    end
    
    -- Validate URLs
    for i, page in ipairs(bookData.pages) do
        if not ValidateUrl(page.url) then
            TriggerClientEvent('lxr-book:client:notify', source, GetLocale('url_not_allowed'), 'error')
            cb(false)
            return
        end
    end
    
    -- Store book data
    local identifier = Framework.GetIdentifier(source)
    if not PlayerBooks[identifier] then
        PlayerBooks[identifier] = {}
    end
    
    bookData.id = bookData.id or ('book_' .. os.time() .. '_' .. math.random(1000, 9999))
    PlayerBooks[identifier][bookData.id] = bookData
    
    DebugPrint('Book saved: ' .. bookData.title .. ' (ID: ' .. bookData.id .. ')')
    TriggerClientEvent('lxr-book:client:notify', source, GetLocale('book_saved'), 'success')
    cb(true, bookData.id)
end)

-- Get player's books
Framework.CreateCallback('lxr-book:server:getBooks', function(source, cb)
    local identifier = Framework.GetIdentifier(source)
    cb(PlayerBooks[identifier] or {})
end)

-- Delete book
Framework.CreateCallback('lxr-book:server:deleteBook', function(source, cb, bookId)
    DebugPrint('Delete book request from player ' .. source .. ' for book ' .. bookId)
    
    if not CheckJobPermission(source) then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('no_permission'), 'error')
        cb(false)
        return
    end
    
    local identifier = Framework.GetIdentifier(source)
    if PlayerBooks[identifier] and PlayerBooks[identifier][bookId] then
        PlayerBooks[identifier][bookId] = nil
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('book_deleted'), 'success')
        cb(true)
    else
        cb(false)
    end
end)

-- Bind book to physical item
Framework.CreateCallback('lxr-book:server:bindBook', function(source, cb, bookData)
    DebugPrint('Bind book request from player ' .. source)
    
    -- Validate player has permission
    if not CheckJobPermission(source) then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('no_permission'), 'error')
        cb(false)
        return
    end
    
    -- Check rate limit
    if not CheckRateLimit(source, 'bind') then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('rate_limit'), 'error')
        cb(false)
        return
    end
    
    -- Validate book data
    if not bookData or not bookData.title or not bookData.pages or #bookData.pages == 0 then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('invalid_book_data'), 'error')
        cb(false)
        return
    end
    
    -- Validate URLs
    for i, page in ipairs(bookData.pages) do
        if not ValidateUrl(page.url) then
            TriggerClientEvent('lxr-book:client:notify', source, GetLocale('url_not_allowed'), 'error')
            cb(false)
            return
        end
    end
    
    -- Check if player has empty book item
    local Player = Framework.GetPlayer(source)
    if not Player then
        cb(false)
        return
    end
    
    -- Check for empty book (framework-specific)
    local hasBook = false
    if Framework.ActiveFramework == 'lxr-core' or Framework.ActiveFramework == 'rsg-core' then
        local bookItem = Player.Functions.GetItemByName(Config.BookItemName)
        hasBook = bookItem ~= nil
    elseif Framework.ActiveFramework == 'vorp_core' then
        -- VORP inventory check
        hasBook = true -- Placeholder - implement VORP item check
    else
        hasBook = true -- Standalone always succeeds
    end
    
    if not hasBook then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('no_empty_book'), 'error')
        cb(false)
        return
    end
    
    -- Remove empty book
    Framework.RemoveItem(source, Config.BookItemName, 1)
    
    -- Create metadata with book content
    local metadata = {
        title = bookData.title,
        pages = bookData.pages,
        durability = Config.BookMaxDurability,
        maxDurability = Config.BookMaxDurability,
        description = 'A book titled: ' .. bookData.title
    }
    
    -- Add bound book with metadata
    local success = Framework.AddItem(source, Config.BookItemName, 1, metadata)
    
    if success then
        DebugPrint('Book bound successfully: ' .. bookData.title)
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('book_bound'), 'success')
        cb(true)
    else
        -- If failed, return the empty book
        Framework.AddItem(source, Config.BookItemName, 1)
        cb(false)
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 BOOK USAGE & DURABILITY
-- ═══════════════════════════════════════════════════════════════════════════════

-- Use book (consumes durability)
Framework.CreateCallback('lxr-book:server:useBook', function(source, cb, slot, itemData)
    DebugPrint('Use book request from player ' .. source)
    
    if not itemData or not itemData.info then
        cb(false)
        return
    end
    
    local bookInfo = itemData.info
    
    -- Check durability
    if not bookInfo.durability or bookInfo.durability <= 0 then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('book_worn_out'), 'error')
        cb(false)
        return
    end
    
    -- Check if book has pages
    if not bookInfo.pages or #bookInfo.pages == 0 then
        TriggerClientEvent('lxr-book:client:notify', source, GetLocale('book_no_data'), 'error')
        cb(false)
        return
    end
    
    -- Consume durability
    bookInfo.durability = bookInfo.durability - Config.BookUseCost
    
    -- Update item metadata
    if Framework.ActiveFramework == 'lxr-core' or Framework.ActiveFramework == 'rsg-core' then
        local Player = Framework.GetPlayer(source)
        if Player then
            Player.Functions.RemoveItem(Config.BookItemName, 1, slot)
            Player.Functions.AddItem(Config.BookItemName, 1, false, bookInfo)
        end
    end
    
    DebugPrint('Book used. Remaining durability: ' .. bookInfo.durability)
    
    -- Return book data to client
    cb(true, {
        title = bookInfo.title,
        pages = bookInfo.pages,
        durability = bookInfo.durability,
        maxDurability = bookInfo.maxDurability
    })
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 PLAYER DISCONNECTION CLEANUP
-- ═══════════════════════════════════════════════════════════════════════════════

AddEventHandler('playerDropped', function(reason)
    local source = source
    local identifier = Framework.GetIdentifier(source)
    
    -- Optional: Clear player data on disconnect (or keep for persistence)
    -- PlayerBooks[identifier] = nil
    
    -- Clear rate limit tracking
    for key, _ in pairs(RateLimitTracker) do
        if string.find(key, 'player_' .. source) then
            RateLimitTracker[key] = nil
        end
    end
end)

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 PERIODIC CLEANUP
-- ═══════════════════════════════════════════════════════════════════════════════

if Config.Performance.cleanupInterval > 0 then
    CreateThread(function()
        while true do
            Wait(Config.Performance.cleanupInterval)
            
            local currentTime = os.time()
            
            -- Clean up old rate limit entries
            for key, data in pairs(RateLimitTracker) do
                if currentTime - data.timestamp > 300 then -- 5 minutes
                    RateLimitTracker[key] = nil
                end
            end
            
            DebugPrint('Cleanup completed')
        end
    end)
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 STARTUP MESSAGE
-- ═══════════════════════════════════════════════════════════════════════════════

CreateThread(function()
    Wait(2000)
    print('^2[LXR-Book]^7 Server initialized successfully')
    print('^2[LXR-Book]^7 Framework: ' .. Framework.ActiveFramework)
    print('^2[LXR-Book]^7 Job Lock: ' .. (Config.BuilderJobLock and 'Enabled' or 'Disabled'))
end)
