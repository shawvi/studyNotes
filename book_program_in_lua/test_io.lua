--[[
"a" reads the whole file
"l" reads the next line (dropping the newline)
"L" reads the next line (keeping the newline)
"n" reads a number
num reads num characters as a string
--]]

--[[
t = io.read("a") -- read the whole file
t = string.gsub(t, "bad", "good") -- do the job
io.write(t)
--]]

--[[
t = io.read("all")
t = string.gsub(t, "([\128-\255=])", function (c)
return string.format("=%02X", string.byte(c))
end)
io.write(t)
--]]

--[[
for count = 1, math.huge do
  local line = io.read("L")
  if line == nil then break end
  io.write(string.format("%6d ", count), line)
end
--]]

--[[
local count = 0
for line in io.lines() do
  count = count + 1
  io.write(string.format("%6d ", count), line, "\n")
end
--]]

--[[
-- the following program is an efficient way to copy a file from stdin to stdout:
while true do
  local block = io.read(2^13) -- block size is 8K
  if not block then break end
  io.write(block)
end
-- As a special case, io.read(0) works as a test for end of file: it returns an empty string if there is more
-- to be read or nil otherwise.
--]]

--[[
while true do
  local n1, n2, n3 = io.read("n", "n", "n")
  if not n1 then break end
  print(math.max(n1, n2, n3))
end
--]]

--[[
Instead of io.read, we can also use io.lines to read from a stream. As we saw in previous examples,
io.lines gives an iterator that repeatedly reads from a stream. Given a file name, io.lines will
open a stream over the file in read mode and will close it after reaching end of file. When called with
no arguments, io.lines will read from the current input stream. We can also use lines as a method
over handles. Moreover, since Lua 5.2 io.lines accepts the same options that io.read accepts. As
an example, the next fragment copies the current input to the current output, iterating over blocks of 8 KB:
--]]
--[[
for block in io.input():lines(2^13) do
  io.write(block)
end
--]]
