local weatherAPI = {}


function weatherAPI.levenshteinDistance(s1, s2)
    local len1, len2 = #s1, #s2
    local matrix = {}

    for i = 0, len1 do
        matrix[i] = {}
        matrix[i][0] = i
    end
    for j = 0, len2 do
        matrix[0][j] = j
    end

    for i = 1, len1 do
        for j = 1, len2 do
            local cost = (s1:sub(i, i) == s2:sub(j, j)) and 0 or 1
            matrix[i][j] = math.min(
                matrix[i - 1][j] + 1,
                matrix[i][j - 1] + 1,
                matrix[i - 1][j - 1] + cost
            )
        end
    end

    return matrix[len1][len2]
end

function weatherAPI.findClosestCity(inputCity)
    local cities = exports["mta-weather"]:getCities()
    local closestCity = nil
    local minDistance = math.huge

    for _, city in ipairs(cities) do
        local distance = weatherAPI.levenshteinDistance(inputCity:lower(), city:lower())
        if distance < minDistance then
            minDistance = distance
            closestCity = city
        end
    end

    return closestCity
end

function weatherAPI.fetchWeather(city, callback)
    local apiKey = "api buraya"
    local url = string.format("http://api.openweathermap.org/data/2.5/weather?q=%s&appid=%s&units=metric", city, apiKey)

    fetchRemote(url, function(responseData, errno)
        if errno == 0 then
            local weatherData = fromJSON(responseData)
            if weatherData and weatherData.main and weatherData.weather then
                local temperature = weatherData.main.temp
                local description = weatherData.weather[1].description
                callback(true, string.format("%s için hava durumu: %.1f°C, %s.", city, temperature, description))
            else
                callback(false, "Hava durumu alınamadı.")
            end
        else
            callback(false, "API isteği başarısız oldu.")
        end
    end)
end
