--[[
. all characters
%a letters
%c control characters
%d digits
%g printable characters except spaces
%l lower-case letters
%p punctuation characters
%s space characters
%u upper-case letters
%w alphanumeric characters
%x hexadecimal digits

An upper-case version of any of these classes represents the complement of the class. For instance, '%A'
represents all non-letter characters:
print((string.gsub("hello, up-down!", "%A", ".")))
--> hello..up.down.
--]]

--[[
(When printing the results of gsub, I am using extra parentheses to discard its second result, which is
the number of substitutions.)
Some characters, called magic characters, have special meanings when used in a pattern. Patterns in Lua
use the following magic characters:
( ) . % + - * ? [ ] ^ $
As we have seen, the percent sign works as an escape for these magic characters. So, '%?' matches a
question mark and '%%' matches a percent sign itself. We can escape not only the magic characters, but
also any non-alphanumeric character. When in doubt, play safe and use an escape.Pattern Matching
80
A char-set allows us to create our own character classes, grouping single characters and classes inside
square brackets. For instance, the char-set '[%w_]' matches both alphanumeric characters and underscores,
'[01]' matches binary digits, and '[%[%]]' matches square brackets. To count the number of vowels in
a text, we can write this code:
_, nvow = string.gsub(text, "[AEIOUaeiou]", "")
We can also include character ranges in a char-set, by writing the first and the last characters of the range
separated by a hyphen. I seldom use this feature, because most useful ranges are predefined; for instance,
'%d' substitutes '[0-9]', and '%x' substitutes '[0-9a-fA-F]'. However, if you need to find an octal digit,
you may prefer '[0-7]' instead of an explicit enumeration like '[01234567]'.
We can get the complement of any char-set by starting it with a caret: the pattern '[^0-7]' finds any
character that is not an octal digit and '[^\n]' matches any character different from newline. Nevertheless,
remember that you can negate simple classes with its upper-case version: '%S' is simpler than '[^%s]'.
We can make patterns still more useful with modifiers for repetitions and optional parts. Patterns in Lua
offer four modifiers

+ 1 or more repetitions
* 0 or more repetitions
- 0 or more lazy repetitions (非贪婪匹配)
? optional (0 or 1 occurrence)


test = "int x; /* x */ int y; /* y */"
print((string.gsub(test, "/%*.*%*/", "")))
--> int x;

test = "int x; /* x */ int y; /* y */"
print((string.gsub(test, "/%*.-%*/", "")))
--> int x; int y;

The last modifier, the question mark, matches an optional character. As an example, suppose we want to
find an integer in a text, where the number can contain an optional sign. The pattern '[+-]?%d+' does the
job, matching numerals like "-12", "23", and "+1009". The character class '[+-]' matches either a
plus or a minus sign; the following ? makes this sign optional.
Unlike some other systems, in Lua we can apply a modifier only to a character class; there is no way to
group patterns under a modifier. For instance, there is no pattern that matches an optional word (unless
the word has only one letter). Usually, we can circumvent this limitation using some of the advanced
techniques that we will see in the end of this chapter.
If a pattern begins with a caret, it will match only at the beginning of the subject string. Similarly, if it
ends with a dollar sign, it will match only at the end of the subject string. We can use these marks both
to restrict the matches that we find and to anchor patterns. For instance, the next test checks whether the
string s starts with a digit:
if string.find(s, "^%d") then ...
The next one checks whether that string represents an integer number, without any other leading or trailing
characters:
if string.find(s, "^[+-]?%d+$") then ...
The caret and dollar signs are magic only when used in the beginning or end of the pattern. Otherwise,
they act as regular characters matching themselves.
Another item in a pattern is '%b', which matches balanced strings. We write this item as '%bxy', where
x and y are any two distinct characters; the x acts as an opening character and the y as the closing one.
For instance, the pattern '%b()' matches parts of the string that start with a left parenthesis and finish at
the respective right one:
s = "a (enclosed (in) parentheses) line"
print((string.gsub(s, "%b()", ""))) --> a line
Typically, we use this pattern as '%b()', '%b[]', '%b{}', or '%b<>', but we can use any two distinct characters as delimiters.
Finally, the item '%f[char-set]' represents a frontier pattern. It matches an empty string only if the
next character is in char-set but the previous one is not:
s = "the anthem is the theme"
print((string.gsub(s, "%f[%w]the%f[%W]", "one")))
--> one anthem is one theme
The pattern '%f[%w]' matches a frontier between a non-alphanumeric and an alphanumeric character,
and the pattern '%f[%W]' matches a frontier between an alphanumeric and a non-alphanumeric character.
Therefore, the given pattern matches the string "the" only as an entire word. Note that we must write
the char-set inside brackets, even when it is a single class.
The frontier pattern treats the positions before the first and after the last characters in the subject string as
if they had the null character (ASCII code zero). In the previous example, the first "the" starts with a
frontier between a null character, which is not in the set '[%w]', and a t, which is

--]]