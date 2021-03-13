--[[
In this example, we use three captures, one for each sequence of digits.
In a pattern, an item like '%n', where n is a single digit, matches only a copy of the n-th capture. As a
typical use, suppose we want to find, inside a string, a substring enclosed between single or double quotes.
We could try a pattern such as '["'].-["']', that is, a quote followed by anything followed by another
quote; but we would have problems with strings like "it's all right". To solve this problem, we
can capture the first quote and use it to specify the second one:
s = [[then he said: "it's all right"!]]
q, quotedPart = string.match(s, "([\"'])(.-)%1")
print(quotedPart) --> it's all right
print(q) --> "
The first capture is the quote character itself and the second capture is the contents of the quote (the
substring matching the '.-').
A similar example is this pattern, which matches long strings in Lua:
%[(=*)%[(.-)%]%1%]
It will match an opening square bracket followed by zero or more equals signs, followed by another opening
square bracket, followed by anything (the string content), followed by a closing square bracket, followed
by the same number of equals signs, followed by another closing square bracket:
p = "%[(=*)%[(.-)%]%1%]"
s = "a = [=[[[ something ]] ]==] ]=]; print(a)"
print(string.match(s, p)) --> = [[ something ]] ]==]
The first capture is the sequence of equals signs (only one sign in this example); the second is the string
content.
The third use of captured values is in the replacement string of gsub. Like the pattern, the replacement
string can also contain items like "%n", which are changed to the respective captures when the substituPattern Matching
83
tion is made. In particular, the item "%0" becomes the whole match. (By the way, a percent sign in the
replacement string must be escaped as "%%".) As an example, the following command duplicates every
letter in a string, with a hyphen between the copies:
print((string.gsub("hello Lua!", "%a", "%0-%0")))
--> h-he-el-ll-lo-o L-Lu-ua-a!
This one interchanges adjacent characters:
print((string.gsub("hello Lua", "(.)(.)", "%2%1")))
--> ehll ouLa
As a more useful example, let us write a primitive format converter, which gets a string with commands
written in a LaTeX style and changes them to a format in XML style:
\command{some text} --> <command>some text</command>
If we disallow nested commands, the following call to string.gsub does the job:
s = [[the \quote{task} is to \em{change} that.]]
s = string.gsub(s, "\\(%a+){(.-)}", "<%1>%2</%1>")
print(s)
--> the <quote>task</quote> is to <em>change</em> that.
(In the next section, we will see how to handle nested commands.)
Another useful example is how to trim a string:
function trim (s)
s = string.gsub(s, "^%s*(.-)%s*$", "%1")
return s
end
Note the judicious use of pattern modifiers. The two anchors (^ and $) ensure that we get the whole string.
Because the '.-' in the middle tries to expand as little as possible, the two enclosing patterns '%s*' match
all spaces at both extremities.
--]]