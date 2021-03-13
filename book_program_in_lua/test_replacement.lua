As we have seen already, we can use either a function or a table as the third argument to string.gsub,
instead of a string. When invoked with a function, string.gsub calls the function every time it finds
a match; the arguments to each call are the captures, and the value that the function returns becomes the
replacement string. When invoked with a table, string.gsub looks up the table using the first capture
as the key, and the associated value is used as the replacement string. If the result from the call or from
the table lookup is nil, gsub does not change the match.
As a first example, the following function does variable expansion: it substitutes the value of the global
variable varname for every occurrence of $varname in a string:
function expand (s)
  return (string.gsub(s, "$(%w+)", _G))
end
name = "Lua"; status = "great"
print(expand("$name is $status, isn't it?"))
--> Lua is great, isn't it?Pattern Matching
84
(As we will discuss in detail in Chapter 22, The Environment, _G is a predefined table containing all global
variables.) For each match with '$(%w+)' (a dollar sign followed by a name), gsub looks up the captured
name in the global table _G; the result replaces the match. When the table does not have the key, there
is no replacement:
print(expand("$othername is $status, isn't it?"))
--> $othername is great, isn't it?
If we are not sure whether the given variables have string values, we may want to apply tostring to
their values. In this case, we can use a function as the replacement value:
function expand (s)
  return (string.gsub(s, "$(%w+)", function (n)
  return tostring(_G[n])
  end))
end
print(expand("print = $print; a = $a"))
--> print = function: 0x8050ce0; a = nil
Inside expand, for each match with '$(%w+)', gsub calls the given function with the captured name as
argument; the returned string replaces the match.
The last example goes back to our format converter from the previous section. Again, we want to convert
commands in LaTeX style (\example{text}) to XML style (<example>text</example>), but
allowing nested commands this time. The following function uses recursion to do the job:
function toxml (s)
  s = string.gsub(s, "\\(%a+)(%b{})", function (tag, body)
  body = string.sub(body, 2, -2) -- remove the brackets
  body = toxml(body) -- handle nested commands
  return string.format("<%s>%s</%s>", tag, body, tag)
  end)
return s
end
print(toxml("\\title{The \\bold{big} example}"))
--> <title>The <bold>big</bold> example</title>