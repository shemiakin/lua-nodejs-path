# lua-nodejs-path

![Version](https://badgen.net/static/Version/1.0.0)
![Lua Versions Support](https://badgen.net/badge/Lua/5.1–5.4/green)
![LuaJIT Versions Support](https://badgen.net/static/LuaJIT/2.x/green)
![Stars are welcome](https://badgen.net/static/Stars%20are%20welcome/★/EAC54F)
[![License MIT](https://badgen.net/static/License/MIT/blue)](https://github.com/shemiakin/lua-nodejs-path/blob/v1.0.0/LICENSE)

The module provides utilities for working with file and directory paths. Works similarly to the [NodeJS Path Module](https://nodejs.org/docs/latest-v18.x/api/path.html). Supports lua 5.1–5.4 and LuaJIT 2.x.


---

## Installation

### Luarocks

The simplest way to install `nodejs-path` is with [LuaRocks](https://luarocks.org/modules/shemiakin/nodejs-path):

```shell
luarocks install nodejs-path
```

### Manual

Just copy the `nodejs-path.lua` file somewhere in your projects (maybe inside a `/libs/` folder) and require it accordingly.

## Quickstart

```lua
local path = require('nodejs-path')

local filepath = path.join('somedir', 'somefile.txt')

print('File path. ' .. filepath)
print('is absolute: ' .. tostring(path.isAbsolute(filepath)))
print('File name: ' .. path.parse(filepath).name)
```

## API Reference

[The original documentation for the NodeJS Path module](https://nodejs.org/docs/latest-v18.x/api/path.html).

### Table Of Contents

- [Windows vs. POSIX](#windows-vs-posix)
- [path.basename(path\[, suffix\])](#pathbasenamepath-suffix)
- [path.delimiter](#pathdelimiter)
- [path.dirname(path)](#pathdirnamepath)
- [path.extname(path)](#pathextnamepath)
- [path.format(pathTable)](#pathformatpathtable)
- [path.isAbsolute(path)](#pathisabsolutepath)
- [path.join(...paths)](#pathjoinpaths)
- [path.normalize(path)](#pathnormalizepath)
- [path.parse(path)](#pathparsepath)
- [path.posix](#pathposix)
- [path.relative(from, to)](#pathrelativefrom-to)
- [path.resolve(...paths)](#pathresolvepaths)
- [path.sep](#pathsep)
- [path.toNamespacedPath(path)](#pathtonamespacedpathpath)
- [path.win32](#pathwin32)

### Windows vs. POSIX

The default operation of the module varies based on the operating system on which a Lua application is running. Specifically, when running on a Windows operating system, the module will assume that Windows-style paths are being used.

So using `path.basename()` might yield different results on POSIX and Windows:

On POSIX:

```lua
path.basename('C:\\temp\\myfile.html')
-- Returns: 'C:\\temp\\myfile.html'
```

On Windows:

```lua
path.basename('C:\\temp\\myfile.html')
-- Returns: 'myfile.html'
```

To achieve consistent results when working with Windows file paths on any operating system, use `path.win32`:

On POSIX and Windows:

```lua
path.posix.basename('/tmp/myfile.html')
-- Returns: 'myfile.html'
```

On Windows follows the concept of per-drive working directory. This behavior can be observed when using a drive path without a backslash. For example, `path.resolve('C:\\')` can potentially return a different result than `path.resolve('C:')`. For more information, see this [MSDN page](https://docs.microsoft.com/en-us/windows/desktop/FileIO/naming-a-file#fully-qualified-vs-relative-paths).

[Back to TOC](#table-of-contents).

### path.basename(path[, suffix])

**Parameters**

- `path` *string*
- `suffix` *string*  — an optional suffix to remove

**Returns**
- *string*

The `path.basename()` method returns the last portion of a `path`, similar to the Unix `basename` command. Trailing [directory separators](#pathsep) are ignored.

```lua
path.basename('/foo/bar/baz/asdf/quux.html')
-- Returns: 'quux.html'

path.basename('/foo/bar/baz/asdf/quux.html', '.html')
-- Returns: 'quux'
```

Although Windows usually treats file names, including file extensions, in a case-insensitive manner, this function does not. For example, `C:\\foo.html` and `C:\\foo.HTML` refer to the same file, but `basename` treats the extension as a case-sensitive string:

```lua
path.win32.basename('C:\\foo.html', '.html')
-- Returns: 'foo'

path.win32.basename('C:\\foo.HTML', '.html')
-- Returns: 'foo.HTML'
```

An Error is thrown if `path` is not a string or if `suffix` is given and is not a string.

[Back to TOC](#table-of-contents).

### path.delimiter

- *string*

Provides the platform-specific path delimiter:
- `;` for Windows
- `:` for POSIX

For example, on POSIX:

```lua
print(os.getenv('PATH'))
-- Prints: '/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin'

for segment in string.gmatch(os.getenv('PATH'), "[^" .. path.delimiter .. "]+") do
    print(segment)
end
-- Prints:
-- '/usr/bin'
-- '/bin'
-- '/usr/sbin'
-- '/sbin'
-- '/usr/local/bin'
```

On Windows:

```lua
print(os.getenv('PATH'))
-- Prints: 'C:\Windows\system32;C:\Windows;'

for segment in string.gmatch(os.getenv('PATH'), "[^" .. path.delimiter .. "]+") do
    print(segment)
end
-- Prints:
-- 'C:\\Windows\\system32'
-- 'C:\\Windows'
```

[Back to TOC](#table-of-contents).

### path.dirname(path)

**Parameters**
- `path` *string*

**Returns**
- *string*

The `path.dirname()` method returns the directory name of a path, similar to the Unix dirname command. Trailing directory separators are ignored, see [path.sep](#pathsep).

```lua
path.dirname('/foo/bar/baz/asdf/quux')
-- Returns: '/foo/bar/baz/asdf'
```

An Error is thrown if `path` is not a string.

[Back to TOC](#table-of-contents).

### path.extname(path)

**Parameters**
- `path` *string*

**Returns**
- *string*

The `path.extname()` method returns the extension of the `path`, from the last occurrence of the `.` (period) character to end of string in the last portion of the `path`. If there is no `.` in the last portion of the `path`, or if there are no `.` characters other than the first character of the basename of `path` (see [`path.basename()`](#pathbasenamepath-suffix)), an empty string is returned.

```lua
path.extname('index.html')
-- Returns: '.html'

path.extname('index.coffee.md')
-- Returns: '.md'

path.extname('index.')
-- Returns: '.'

path.extname('index')
-- Returns: ''

path.extname('.index')
-- Returns: ''

path.extname('.index.md')
-- Returns: '.md'
```

An Error is thrown if `path` is not a string.

[Back to TOC](#table-of-contents).

### path.format(pathTable)

**Parameters**
- `pathTable` *table* with the following properties:
  - `dir` *string*
  - `root` *string*
  - `base` *string*
  - `name` *string*
  - `ext` *string*

**Returns**
- *string*

The `path.format()` method returns a path string from a table. This is the opposite of [`path.parse()`](#pathparsepath).

When providing properties to the `pathTable` remember that there are combinations where one property has priority over another:

- `pathTable.root` is ignored if `pathTable.dir` is provided
- `pathTable.ext` and `pathTable.name` are ignored if `pathTable.base` exists

For example, on POSIX:

```lua
-- If `dir`, `root` and `base` are provided, `root` is ignored.
path.format({
  root = '/ignored',
  dir = '/home/user/dir',
  base = 'file.txt',
})
-- Returns: '/home/user/dir/file.txt'

-- `root` will be used if `dir` is not specified.
-- If only `root` is provided or `dir` is equal to `root` then the
-- platform separator will not be included. `ext` will be ignored.
path.format({
  root = '/',
  base = 'file.txt',
  ext = 'ignored',
})
-- Returns: '/file.txt'

-- `name` + `ext` will be used if `base` is not specified.
path.format({
  root = '/',
  name = 'file',
  ext = '.txt',
})
-- Returns: '/file.txt'

-- The dot will be added if it is not specified in `ext`.
path.format({
  root = '/',
  name = 'file',
  ext = 'txt',
})
-- Returns: '/file.txt'
```

On Windows:

```lua
path.format({
  dir = 'C:\\path\\dir',
  base = 'file.txt',
})
-- Returns: 'C:\\path\\dir\\file.txt'
```

[Back to TOC](#table-of-contents).

### path.isAbsolute(path)

**Parameters**
- `path` *string*

**Returns**
- *boolean*

The `path.isAbsolute()` method determines if `path` is an absolute path.

If the given `path` is a zero-length string, false will be returned.

For example, on POSIX:

```lua
path.isAbsolute('/foo/bar') -- true
path.isAbsolute('/baz/..')  -- true
path.isAbsolute('qux/')     -- false
path.isAbsolute('.')        -- false
```

On Windows:

```lua
path.isAbsolute('//server')    -- true
path.isAbsolute('\\\\server')  -- true
path.isAbsolute('C:/foo/..')   -- true
path.isAbsolute('C:\\foo\\..') -- true
path.isAbsolute('bar\\baz')    -- false
path.isAbsolute('bar/baz')     -- false
path.isAbsolute('.')           -- false
```

An Error is thrown if `path` is not a string.

[Back to TOC](#table-of-contents).

### path.join(...paths)

**Parameters**
- `...paths` *string* — a sequence of path segments

**Returns**
- *string*

The `path.join()` method joins all given `path` segments together using the platform-specific separator as a delimiter, then normalizes the resulting path.

Zero-length `path` segments are ignored. If the joined path string is a zero-length string then `.` will be returned, representing the current working directory.

```lua
path.join('/foo', 'bar', 'baz/asdf', 'quux', '..')
-- Returns: '/foo/bar/baz/asdf'

path.join('foo', {}, 'bar')
-- Throws 'Error: The "path" argument must be of type string. Received table'
```

An Error is thrown if any of the path segments is not a string.

[Back to TOC](#table-of-contents).

### path.normalize(path)

**Parameters**
- `path` *string*

**Returns**
- *string*

The `path.normalize()` method normalizes the given `path`, resolving `..` and `.` segments.

When multiple, sequential path segment separation characters are found (e.g. `/` on POSIX and either `\` or `/` on Windows), they are replaced by a single instance of the platform-specific path segment separator (`/` on POSIX and `\` on Windows). Trailing separators are preserved.

If the `path` is a zero-length string, `.` is returned, representing the current working directory.

For example, on POSIX:

```lua
path.normalize('/foo/bar//baz/asdf/quux/..')
-- Returns: '/foo/bar/baz/asdf'
```

On Windows:

```lua
path.normalize('C:\\temp\\\\foo\\bar\\..\\')
-- Returns: 'C:\\temp\\foo\\'
```

Since Windows recognizes multiple path separators, both separators will be replaced by instances of the Windows preferred separator (`\`):

```lua
path.win32.normalize('C:////temp\\\\/\\/\\/foo/bar')
-- Returns: 'C:\\temp\\foo\\bar'
```

An Error is thrown if `path` is not a string.

[Back to TOC](#table-of-contents).

### path.parse(path)

**Parameters**
- `path` *string*

**Returns**
- *table* with the following properties:
  - `dir` *string*
  - `root` *string*
  - `base` *string*
  - `name` *string*
  - `ext` *string*

The `path.parse()` method returns a table whose properties represent significant elements of the `path`. Trailing directory separators are ignored, see [`path.sep`](#pathsep).

For example, on POSIX:

```lua
path.parse('/home/user/dir/file.txt')
-- Returns:
-- {
--   root = '/',
--   dir = '/home/user/dir',
--   base = 'file.txt',
--   ext = '.txt',
--   name = 'file'
-- }
```

On Windows:

```lua
path.parse('C:\\path\\dir\\file.txt')
-- Returns:
-- {
--   root = 'C:\\',
--   dir = 'C:\\path\\dir',
--   base = 'file.txt',
--   ext = '.txt',
--   name = 'file'
-- }
```

An Error is thrown if `path` is not a string.

[Back to TOC](#table-of-contents).

### path.posix

- *table*

The `path.posix` property provides access to POSIX specific implementations of the `path` methods.

### path.relative(from, to)

**Parameters**
- `from` *string*
- `to` *string*

**Returns**
- *string*

The `path.relative()` method returns the relative path from `from` to `to` based on the current working directory. If `from` and `to` each resolve to the same path (after calling `path.resolve()` on each), a zero-length string is returned.

If a zero-length string is passed as `from` or `to`, the current working directory will be used instead of the zero-length strings.

For example, on POSIX:

```lua
path.relative('/data/orandea/test/aaa', '/data/orandea/impl/bbb')
-- Returns: '../../impl/bbb'
```

On Windows:

```lua
path.relative('C:\\orandea\\test\\aaa', 'C:\\orandea\\impl\\bbb')
-- Returns: '..\\..\\impl\\bbb'
```

An Error is thrown if either `from` or `to` is not a string.

[Back to TOC](#table-of-contents).

### path.resolve(...paths)

**Parameters**
- `...paths` *string* — a sequence of paths or path segments

**Returns**
- *string*

The `path.resolve()` method resolves a sequence of paths or path segments into an absolute path.

The given sequence of paths is processed from right to left, with each subsequent path prepended until an absolute path is constructed. For instance, given the sequence of path segments: `/foo`, `/bar`, `baz`, calling `path.resolve('/foo', '/bar', 'baz')` would return `/bar/baz` because `baz` is not an absolute path but `/bar + / + baz` is.

If, after processing all given `path` segments, an absolute path has not yet been generated, the current working directory is used.

The resulting path is normalized and trailing slashes are removed unless the path is resolved to the root directory.

Zero-length `path` segments are ignored.

If no `path` segments are passed, `path.resolve()` will return the absolute path of the current working directory.

```lua
path.resolve('/foo/bar', './baz')
-- Returns: '/foo/bar/baz'

path.resolve('/foo/bar', '/tmp/file/')
-- Returns: '/tmp/file'

path.resolve('wwwroot', 'static_files/png/', '../gif/image.gif')
-- If the current working directory is /home/myself/lua,
-- this returns '/home/myself/lua/wwwroot/static_files/gif/image.gif'
```

An Error is thrown if any of the arguments is not a string.

[Back to TOC](#table-of-contents).

### path.sep

- *string*

Provides the platform-specific path segment separator:

- `\` on Windows
- `/` on POSIX

For example, on POSIX:

```lua
for segment in string.gmatch('foo/bar/baz', "[^" .. path.sep .. "]+") do
    print(segment)
end
-- Prints:
-- 'foo'
-- 'bar'
-- 'baz'
```

On Windows:

```lua
for segment in string.gmatch('foo\\bar\\baz', "[^" .. path.sep .. "]+") do
    print(segment)
end
-- Prints:
-- 'foo'
-- 'bar'
-- 'baz'
```

On Windows, both the forward slash (`/`) and backward slash (`\`) are accepted as path segment separators; however, the path methods only add backward slashes (`\`).

[Back to TOC](#table-of-contents).

### path.toNamespacedPath(path)

**Parameters**
- `path` *string*

**Returns**
- *string*

On Windows systems only, returns an equivalent namespace-prefixed path for the given path. If path is not a string, path will be returned without modifications.

This method is meaningful only on Windows systems. On POSIX systems, the method is non-operational and always returns path without modifications.

[Back to TOC](#table-of-contents).

### path.win32

- *table*

The `path.win32` property provides access to Windows-specific implementations of the `path` methods.

[Back to TOC](#table-of-contents).

## Specs

This project uses [busted](http://olivinelabs.com/busted/) for its specs. If you want to run the specs, you will have to install it first. Then just execute the following:

```shell
busted ./
```

## License

lua-nodejs-path is distributed under the [MIT license](https://github.com/shemiakin/lua-nodejs-path/blob/v1.0.0/LICENSE).
