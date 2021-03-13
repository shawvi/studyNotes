s = "hello world"
i, j = string.find(s, "hello")
print(i, j) --> 1 5
print(string.sub(s, i, j)) --> hello
print(string.find(s, "world")) --> 7 11
i, j = string.find(s, "l")
print(i, j) --> 3 3
print(string.find(s, "lll"))


date = "Today is 17/7/1990"
d = string.match(date, "%d+/%d+/%d+")
print(d) --> 17/7/1990


s = string.gsub("Lua is cute", "cute", "great")
print(s) --> Lua is great
s = string.gsub("all lii", "l", "x")
print(s) --> axx xii
s = string.gsub("Lua is great", "Sol", "Sun")
print(s) --> Lua is great
-- An optional fourth parameter limits the number of substitutions to be made:
s = string.gsub("all lii", "l", "x", 1)
print(s) --> axl lii
s = string.gsub("all lii", "l", "x", 2)
print(s) --> axx lii

--[[
Instead of a replacement string, the third argument to string.gsub can be also a function or a table,
which is called (or indexed) to produce the replacement string; we will cover this feature in the section
called “Replacements”.
The function string.gsub also returns as a second result the number of times it made the substitution.
--]]

--[[
The function string.gmatch returns a function that iterates over all occurrences of a pattern in a string.
For instance, the following example collects all words of a given string s:
--]]
s = "some string"
words = {}
for w in string.gmatch(s, "%a+") do
  words[#words + 1] = w
end
--[[
As we will discuss shortly, the pattern '%a+' matches sequences of one or more alphabetic characters (that
is, words). So, the for loop will iterate over all words of the subject string, storing them in the list words.
--]]