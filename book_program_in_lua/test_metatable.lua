For each arithmetic operator there is a corresponding metamethod name. Besides addition and multiplication, there are metamethods for subtraction (__sub), float division (__div), floor division (__idiv),
negation (__unm), modulo (__mod), and exponentiation (__pow). Similarly, there are metamethods for
all bitwise operations: bitwise AND (__band), OR (__bor), exclusive OR (__bxor), NOT (__bnot),
left shift (__shl), and right shift (__shr). We may define also a behavior for the concatenation operator,
with the field __concat.


Metatables also allow us to give meaning to the relational operators, through the metamethods __eq
(equal to), __lt (less than), and __le (less than or equal to). There are no separate metamethods for
the other three relational operators: Lua translates a ~= b to not (a == b), a > b to b < a,
and a >= b to b <= a.