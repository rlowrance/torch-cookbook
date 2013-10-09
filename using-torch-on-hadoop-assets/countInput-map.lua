#!/home/rel292/local/bin/torch-lua
-- count number of records and bytes in stdin map function
-- stdin format: records consisting of pairs of strings
--   (keyname --> count)
-- stdout format:
--   (keyname --> sum of counts for that keyname)

require "getKeyValue"

-- verify that we can read a command line argument
if arg[1] == nil then
    print("mapper has no command line argument")
    os.exit(0)
end
    
local keyBytes = 0
local valueBytes = 0
local records = 0
for line in io.stdin:lines("*l") do
    if line == nil then break end
    records = records + 1
    local key, value = getKeyValue(line)
    keyBytes = keyBytes + string.len(key)
    valueBytes = valueBytes + string.len(value)
end
print("records" .. "\t" .. tostring(records))
print("keyBytes" .. "\t" .. tostring(keyBytes))
print("valueBytes" .. "\t" .. tostring(valueBytes))

