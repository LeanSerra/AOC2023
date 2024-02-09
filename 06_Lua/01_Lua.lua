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

local function mysplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end


function Main()
    local lines = {}
    if arg[1] ~= nil then
        lines = read_lines(arg[1])
    end

    local time = {}
    local distance = {}

    for k, line in pairs(lines) do
        if (k == 1) then
            time = mysplit(string.gsub(line, "[A-Za-z]*:[ ]*", ""), " ")
        end
        if (k == 2) then
            distance = mysplit(string.gsub(line, "[A-Za-z]*:[ ]*", ""), " ")
        end
    end

    local count = 0
    local final_product = 1

    for k, t in pairs(time) do
        count = 0
        for i = 0, t, 1 do
            print("Pressing ", i, " seconds")
            print("Distance reached: ", (t-i) * i)
            print("Record distance: ", distance[k])
            if (t-i) * i > tonumber(distance[k]) then
                count = count + 1
            end
        end
        final_product = final_product * count
    end
    print(final_product)
end

Main()
