local QBCore = exports['qb-core']:GetCoreObject()

local voteActive = false
local hasVoted = false

RegisterNetEvent('sd-votetime:client:startVote')
AddEventHandler('sd-votetime:client:startVote', function()
    voteActive = true
end)

RegisterNetEvent('sd-votetime:client:setTimeToDay')
AddEventHandler('sd-votetime:client:setTimeToDay', function()
    voteActive = false
    hasVoted = false
    local message = 'The vote to skip the night has passed.'
    if Config.NotificationType == 'chat' then
        TriggerEvent('chat:addMessage', {
            color = {255, 255, 0},
            multiline = true,
            args = {'Vote Time', message}
        })
    elseif Config.NotificationType == 'notification' then
        QBCore.Functions.Notify(message, 'success', 5000)
    end
    Wait(3000)
    TriggerServerEvent('sd-votetime:server:resetVotes')
    ExecuteCommand("clear")
end)

RegisterNetEvent('sd-votetime:client:voteFailed')
AddEventHandler('sd-votetime:client:voteFailed', function()
    voteActive = false
    hasVoted = false
    local message = 'The vote to skip the night has failed. The time remains unchanged.'
    if Config.NotificationType == 'chat' then
        TriggerEvent('chat:addMessage', {
            color = {255, 255, 0},
            multiline = true,
            args = {'Vote Time', message}
        })
    elseif Config.NotificationType == 'notification' then
        QBCore.Functions.Notify(message, 'error', 5000)
    end
    Wait(3000)
    TriggerServerEvent('sd-votetime:server:resetVotes')
    ExecuteCommand("clear")
end)

CreateThread(function()
    while true do
        local hour = GetClockHours()
        if hour == Config.TimeForVote and not voteActive then
            TriggerServerEvent('sd-votetime:server:startVote')
        end
        Wait(5000)
    end
end)

RegisterCommand('yes', function()
    if voteActive and not hasVoted then
        TriggerServerEvent('sd-votetime:server:playerVoted', 'yes')
        hasVoted = true
        local message = 'You have voted to skip the night.'
        if Config.NotificationType == 'chat' then
            TriggerEvent('chat:addMessage', {
                color = {0, 255, 0},
                multiline = true,
                args = {'Server', message}
            })
        elseif Config.NotificationType == 'notification' then
            QBCore.Functions.Notify(message, 'success', 5000)
        end
    elseif not voteActive then
        local message = 'There is no vote currently active.'
        if Config.NotificationType == 'chat' then
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {'Server', message}
            })
        elseif Config.NotificationType == 'notification' then
            QBCore.Functions.Notify(message, 'error', 5000)
        end
    else
        local message = 'You have already voted. You cannot vote again.'
        if Config.NotificationType == 'chat' then
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {'Server', message}
            })
        elseif Config.NotificationType == 'notification' then
            QBCore.Functions.Notify(message, 'error', 5000)
        end
    end
end)

RegisterCommand('no', function()
    if voteActive and not hasVoted then
        TriggerServerEvent('sd-votetime:server:playerVoted', 'no')
        hasVoted = true
        local message = 'You have voted to not skip the night.'
        if Config.NotificationType == 'chat' then
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {'Server', message}
            })
        elseif Config.NotificationType == 'notification' then
            QBCore.Functions.Notify(message, 'success', 5000)
        end
    elseif not voteActive then
        local message = 'There is no vote currently active.'
        if Config.NotificationType == 'chat' then
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {'Server', message}
            })
        elseif Config.NotificationType == 'notification' then
            QBCore.Functions.Notify(message, 'error', 5000)
        end
    else
        local message = 'You have already voted. You cannot vote again.'
        if Config.NotificationType == 'chat' then
            TriggerEvent('chat:addMessage', {
                color = {255, 0, 0},
                multiline = true,
                args = {'Server', message}
            })
        elseif Config.NotificationType == 'notification' then
            QBCore.Functions.Notify(message, 'error', 5000)
        end
    end
end)