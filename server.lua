
addCommandHandler("hava", function(player, command, ...)
    local inputCity = table.concat({...}, " ")
    if not inputCity or inputCity == "" then
        outputChatBox("Lütfen bir şehir adı girin. Örneğin: /hava İstanbul", player)
        return
    end

    local closestCity = exports["mta-weather"]:findClosestCity(inputCity)
    if closestCity then
        exports["mta-weather"]:fetchWeather(closestCity, function(success, message)
            outputChatBox(message, player)
        end)
    else
        outputChatBox("Şehir bulunamadı.", player)
    end
end)
