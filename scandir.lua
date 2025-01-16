function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    local pfile = popen('ls -a "'..directory..'"')
    for filename in pfile:lines() do
        i = i + 1
        t[i] = filename
    end
    pfile:close()
    return t
end

files = scandir("assets/opponents")
--print(table.concat(files, " "))

for i = 4, #files do
    print(files[i])
end

return scandir

