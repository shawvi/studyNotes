Now we are ready to write an iterator that traverses a table following the order of its keys:
function pairsByKeys (t, f)
local a = {}
for n in pairs(t) do -- create a list with all keys
a[#a + 1] = n
end
table.sort(a, f) -- sort the list
local i = 0 -- iterator variable
return function () -- iterator function
i = i + 1
return a[i], t[a[i]] -- return key, value
end
end
The factory function pairsByKeys first collects the keys into an array, then it sorts the array, and finally
it returns the iterator function. At each step, the iterator returns the next key and value from the original
table, following the order in the array a. An optional parameter f allows the specification of an alternative
order.
With this function, it is easy to solve our initial problem of traversing a table in order:
for name, line in pairsByKeys(lines) do
print(name, line)
end
As usual, all the complexity is hidden inside the iterator