RegisterCommand('enter', function(source, args, raw)
    if source == 0 then print("Works in-game only, sorry") return end
    TriggerClientEvent('enter:command', source, args)
end, true)