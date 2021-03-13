The first step of require is to check in the table package.loaded whether the module is already
loaded. If so, require returns its corresponding value. Therefore, once a module is loaded, other calls
requiring the same module simply return the same value, without running any code again.
If the module is not loaded yet, require searches for a Lua file with the module name. (This search
is guided by the variable package.path, which we will discuss later.) If it finds such a file, it loads
it with loadfile. The result is a function that we call a loader. (The loader is a function that, when
called, loads the module.)
If require cannot find a Lua file with the module name, it searches for a C library with that name.1 (In
that case, the search is guided by the variable package.cpath.) If it finds a C library, it loads it with
the low-level function package.loadlib, looking for a function called luaopen_modname. The
loader in this case is the result of loadlib, which is the C function luaopen_modname represented
as a Lua function.
No matter whether the module was found in a Lua file or a C library, require now has a loader for
it. To finally load the module, require calls the loader with two arguments: the module name and
the name of the file where it got the loader. (Most modules just ignore these arguments.) If the loader
returns any value, require returns this value and stores it in the package.loaded table, to return
the same value in future calls for this same module. If the loader returns no value, and the table entry
package.loaded[@rep{modname}] is still empty, require behaves as if the module returned
true. Without this correction, a subsequent call to require would run the module again.
To force require into loading the same module twice, we can erase the library entry from
package.loaded:
package.loaded.modname = nil
The next time the module is required, require will do all its work again

A common complaint against require is that it cannot pass arguments to the module being loaded. For
instance, the mathematical module might have an option for choosing between degrees and radians:
-- bad code
local math = require("math", "degree")
The problem here is that one of the main goals of require is to avoid loading a module multiple times.
Once a module is loaded, it will be reused by whatever part of the program that requires it again. There
would be a conflict if the same module were required with different parameters. In case you really want
your module to have parameters, it is better to create an explicit function to set them, like here:
local mod = require "mod"
mod.init(0, 0)
If the initialization function returns the module itself, we can write that code like this:
local mod = require "mod".init(0, 0)
In any case, remember that the module itself is loaded only once; it is up to it to handle conflicting initializations.




in a path are separated by semicolons, a character seldom used for file names in most operating systems.
For instance, consider the following path:
?;?.lua;c:\windows\?;/usr/local/lua/?/?.lua
With this path, the call require "sql" will try to open the following Lua files:
sql
sql.lua
c:\windows\sql
/usr/local/lua/sql/sql.luaModules and Packages
134
The function require assumes only the semicolon (as the component separator) and the question mark;
everything else, including directory separators and file extensions, is defined by the path itself.
The path that require uses to search for Lua files is always the current value of the variable
package.path. When the module package is initialized, it sets this variable with the value of the environment variable LUA_PATH_5_3; if this environment variable is undefined, Lua tries the environment
variable LUA_PATH. If both are unefined, Lua uses a compiled-defined default path.2 When using the
value of an environment variable, Lua substitutes the default path for any substring ";;". For instance, if
we set LUA_PATH_5_3 to "mydir/?.lua;;", the final path will be the template "mydir/?.lua"
followed by the default path.
The path used to search for a C library works exactly in the same way, but its value comes from the variable
package.cpath, instead of package.path. Similarly, this variable gets its initial value from the
environment variables LUA_CPATH_5_3 or LUA_CPATH. A typical value for this path in POSIX is like
this:
./?.so;/usr/local/lib/lua/5.2/?.so
Note that the path defines the file extension. The previous example uses .so for all templates; in Windows,
a typical path would be more like this one:
.\?.dll;C:\Program Files\Lua502\dll\?.dll
The function package.searchpath encodes all those rules for searching libraries. It takes a module
name and a path, and looks for a file following the rules described here. It returns either the name of the
first file that exists or nil plus an error message describing all files it unsuccessfully tried to open, as in
the next example:
> path = ".\\?.dll;C:\\Program Files\\Lua502\\dll\\?.dll"
> print(package.searchpath("X", path))
nil
no file '.\X.dll'
no file 'C:\Program Files\Lua502\dll\X.dll'
