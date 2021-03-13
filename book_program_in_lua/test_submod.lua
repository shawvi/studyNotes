Submodules and Packages
Lua allows module names to be hierarchical, using a dot to separate name levels. For instance, a module
named mod.sub is a submodule of mod. A package is a complete tree of modules; it is the unit of distribution in Lua.
When we require a module called mod.sub, the function require will query first the table package.loaded and then the table package.preload, using the original module name
"mod.sub" as the key. Here, the dot is just a character like any other in the module name.
However, when searching for a file that defines that submodule, require translates the dot into another
character, usually the system's directory separator (e.g., a slash for POSIX or a backslash for Windows).
After the translation, require searches for the resulting name like any other name. For instance, assume
the slash as the directory separator and the following path:Modules and Packages
138
./?.lua;/usr/local/lua/?.lua;/usr/local/lua/?/init.lua
The call require "a.b" will try to open the following files:
./a/b.lua
/usr/local/lua/a/b.lua
/usr/local/lua/a/b/init.lua
This behavior allows all modules of a package to live in a single directory. For instance, if a package has
modules p, p.a, and p.b, their respective files can be p/init.lua, p/a.lua, and p/b.lua, with
the directory p within some appropriate directory.
The directory separator used by Lua is configured at compile time and can be any string (remember,
Lua knows nothing about directories). For instance, systems without hierarchical directories can use an
underscore as the “directory separator”, so that require "a.b" will search for a file a_b.lua.
Names in C cannot contain dots, so a C library for submodule a.b cannot export a function
luaopen_a.b. Here, require translates the dot into another character, an underscore. So, a C library
named a.b should name its initialization function luaopen_a_b.
As an extra facility, require has one more searcher for loading C submodules. When it cannot find either
a Lua file or a C file for a submodule, this last searcher searches again the C path, but this time looking
for the package name. For example, if the program requires a submodule a.b.c this searcher will look
for a. If it finds a C library for this name, then require looks into this library for an appropriate open
function, luaopen_a_b_c in this example. This facility allows a distribution to put several submodules
together, each with its own open function, into a single C library.
From the point of view of Lua, submodules in the same package have no explicit relationship. Requiring
a module does not automatically load any of its submodules; similarly, requiring a submodule does not
automatically load its parent. Of course, the package implementer is free to create these links if she wants.
For instance, a particular module may start by explicitly requiring one or all of its submodules.