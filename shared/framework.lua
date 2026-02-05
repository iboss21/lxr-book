--[[
    ██╗     ██╗  ██╗██████╗       ██████╗  ██████╗  ██████╗ ██╗  ██╗
    ██║     ╚██╗██╔╝██╔══██╗      ██╔══██╗██╔═══██╗██╔═══██╗██║ ██╔╝
    ██║      ╚███╔╝ ██████╔╝█████╗██████╔╝██║   ██║██║   ██║█████╔╝ 
    ██║      ██╔██╗ ██╔══██╗╚════╝██╔══██╗██║   ██║██║   ██║██╔═██╗ 
    ███████╗██╔╝ ██╗██║  ██║      ██████╔╝╚██████╔╝╚██████╔╝██║  ██╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═╝
                                                                    
    🐺 LXR Book - Framework Adapter
    
    This file provides a unified API for framework-agnostic gameplay logic.
    It auto-detects the running framework and maps unified function calls
    to the appropriate framework-specific exports, events, and callbacks.
    
    © 2026 iBoss21 / The Lux Empire | wolves.land | All Rights Reserved
]]

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 FRAMEWORK AUTO-DETECTION
-- ═══════════════════════════════════════════════════════════════════════════════

Framework = {}
Framework.ActiveFramework = 'standalone'
Framework.Ready = false

-- Detect running framework
local function DetectFramework()
    if Config.Framework ~= 'auto' then
        Framework.ActiveFramework = Config.Framework
        if Config.Debug then
            print('^3[LXR-Book]^7 Manual framework set: ' .. Framework.ActiveFramework)
        end
        return
    end
    
    -- Check for LXR-Core (Priority 1)
    if GetResourceState('lxr-core') == 'started' then
        Framework.ActiveFramework = 'lxr-core'
    -- Check for RSG-Core (Priority 2)
    elseif GetResourceState('rsg-core') == 'started' then
        Framework.ActiveFramework = 'rsg-core'
    -- Check for VORP (Priority 3)
    elseif GetResourceState('vorp_core') == 'started' then
        Framework.ActiveFramework = 'vorp_core'
    -- Fallback to standalone
    else
        Framework.ActiveFramework = 'standalone'
    end
    
    if Config.Debug then
        print('^2[LXR-Book]^7 Framework detected: ' .. Framework.ActiveFramework)
    end
end

DetectFramework()

-- ═══════════════════════════════════════════════════════════════════════════════
-- 🐺 UNIFIED ADAPTER FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

-- ═══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

function Framework.Notify(message, type, duration)
    type = type or 'info'
    duration = duration or 5000
    
    if Framework.ActiveFramework == 'lxr-core' or Framework.ActiveFramework == 'rsg-core' then
        -- Use ox_lib notifications
        if GetResourceState('ox_lib') == 'started' then
            exports['ox_lib']:notify({
                description = message,
                type = type,
                duration = duration
            })
        else
            print('^3[LXR-Book]^7 ' .. message)
        end
    elseif Framework.ActiveFramework == 'vorp_core' then
        -- Use VORP notifications
        TriggerEvent('vorp:TipRight', message, duration)
    else
        -- Standalone fallback
        print('^3[LXR-Book]^7 ' .. message)
    end
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- PLAYER DATA FUNCTIONS
-- ═══════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() then -- Server-side only
    
    function Framework.GetPlayer(source)
        if Framework.ActiveFramework == 'lxr-core' then
            local LXRCore = exports['lxr-core']:GetCoreObject()
            return LXRCore.Functions.GetPlayer(source)
        elseif Framework.ActiveFramework == 'rsg-core' then
            local RSGCore = exports['rsg-core']:GetCoreObject()
            return RSGCore.Functions.GetPlayer(source)
        elseif Framework.ActiveFramework == 'vorp_core' then
            local VORPcore = exports.vorp_core:GetCore()
            return VORPcore.getUser(source).getUsedCharacter
        else
            return nil
        end
    end
    
    function Framework.GetIdentifier(source)
        if Framework.ActiveFramework == 'lxr-core' or Framework.ActiveFramework == 'rsg-core' then
            local Player = Framework.GetPlayer(source)
            return Player and Player.PlayerData.citizenid or nil
        elseif Framework.ActiveFramework == 'vorp_core' then
            local Character = Framework.GetPlayer(source)
            return Character and Character.identifier or nil
        else
            return 'player_' .. source
        end
    end
    
    function Framework.GetJob(source)
        if Framework.ActiveFramework == 'lxr-core' or Framework.ActiveFramework == 'rsg-core' then
            local Player = Framework.GetPlayer(source)
            return Player and Player.PlayerData.job.name or 'unemployed'
        elseif Framework.ActiveFramework == 'vorp_core' then
            local Character = Framework.GetPlayer(source)
            return Character and Character.job or 'unemployed'
        else
            return 'unemployed'
        end
    end
    
    function Framework.AddItem(source, item, amount, metadata)
        if Framework.ActiveFramework == 'lxr-core' then
            local Player = Framework.GetPlayer(source)
            if Player then
                return Player.Functions.AddItem(item, amount, false, metadata)
            end
        elseif Framework.ActiveFramework == 'rsg-core' then
            local Player = Framework.GetPlayer(source)
            if Player then
                return Player.Functions.AddItem(item, amount, false, metadata)
            end
        elseif Framework.ActiveFramework == 'vorp_core' then
            local VORPInv = exports.vorp_inventory:vorp_inventoryApi()
            return VORPInv.addItem(source, item, amount, metadata)
        end
        return false
    end
    
    function Framework.RemoveItem(source, item, amount, metadata)
        if Framework.ActiveFramework == 'lxr-core' then
            local Player = Framework.GetPlayer(source)
            if Player then
                return Player.Functions.RemoveItem(item, amount, false, metadata)
            end
        elseif Framework.ActiveFramework == 'rsg-core' then
            local Player = Framework.GetPlayer(source)
            if Player then
                return Player.Functions.RemoveItem(item, amount, false, metadata)
            end
        elseif Framework.ActiveFramework == 'vorp_core' then
            local VORPInv = exports.vorp_inventory:vorp_inventoryApi()
            return VORPInv.subItem(source, item, amount, metadata)
        end
        return false
    end
    
    function Framework.GetItemMetadata(source, item, slot)
        if Framework.ActiveFramework == 'lxr-core' or Framework.ActiveFramework == 'rsg-core' then
            local Player = Framework.GetPlayer(source)
            if Player then
                local itemData = Player.Functions.GetItemByName(item)
                if itemData and itemData.info then
                    return itemData.info
                end
            end
        elseif Framework.ActiveFramework == 'vorp_core' then
            -- VORP metadata handling
            local VORPInv = exports.vorp_inventory:vorp_inventoryApi()
            -- Implementation depends on VORP inventory structure
            return {}
        end
        return nil
    end
    
