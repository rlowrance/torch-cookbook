#!/home/rel292/local/bin/torch-lua
-- count number of records and bytes in stdin map function
-- stdin format: records consisting of pairs of strings
--   (keyname --> count)
-- stdout format:
--   (keyname --> sum of counts for that keyname)
--
-- Also echo an auxillary file.
--
-- COMMAND LINE ARGUMENTS
-- READLIMIT optional integer default -1
--           if >= 0, read only READLIMIT input records

require "getKeyValue"

local readlimit = -1
if arg[1] ~= nil then
    readlimit = tonumber(arg[1])
end

print('# readlimit \t' .. tostring(readlimit))

-- read the auxillary file
-- echo its records to output as commennts
-- our convention is that comments being with a #

local auxFilename = "auxillary-mapper.txt"
local nAuxRecords = 0
for auxRecord in io.lines(auxFilename) do
    if auxRecord == nil then break end
    nAuxRecords = nAuxRecords + 1
    print("# mapper aux " .. tostring(nAuxRecords) .. "\t" .. auxRecord)
end

local records = 0
local keyBytes = 0
local valueBytes = 0
local nRead = 0
for line in io.stdin:lines("*l") do
    nRead = nRead + 1
    if readlimit >= 0 and nRead > readlimit then
        break
    end
    
    if line == nil then break end
    records = records + 1
    local key, value = getKeyValue(line)
    keyBytes = keyBytes + string.len(key)
    valueBytes = valueBytes + string.len(value)
end
print("records" .. "\t" .. tostring(records))
print("keyBytes" .. "\t" .. tostring(keyBytes))
print("valueBytes" .. "\t" .. tostring(valueBytes))

