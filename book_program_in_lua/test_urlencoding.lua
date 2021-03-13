Our next example will use URL encoding, which is the encoding used by HTTP to send parameters embedded in a URL. This encoding represents special characters (such as =, &, and +) as "%xx", where xx
is the character code in hexadecimal. After that, it changes spaces to plus signs. For instance, it encodes
the string "a+b = c" as "a%2Bb+%3D+c". Finally, it writes each parameter name and parameter value
with an equals sign in between and appends all resulting pairs name = value with an ampersand in
between. For instance, the values
name = "al"; query = "a+b = c"; q="yes or no"
are encoded as "name=al&query=a%2Bb+%3D+c&q=yes+or+no".
Now, suppose we want to decode this URL and store each value in a table, indexed by its corresponding
name. The following function does the basic decoding:
function unescape (s)
  s = string.gsub(s, "+", " ")
  s = string.gsub(s, "%%(%x%x)", function (h)
    return string.char(tonumber(h, 16))
  end)
  return s
end
print(unescape("a%2Bb+%3D+c")) --> a+b = c
The first gsub changes each plus sign in the string to a space. The second gsub matches all two-digit
hexadecimal numerals preceded by a percent sign and calls an anonymous function for each match. This
function converts the hexadecimal numeral into a number (using tonumber with base 16) and returns
the corresponding character (string.char).
To decode the pairs name=value, we use gmatch. Because neither names nor values can contain either
ampersands or equals signs, we can match them with the pattern '[^&=]+':
cgi = {}
function decode (s)
  for name, value in string.gmatch(s, "([^&=]+)=([^&=]+)") do
    name = unescape(name)
    value = unescape(value)
    cgi[name] = value
  end
end
The call to gmatch matches all pairs in the form name=value. For each pair, the iterator returns the
corresponding captures (as marked by the parentheses in the matching string) as the values for name and
value. The loop body simply applies unescape to both strings and stores the pair in the cgi table.
The corresponding encoding is also easy to write. First, we write the escape function; this function
encodes all special characters as a percent sign followed by the character code in hexadecimal (the format
option "%02X" makes a hexadecimal number with two digits, using 0 for padding), and then changes
spaces to plus signs:
function escape (s)
  s = string.gsub(s, "[&=+%%%c]", function (c)
    return string.format("%%%02X", string.byte(c))
  end)
  s = string.gsub(s, " ", "+")
  return s
end
The encode function traverses the table to be encoded, building the resulting string:
function encode (t)
  local b = {}
  for k,v in pairs(t) do
    b[#b + 1] = (escape(k) .. "=" .. escape(v))
  end
  -- concatenates all entries in 'b', separated by "&"
  return table.concat(b, "&")
end
t = {name = "al", query = "a+b = c", q = "yes or no"}
print(encode(t)) --> q=yes+or+no&query=a%2Bb+%3D+c&name=al