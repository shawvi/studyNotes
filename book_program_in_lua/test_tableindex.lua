If we want to monitor several tables, we do not need a different metatable for each one. Instead, we can
somehow map each proxy to its original table and share a common metatable for all proxies. This problem
is similar to the problem of associating tables to their default values, which we discussed in the previous
section, and allows the same solutions. For instance, we can keep the original table in a proxy's field, using
an exclusive key, or we can use a dual representation to map each proxy to its corresponding table.

function track (t)
local proxy = {} -- proxy table for 't'
-- create metatable for the proxy
local mt = {
__index = function (_, k)
print("*access to element " .. tostring(k))
return t[k] -- access the original table
end,
__newindex = function (_, k, v)
print("*update of element " .. tostring(k) ..
" to " .. tostring(v))
t[k] = v -- update original table
end,
__pairs = function ()
return function (_, k) -- iteration function
local nextkey, nextvalue = next(t, k)
if nextkey ~= nil then -- avoid last value
print("*traversing element " .. tostring(nextkey))
end
return nextkey, nextvalue
end
end,
__len = function () return #t end
}
setmetatable(proxy, mt)
return proxy
end


It is easy to adapt the concept of proxies to implement read-only tables. All we have to do is to raise an
error whenever we track any attempt to update the table. For the __index metamethod, we can use a
table —the original table itself— instead of a function, as we do not need to track queries; it is simpler
and rather more efficient to redirect all queries to the original table. This use demands a new metatable for
each read-only proxy, with __index pointing to the original table:
function readOnly (t)
local proxy = {}
local mt = { -- create metatable
__index = t,
__newindex = function (t, k, v)
error("attempt to update a read-only table", 2)
end
}
setmetatable(proxy, mt)
return proxy
end
As an example of use, we can create a read-only table for weekdays:
days = readOnly{"Sunday", "Monday", "Tuesday", "Wednesday",
"Thursday", "Friday", "Saturday"}
print(days[1]) --> Sunday
days[2] = "Noday"
--> stdin:1: attempt to update a read-only table