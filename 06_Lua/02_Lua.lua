local function read_lines(file)
    local f = io.open(file, "r")
    local lines = {}
    if f then
        for line in io.lines(file) do
            lines[#lines + 1] = line
        end
    else
        return {}
    end
    return lines
end

function Main()
    local lines = {}
    if arg[1] ~= nil then
        lines = read_lines(arg[1])
    end

    local time
    local distance

    for k, line in pairs(lines) do
        if (k == 1) then
            local s = string.gsub(string.gsub(line, "[A-Za-z]*:[ ]*", ""), " ", "")
            time = tonumber(s)
        end
        if (k == 2) then
            local s = string.gsub(string.gsub(line, "[A-Za-z]*:[ ]*", ""), " ", "")
            distance = tonumber(s)
        end
    end

    local min_time = 0
    local max_time = 0

    for i = 0, time, 1 do
        if (time - i) * i > distance then
            min_time = i
            break
        end
    end

    for i = time, 0, -1 do
        if (time - i) * i > distance then
            max_time = i
            break
        end
    end
    print("Race time", time)
    print("Record distance", distance)
    print("Min time pressing button", min_time)
    print("Max time pressing button", max_time)
    print("Amount of solutions", max_time - min_time + 1)
end

Main()