else -- Client-side only
    
    function Framework.GetPlayerData()
        if Framework.ActiveFramework == 'lxr-core' then
            local LXRCore = exports['lxr-core']:GetCoreObject()
            return LXRCore.Functions.GetPlayerData()
        elseif Framework.ActiveFramework == 'rsg-core' then
            local RSGCore = exports['rsg-core']:GetCoreObject()
            return RSGCore.Functions.GetPlayerData()
        elseif Framework.ActiveFramework == 'vorp_core' then
            -- VORP client-side player data
            return {}
        else
            return {}
        end
    end
    
    function Framework.GetJob()
        local PlayerData = Framework.GetPlayerData()
        if PlayerData and PlayerData.job then
            return PlayerData.job.name
        end
        return 'unemployed'
    end
    
    function Framework.IsPlayerLoaded()
        if Framework.ActiveFramework == 'lxr-core' or Framework.ActiveFramework == 'rsg-core' then
            local PlayerData = Framework.GetPlayerData()
            return PlayerData and PlayerData.citizenid ~= nil
        elseif Framework.ActiveFramework == 'vorp_core' then
            return true -- VORP handles this differently
        else
            return true
        end
    end
    
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- CALLBACK SYSTEM
-- ═══════════════════════════════════════════════════════════════════════════════

if IsDuplicityVersion() then -- Server-side
    
    function Framework.CreateCallback(name, cb)
        if Framework.ActiveFramework == 'lxr-core' then
            local LXRCore = exports['lxr-core']:GetCoreObject()
            LXRCore.Functions.CreateCallback(name, cb)
        elseif Framework.ActiveFramework == 'rsg-core' then
            local RSGCore = exports['rsg-core']:GetCoreObject()
            RSGCore.Functions.CreateCallback(name, cb)
        elseif Framework.ActiveFramework == 'vorp_core' then
            -- VORP callback system
            RegisterServerEvent(name)
            AddEventHandler(name, function(...)
                local source = source
                cb(source, function(...)
                    TriggerClientEvent(name .. ':response', source, ...)
                end, ...)
            end)
        else
            -- Standalone callback
            RegisterServerEvent(name)
            AddEventHandler(name, function(...)
                local source = source
                cb(source, function(...)
                    TriggerClientEvent(name .. ':response', source, ...)
                end, ...)
            end)
        end
    end
    
else -- Client-side
    
    function Framework.TriggerCallback(name, cb, ...)
        if Framework.ActiveFramework == 'lxr-core' then
            local LXRCore = exports['lxr-core']:GetCoreObject()
            LXRCore.Functions.TriggerCallback(name, cb, ...)
        elseif Framework.ActiveFramework == 'rsg-core' then
            local RSGCore = exports['rsg-core']:GetCoreObject()
            RSGCore.Functions.TriggerCallback(name, cb, ...)
        elseif Framework.ActiveFramework == 'vorp_core' or Framework.ActiveFramework == 'standalone' then
            -- Manual callback implementation
            local callbackId = name .. '_' .. math.random(100000, 999999)
            RegisterNetEvent(name .. ':response')
            AddEventHandler(name .. ':response', function(...)
                cb(...)
            end)
            TriggerServerEvent(name, ...)
        end
    end
    
end

-- ═══════════════════════════════════════════════════════════════════════════════
-- FRAMEWORK READY
-- ═══════════════════════════════════════════════════════════════════════════════

Framework.Ready = true

if Config.Debug then
    print('^2[LXR-Book]^7 Framework adapter initialized: ' .. Framework.ActiveFramework)
end
