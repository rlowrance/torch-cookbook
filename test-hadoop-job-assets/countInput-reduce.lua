#!/home/rel292/local/bin/torch-lua
---- count number of records in standard in reduce function
-- this is the reduce
-- input is in some arbitrary order
--   ("records" --> <number of records>) ...
--   ("keyBytes" --> <number of bytes in keys>) ...
--   ("valueBytes" --> <number of bytes in values>) ...
-- output, written to stdout, is total for each key value
-- NOTE: keys are arbitary strings, not restricted to value named above
-- Comment records (beginning with #) are written to stderr

require "getKeyValue"

local lastKey = nil
local count = 0
for line in io.stdin:lines("*l") do
    if line == nil then break end
    local key, value = getKeyValue(line)
    if string.sub(key, 1, 1) == '#' then
       io.stderr:write('comment record: ' .. line .. '\n')
    else
       if lastKey == key then
           count = count + tonumber(value)
       else
           if lastKey then
               print(lastKey .. "\t" .. count)
           end
           lastKey = key
           count = tonumber(value)
       end
   end
end

if lastKey then 
    print(lastKey .. "\t" .. count)
end


