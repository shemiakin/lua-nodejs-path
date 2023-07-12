require('busted.runner')()
local it = require('busted').it
local describe = require('busted').describe
local assert = require('busted').assert

_G.LUA_ENV = 'test'
local path = require('nodejs-path')

local function cwd()
    return os.getenv('PWD') or io.popen('cd'):read()
end

describe('path', function()

    describe('#sep #public', function()
        describe('#posix #sep_posix', function()
            it('', function()
                assert.equal('/', path.posix.sep)
            end)
        end)

        describe('#win32 #sep_win32', function()
            it('', function()
                assert.equal('\\', path.win32.sep)
            end)
        end)
    end)


    describe('#delimiter #public', function()
        describe('#posix #delimiter_posix', function()
            it('', function()
                assert.equal(':', path.posix.delimiter)
            end)
        end)

        describe('#win32 #delimiter_win32', function()
            it('', function()
                assert.equal(';', path.win32.delimiter)
            end)
        end)
    end)


    describe('#basename #public', function()
        describe('#errors #basename_errors', function()
            it('', function()
                assert.has_error(function ()
                    xpcall(path.basename(nil, ''), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received nil')
            end)
            it('', function()
                assert.has_error(function ()
                    xpcall(path.basename('', {}), function (err)
                        error(err)
                    end)
                end, 'The "suffix" argument must be of type string. Received table')
            end)
        end)

        describe('#posix #basename_posix', function()
            it('', function()
                assert.equal('', path.posix.basename(''))
                assert.equal('', path.posix.basename('/'))
                assert.equal('', path.posix.basename('/', 'foo'))
                assert.equal('', path.posix.basename('//'))
            end)
            it('', function()
                assert.equal('.', path.posix.basename('.'))
                assert.equal('.', path.posix.basename('./'))
                assert.equal('.', path.posix.basename('/foo/bar/baz/asdf/quux/..', '.'))
            end)
            it('', function()
                assert.equal('..', path.posix.basename('../'))
                assert.equal('..', path.posix.basename('..'))
                assert.equal('..', path.posix.basename('/foo/bar/baz/asdf/quux/..'))
            end)
            it('', function()
                assert.equal('quux.html', path.posix.basename('/foo/bar/baz/asdf/quux.html'))
                assert.equal('quux.html', path.posix.basename('/foo/bar/baz/asdf/quux.html', '.*'))
            end)
            it('', function()
                assert.equal('quux.html\\', path.posix.basename('/foo/bar/baz/asdf/quux.html\\'))
            end)
            it('', function()
                assert.equal('quux.', path.posix.basename('/foo/bar/baz/asdf/quux.html', 'html'))
            end)
        end)

        describe('#win32 #basename_win32', function()
            it('', function()
                assert.equal('', path.win32.basename('C:\\'))
            end)
            it('', function()
                assert.equal('\\', path.win32.basename('C:\\', 'foo'))
            end)
            it('', function()
                assert.equal('', path.win32.basename('/', 'foo'))
            end)
            it('', function()
                assert.equal('SERIAL', path.win32.basename('\\\\.\\SERIAL\\'))
            end)
            it('', function()
                assert.equal('foo', path.win32.basename('C:\\foo.html', '.html'))
                assert.equal('foo', path.win32.basename('C:\\foo.$()[]%^*', '.$()[]%^*'))
            end)
            it('', function()
                assert.equal('foo.HTML', path.win32.basename('C:\\foo.HTML', '.html'))
            end)
        end)
    end)


    describe('#dirname #public', function()
        describe('#errors #dirname_errors', function()
            it('', function()
                assert.has_error(function ()
                    xpcall(path.dirname(nil), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received nil')
            end)
        end)

        describe('#posix #dirname_posix', function()
            it('', function()
                assert.equal('/foo/bar/baz/asdf', path.posix.dirname('/foo/bar/baz/asdf/quux'))
            end)
            it('', function()
                assert.equal('/foo/bar/baz/asdf/quux', path.posix.dirname('/foo/bar/baz/asdf/quux/..'))
            end)
            it('', function()
                assert.equal('/foo/bar/baz/asdf/quux', path.posix.dirname('/foo/bar/baz/asdf/quux/file.txt'))
            end)
            it('', function()
                assert.equal('/foo/./baz/../quux', path.posix.dirname('/foo/./baz/../quux/.dir'))
            end)
            it('', function()
                assert.equal('/', path.posix.dirname('/foo/'))
            end)
            it('', function()
                assert.equal('/', path.posix.dirname('/'))
                assert.equal('/', path.posix.dirname('//'))
                assert.equal('/', path.posix.dirname('///'))
            end)
            it('', function()
                assert.equal('.', path.posix.dirname('foo'))
                assert.equal('.', path.posix.dirname('foo/'))
                assert.equal('.', path.posix.dirname(''))
                assert.equal('.', path.posix.dirname('.'))
                assert.equal('.', path.posix.dirname('..'))
            end)
        end)

        describe('#win32 #dirname_win32', function()
            it('', function()
                assert.equal('C:\\foo\\bar\\baz', path.win32.dirname('C:\\foo\\bar\\baz\\asdf'))
            end)
            it('', function()
                assert.equal('C:\\', path.win32.dirname('C:\\foo\\'))
                assert.equal('C:\\', path.win32.dirname('C:\\'))
            end)
            it('', function()
                assert.equal('/foo/bar/baz/asdf', path.win32.dirname('/foo/bar/baz/asdf/quux/'))
            end)
            it('', function()
                assert.equal('.', path.win32.dirname(''))
                assert.equal('.', path.win32.dirname('foo'))
            end)
            it('', function()
                assert.equal('\\\\.\\COM1/', path.win32.dirname('\\\\.\\COM1/foo'))
            end)
            it('', function()
                assert.equal('\\\\.\\COM1\\', path.win32.dirname('\\\\.\\COM1\\'))
            end)
        end)
    end)


    describe('#extname #public', function()
        describe('#errors #extname_errors', function()
            it('', function()
                assert.has_error(function ()
                    xpcall(path.extname(nil), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received nil')
            end)
        end)

        describe('#posix #extname_posix', function()
            it('', function()
                assert.equal('.html', path.posix.extname('index.html'))
            end)
            it('', function()
                assert.equal('.md', path.posix.extname('index.coffee.md'))
                assert.equal('.md', path.posix.extname('.index.md'))
            end)
            it('', function()
                assert.equal('.', path.posix.extname('index.'))
            end)
            it('', function()
                assert.equal('', path.posix.extname(''))
                assert.equal('', path.posix.extname('.'))
                assert.equal('', path.posix.extname('..'))
                assert.equal('', path.posix.extname('/'))
                assert.equal('', path.posix.extname('\\'))
                assert.equal('', path.posix.extname('index'))
                assert.equal('', path.posix.extname('.index'))
            end)
        end)

        describe('#win32 #extname_win32', function()
            it('', function()
                assert.equal('.html', path.win32.extname('index.html'))
            end)
            it('', function()
                assert.equal('.md', path.win32.extname('index.coffee.md'))
            end)
            it('', function()
                assert.equal('.MD', path.win32.extname('.index.MD'))
            end)
            it('', function()
                assert.equal('.', path.win32.extname('index.'))
            end)
            it('', function()
                assert.equal('', path.win32.extname(''))
                assert.equal('', path.win32.extname('.'))
                assert.equal('', path.win32.extname('..'))
                assert.equal('', path.win32.extname('/'))
                assert.equal('', path.win32.extname('\\'))
                assert.equal('', path.win32.extname('index'))
                assert.equal('', path.win32.extname('.index'))
            end)
        end)
    end)


    describe('#format #public', function()
        describe('#posix #format_posix', function()
            it('', function()
                assert.equal(
                    '/home/user/dir/file.txt',
                    path.posix.format({
                        root = '/ignored',
                        dir = '/home/user/dir',
                        base = 'file.txt',
                    })
                )
            end)
            it('', function()
                assert.equal(
                    '/file.txt',
                    path.posix.format({
                        root = '/',
                        base = 'file.txt',
                        ext = 'ignored',
                    })
                )
            end)
            it('', function()
                assert.equal(
                    '/file.txt',
                    path.posix.format({
                        root = '/',
                        name = 'file',
                        ext ='.txt',
                    })
                )
            end)
            it('', function()
                assert.equal(
                    '/file.txt',
                    path.posix.format({
                        root = '/',
                        name = 'file',
                        ext = 'txt',
                    })
                )
            end)
        end)

        describe('#win32 #format_win32', function()
            it('', function()
                assert.equal(
                    'C:\\path\\dir\\file.txt',
                    path.win32.format({
                        dir = 'C:\\path\\dir',
                        base = 'file.txt',
                    })
                )
            end)
        end)
    end)


    describe('#isAbsolute #public', function()
        describe('#errors #isAbsolute_errors', function()
            it('', function()
                assert.has_error(function ()
                    xpcall(path.isAbsolute(nil), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received nil')
            end)
            it('', function()
                assert.has_error(function ()
                    xpcall(path.isAbsolute({}), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received table')
            end)
        end)

        describe('#posix #isAbsolute_posix', function()
            it('', function()
                assert.equal(false, path.posix.isAbsolute(''))
            end)
            it('', function()
                assert.equal(true, path.posix.isAbsolute('/foo/bar'))
            end)
            it('', function()
                assert.equal(true, path.posix.isAbsolute('/baz/..'))
            end)
            it('', function()
                assert.equal(false, path.posix.isAbsolute('qux/'))
            end)
            it('', function()
                assert.equal(false, path.posix.isAbsolute('.'))
            end)
            it('', function()
                assert.equal(false, path.posix.isAbsolute('..'))
            end)
        end)

        describe('#win32 #isAbsolute_win32', function()
            it('', function()
                assert.equal(false, path.win32.isAbsolute(''))
            end)
            it('', function()
                assert.equal(true, path.win32.isAbsolute('//server'))
            end)
            it('', function()
                assert.equal(true, path.win32.isAbsolute('\\\\.\\device'))
            end)
            it('', function()
                assert.equal(true, path.win32.isAbsolute('C:/foo/..'))
            end)
            it('', function()
                assert.equal(false, path.win32.isAbsolute('bar\\baz'))
            end)
            it('', function()
                assert.equal(false, path.win32.isAbsolute('bar/baz'))
            end)
            it('', function()
                assert.equal(false, path.win32.isAbsolute('c:'))
            end)
            it('', function()
                assert.equal(false, path.win32.isAbsolute('.'))
            end)
            it('', function()
                assert.equal(false, path.win32.isAbsolute('..'))
            end)
        end)
    end)


    describe('#join #public', function()
        describe('#errors #join_errors', function()
            it('', function()
                assert.has_error(function ()
                    xpcall(path.join('foo', nil, {}), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received nil')
            end)
        end)

        describe('#posix #join_posix', function()
            it('', function()
                assert.equal('.', path.posix.join(''))
            end)
        end)

        describe('#posix #join_posix', function()
            it('', function()
                assert.equal('/foo/bar/baz/asdf', path.posix.join('/foo', 'bar', 'baz/asdf', 'quux', '..'))
            end)
        end)

        describe('#posix #join_posix', function()
            it('', function()
                assert.equal('bar/baz/asdf', path.posix.join('', 'bar', 'baz/asdf', 'quux', '..'))
            end)
        end)

        describe('#win32 #join_win32', function()
            it('', function()
                assert.equal('C:\\foo\\bar\\baz\\asdf', path.win32.join('C:', '/foo', 'bar', 'baz/asdf', 'quux', '..'))
            end)
        end)
    end)


    describe('#normalize #public', function()
        describe('#errors #normalize_errors', function()
            it('', function()
                assert.has_error(function ()
                    xpcall(path.normalize(nil), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received nil')
            end)
            it('', function()
                assert.has_error(function ()
                    xpcall(path.normalize({}), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received table')
            end)
        end)

        describe('#posix #normalize_posix', function()
            it('', function()
                assert.equal('/foo/', path.posix.normalize('/////foo///bar//baz/..///.././///'))
            end)
            it('', function()
                assert.equal('/foo/qux.txt/', path.posix.normalize('//////foo/bar///baz/../.././qux.txt//////'))
            end)
            it('', function()
                assert.equal('/.foo../qux.txt/', path.posix.normalize('//////.foo../bar///baz/../.././qux.txt//////'))
            end)
            it('', function()
                assert.equal('/bar/baz', path.posix.normalize('/foo/../bar/baz'))
            end)
            it('', function()
                assert.equal('/', path.posix.normalize('/../.././'))
            end)
            it('', function()
                assert.equal('../..', path.posix.normalize('../../.'))
            end)
        end)

        describe('#win32 #normalize_win32', function()
            it('', function()
                assert.equal('C:\\temp\\foo\\', path.win32.normalize('C:\\temp\\\\foo\\bar\\..\\'))
            end)
            it('', function()
                assert.equal('C:\\temp\\foo\\bar', path.win32.normalize('C:////temp\\\\/\\/\\/foo/bar'))
            end)
            it('', function()
                assert.equal('C:\\', path.win32.normalize('C:\\temp\\\\..\\..\\.\\'))
            end)
            it('', function()
                assert.equal('\\', path.win32.normalize('/C:\\..\\..\\.\\'))
            end)
            it('', function()
                assert.equal('\\\\C:\\..\\', path.win32.normalize('//C:\\..\\..\\.\\'))
            end)
            it('', function()
                assert.equal('\\C:\\Z:', path.win32.normalize('//\\C:\\Z:'))
            end)
            it('', function()
                assert.equal('C:\\foo\\bar\\baz', path.win32.normalize('C:\\..\\..\\foo\\bar\\baz'))
            end)
            it('', function()
                assert.equal('\\\\.\\COM1\\', path.win32.normalize('\\\\.\\COM1\\foo\\..\\.\\..'))
            end)
            it('', function()
                assert.equal('foo\\bar\\baz', path.win32.normalize('drive\\..\\foo\\bar\\baz'))
            end)
            it('', function()
                assert.equal('\\foo\\bar\\baz', path.win32.normalize('\\drive\\..\\foo\\bar\\baz'))
            end)
            it('', function()
                assert.equal('\\\\drive\\..\\foo\\bar\\baz', path.win32.normalize('\\\\drive\\..\\foo\\bar\\baz'))
            end)
            it('', function()
                assert.equal('C:.', path.win32.normalize('C:'))
            end)
            it('', function()
                assert.equal('C:tempdir\\tmp.txt', path.win32.normalize('C:tempdir\\tmp.txt'))
            end)
            it('', function()
                assert.equal('\\', path.win32.normalize('\\..\\..\\.\\'))
            end)
            it('', function()
                assert.equal('\\', path.win32.normalize('\\..\\..\\./'))
            end)
            it('', function()
                assert.equal('..\\..', path.win32.normalize('..\\..\\.'))
            end)
        end)
    end)


    describe('#parse #public', function()
        describe('#errors #parse_errors', function()
            it('', function()
                assert.has_error(function ()
                    xpcall(path.parse(nil), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received nil')
            end)
            it('', function()
                assert.has_error(function ()
                    xpcall(path.parse({}), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received table')
            end)
        end)

        describe('#posix #parse_posix', function()
            it('', function()
                assert.are.same({
                    root = '/',
                    dir = '/home/user/dir',
                    base = 'file.txt',
                    ext = '.txt',
                    name = 'file'
                }, path.posix.parse('/home/user/dir/file.txt'))
            end)
            it('', function()
                assert.are.same({
                    root = '',
                    dir = './home/user/dir',
                    base = 'file.txt',
                    ext = '.txt',
                    name = 'file'
                }, path.posix.parse('./home/user/dir/file.txt'))
            end)
            it('', function()
                assert.are.same({
                    root = '',
                    dir = '',
                    base = '\\home\\user\\dir\\file.txt',
                    ext = '.txt',
                    name = '\\home\\user\\dir\\file'
                }, path.posix.parse('\\home\\user\\dir\\file.txt'))
            end)
        end)

        describe('#win32 #parse_win32', function()
            it('', function()
                assert.are.same({
                    root = 'C:\\',
                    dir = 'C:\\path\\dir',
                    base = 'file.txt',
                    ext = '.txt',
                    name = 'file'
                }, path.win32.parse('C:\\path\\dir\\file.txt'))
            end)
            it('', function()
                assert.are.same({
                    root = 'C:/',
                    dir = 'C:/path/dir',
                    base = 'file.txt',
                    ext = '.txt',
                    name = 'file'
                }, path.win32.parse('C:/path/dir/file.txt'))
            end)
            it('', function()
                assert.are.same({
                    root = '//C:\\..\\',
                    dir = '//C:\\..\\..',
                    base = '.',
                    ext = '',
                    name = '.'
                }, path.win32.parse('//C:\\..\\..\\.\\'))
            end)
        end)
    end)


    describe('#relative #public', function()
        describe('#errors #relative_errors', function()
            it('', function()
                assert.has_error(function ()
                    xpcall(path.relative(nil, ''), function (err)
                        error(err)
                    end)
                end, 'The "from" argument must be of type string. Received nil')
            end)
            it('', function()
                assert.has_error(function ()
                    xpcall(path.relative('', nil), function (err)
                        error(err)
                    end)
                end, 'The "to" argument must be of type string. Received nil')
            end)
        end)

        describe('#posix #relative_posix', function()
            it('', function()
                assert.equal('../../impl/bbb', path.posix.relative('/data/orandea/test/aaa', '/data/orandea/impl/bbb'))
            end)
            it('', function()
                assert.equal('../orandea/impl/bbb', path.posix.relative('/data/aaa', '/data/orandea/impl/bbb'))
            end)
            it('', function()
                assert.equal('orandea/impl/bbb', path.posix.relative('/data', '/data/orandea/impl/bbb'))
            end)
            it('', function()
                assert.equal('', path.posix.relative('/', '/'))
            end)
            it('', function()
                assert.equal('../../../../foo', path.posix.relative('/data/orandea/impl/bbb', '/foo'))
            end)
            it('', function()
                assert.equal('../../..', path.posix.relative('/data/orandea/impl/bbb', '/data'))
            end)
        end)

        describe('#win32 #relative_win32', function()
            it('', function()
                assert.equal('..\\..\\impl\\bbb', path.win32.relative('C:\\orandea\\test\\aaa', 'C:\\orandea\\impl\\bbb'))
            end)
        end)
    end)


    describe('#resolve #public', function()
        describe('#errors #resolve_errors', function()
            it('', function()
                assert.has_error(function ()
                    xpcall(path.resolve('foo', nil, {}), function (err)
                        error(err)
                    end)
                end, 'The "path" argument must be of type string. Received nil')
            end)
        end)

        describe('#posix #resolve_posix', function()
            it('', function()
                assert.equal('/foo/bar/baz', path.posix.resolve('/foo/bar', './baz'))
            end)
            it('', function()
                assert.equal('/tmp/file', path.posix.resolve('/foo/bar', '/tmp/file/'))
            end)
            it('', function()
                assert.equal(cwd()..'/wwwroot/static_files/gif/image.gif', path.posix.resolve('wwwroot', 'static_files/png/', '../gif/image.gif'))
            end)
        end)

        describe('#win32 #resolve_win32', function()
            -- TODO
        end)
    end)


    describe('#toNamespacedPath #public', function()
        describe('#posix #toNamespacedPath_posix', function()
            it('', function()
                assert.equal('', path.posix.toNamespacedPath(''))
            end)
            it('', function()
                assert.equal('.', path.posix.toNamespacedPath('.'))
            end)
            it('', function()
                assert.equal('..', path.posix.toNamespacedPath('..'))
            end)
            it('', function()
                assert.equal('/', path.posix.toNamespacedPath('/'))
            end)
            it('', function()
                assert.are.same({}, path.posix.toNamespacedPath({}))
            end)
        end)

        describe('#win32 #toNamespacedPath_win32', function()
            it('', function()
                assert.equal('', path.win32.toNamespacedPath(''))
            end)
            it('', function()
                assert.equal('.', path.win32.toNamespacedPath('.'))
            end)
            it('', function()
                assert.equal('..', path.win32.toNamespacedPath('..'))
            end)
            it('', function()
                assert.equal('/', path.win32.toNamespacedPath('/'))
            end)
            it('', function()
                assert.equal('/COM1', path.win32.toNamespacedPath('/COM1'))
            end)
            it('', function()
                assert.equal('\\COM1', path.win32.toNamespacedPath('\\COM1'))
            end)
            it('', function()
                assert.are.same({}, path.win32.toNamespacedPath({}))
            end)
            it('', function()
                assert.equal('\\\\?\\C:\\Windows\\users', path.win32.toNamespacedPath('C:\\Windows\\users'))
            end)
            it('', function()
                assert.equal('\\\\?\\C:\\Windows\\admin', path.win32.toNamespacedPath('C:\\Windows\\users\\..\\admin'))
            end)
        end)
    end)


    describe('#getRoot #private', function()
        describe('#posix #getRoot_posix', function()
            it('', function()
                assert.equal('/', path.posix.private.getRootInfo('/').path)
                assert.equal('/', path.posix.private.getRootInfo('//').path)
                assert.equal('/', path.posix.private.getRootInfo('/foo').path)
                assert.equal('/', path.posix.private.getRootInfo('/foo/bar/baz').path)
            end)
            it('', function()
                assert.equal(nil, path.posix.private.getRootInfo(''))
                assert.equal(nil, path.posix.private.getRootInfo('.'))
                assert.equal(nil, path.posix.private.getRootInfo('..'))
            end)
        end)

        describe('#win32 #getRoot_win32', function()
            it('', function()
                assert.equal('C:\\', path.win32.private.getRootInfo('C:\\').path)
                assert.equal('C:\\', path.win32.private.getRootInfo('C:\\foo').path)
                assert.equal('C:\\', path.win32.private.getRootInfo('C:\\foo\\bar\\baz').path)
            end)
            it('', function()
                assert.equal('C:/', path.win32.private.getRootInfo('C:/').path)
                assert.equal('C:/', path.win32.private.getRootInfo('C:/foo').path)
                assert.equal('C:/', path.win32.private.getRootInfo('C:/foo/bar/baz').path)
            end)
            it('', function()
                assert.equal('C:/', path.win32.private.getRootInfo('C:/').path)
                assert.equal('C:/', path.win32.private.getRootInfo('C:/foo').path)
                assert.equal('C:/', path.win32.private.getRootInfo('C:/foo/bar/baz').path)
            end)
            it('', function()
                assert.equal('\\\\.\\COM56', path.win32.private.getRootInfo('\\\\.\\COM56').path)
            end)
            it('', function()
                assert.equal('//./COM56', path.win32.private.getRootInfo('//./COM56').path)
            end)
        end)
    end)


    describe('#isRoot #private', function()
        describe('#posix #isRoot_posix', function()
            it('', function()
                assert.equal(true, path.posix.private.isRoot('/'))
            end)
            it('', function()
                assert.equal(false, path.posix.private.isRoot('\\'))
                assert.equal(false, path.posix.private.isRoot('C:\\'))
                assert.equal(false, path.posix.private.isRoot('C:/'))
                assert.equal(false, path.posix.private.isRoot('\\\\.\\COM56'))
                assert.equal(false, path.posix.private.isRoot('//./COM56'))
                assert.equal(false, path.posix.private.isRoot('C:/foo'))
                assert.equal(false, path.posix.private.isRoot('C:/foo/bar/baz'))
                assert.equal(false, path.posix.private.isRoot('C:\\foo'))
                assert.equal(false, path.posix.private.isRoot('C:\\foo\\bar\\baz'))
            end)
        end)

        describe('#win32 #isRoot_win32', function()
            it('', function()
                assert.equal(true, path.win32.private.isRoot('C:\\'))
                assert.equal(true, path.win32.private.isRoot('C:/'))
                assert.equal(true, path.win32.private.isRoot('\\\\.\\COM56'))
                assert.equal(true, path.win32.private.isRoot('\\\\?\\C:\\'))
                assert.equal(true, path.win32.private.isRoot('\\\\?\\C:/'))
                assert.equal(true, path.win32.private.isRoot('\\\\?\\C:'))
                assert.equal(true, path.win32.private.isRoot('\\\\.\\C:'))
                assert.equal(true, path.win32.private.isRoot('//./COM56'))
                assert.equal(true, path.win32.private.isRoot('\\\\?/COM\\'))
                assert.equal(true, path.win32.private.isRoot('/'))
                assert.equal(true, path.win32.private.isRoot('\\'))
            end)
            it('', function()
                assert.equal(false, path.win32.private.isRoot('\\\\.'))
                assert.equal(false, path.win32.private.isRoot('\\\\.\\'))
                assert.equal(false, path.win32.private.isRoot('\\\\COM\\'))
                assert.equal(false, path.win32.private.isRoot('C:/foo'))
                assert.equal(false, path.win32.private.isRoot('C:/foo/bar/baz'))
                assert.equal(false, path.win32.private.isRoot('C:\\foo'))
                assert.equal(false, path.win32.private.isRoot('C:\\foo\\bar\\baz'))
            end)
        end)
    end)


    describe('#getPathDataList #private', function()
        describe('#posix #getPathDataList_posix', function()
            it('', function()
                assert.are.same(
                    {
                        rootSegment = '/',
                        segments = {},
                        isAbsolute = true,
                    },
                    path.posix.private.getPathDataList('/')
                )
            end)
        end)

        describe('#win32 #getPathDataList_win32', function()
            it('', function()
                assert.are.same(
                    {
                        rootSegment = 'C:\\',
                        segments = {},
                        isAbsolute = true,
                    },
                    path.win32.private.getPathDataList('C:\\')
                )
            end)
            it('', function()
                assert.are.same(
                    {
                        rootSegment = '/',
                        segments = { 'foo', 'bar', 'baz', '..', '..', '.' },
                        isAbsolute = true,
                    },
                    path.win32.private.getPathDataList('/////foo///bar//baz/..///.././///')
                )
            end)
            it('', function()
                assert.are.same(
                    {
                        rootSegment = 'C:\\',
                        segments = { 'foo', 'bar', 'baz' },
                        isAbsolute = true,
                    },
                    path.win32.private.getPathDataList('C:\\foo\\bar\\baz')
                )
            end)
            it('', function()
                assert.are.same(
                    {
                        rootSegment = '//C:\\..\\',
                        segments = { '..', '.' },
                        isAbsolute = true,
                    },
                    path.win32.private.getPathDataList('//C:\\..\\..\\.\\')
                )
            end)
            it('', function()
                assert.are.same(
                    {
                        rootSegment = '',
                        segments = { 'drive', '..', 'foo', 'bar', 'baz' },
                        isAbsolute = false,
                    },
                    path.win32.private.getPathDataList('drive\\..\\foo\\bar\\baz')
                )
            end)
            it('', function()
                assert.are.same(
                    {
                        rootSegment = '\\\\drive\\..\\',
                        segments = { 'foo', 'bar', 'baz' },
                        isAbsolute = true,
                    },
                    path.win32.private.getPathDataList('\\\\drive\\..\\foo\\bar\\baz')
                )
            end)
        end)
    end)


    describe('#handleJumps #private', function()
        describe('#posix #handleJumps_posix', function()
            it('', function()
                assert.are.same(
                    {},
                    path.posix.private.handleJumps({
                        segments = {},
                    }).segments
                )
            end)
            it('', function()
                assert.are.same(
                    { 'foo', 'bar' },
                    path.posix.private.handleJumps({
                        segments = { 'foo', 'bar', 'baz', '..', '.' },
                    }).segments
                )
            end)
            it('', function()
                assert.are.same(
                    { '..', '..', '..' },
                    path.posix.private.handleJumps({
                        isAbsolute = false,
                        segments = { '..', '..', '.', '..' },
                    }).segments
                )
            end)
        end)

        describe('#win32 #handleJumps_win32', function()
            it('', function()
                assert.are.same(
                    {},
                    path.win32.private.handleJumps({
                        segments = {},
                    }).segments
                )
            end)
            it('', function()
                assert.are.same(
                    { 'foo' },
                    path.win32.private.handleJumps({
                        segments = { 'foo', 'bar', 'baz', '..', '..', '.' },
                    }).segments
                )
            end)
            it('', function()
                assert.are.same(
                    { 'foo', 'bar', 'baz' },
                    path.win32.private.handleJumps({
                        segments = { 'foo', 'bar', 'baz' },
                    }).segments
                )
            end)
            it('', function()
                assert.are.same(
                    {},
                    path.win32.private.handleJumps({
                        segments = { '..', '.' },
                    }).segments
                )
            end)
            it('', function()
                assert.are.same(
                    { 'foo', 'bar', 'baz' },
                    path.win32.private.handleJumps({
                        segments = { 'drive', '..', 'foo', 'bar', 'baz' },
                    }).segments
                )
            end)
            it('', function()
                assert.are.same(
                    { 'baz' },
                    path.win32.private.handleJumps({
                        segments = { 'foo', '..', 'baz' },
                    }).segments
                )
            end)
        end)
    end)


    describe('#parseNameAndExt #private', function()
        describe('#posix #parseNameAndExt_posix', function()
            it('', function()
                local name, ext = path.posix.private.parseNameAndExt('foo.bar')
                assert.are.equal('foo', name)
                assert.are.equal('.bar', ext)
            end)
        end)

        describe('#win32 #parseNameAndExt_win32', function()
            it('', function()
                local name, ext = path.win32.private.parseNameAndExt('foo.bar')
                assert.are.equal('foo', name)
                assert.are.equal('.bar', ext)
            end)
            it('', function()
                local name, ext = path.win32.private.parseNameAndExt('foo bar.baz')
                assert.are.equal('foo bar', name)
                assert.are.equal('.baz', ext)
            end)
            it('', function()
                local name, ext = path.win32.private.parseNameAndExt('foobar')
                assert.are.equal('foobar', name)
                assert.are.equal('', ext)
            end)
            it('', function()
                local name, ext = path.win32.private.parseNameAndExt('')
                assert.are.equal('', name)
                assert.are.equal('', ext)
            end)
            it('', function()
                local name, ext = path.win32.private.parseNameAndExt('.')
                assert.are.equal('.', name)
                assert.are.equal('', ext)
            end)
            it('', function()
                local name, ext = path.win32.private.parseNameAndExt('..')
                assert.are.equal('..', name)
                assert.are.equal('', ext)
            end)
            it('', function()
                local name, ext = path.win32.private.parseNameAndExt('.foo')
                assert.are.equal('.foo', name)
                assert.are.equal('', ext)
            end)
            it('', function()
                local name, ext = path.win32.private.parseNameAndExt('..foo')
                assert.are.equal('.', name)
                assert.are.equal('.foo', ext)
            end)
            it('', function()
                local name, ext = path.win32.private.parseNameAndExt('.foo.bar.baz')
                assert.are.equal('.foo.bar', name)
                assert.are.equal('.baz', ext)
            end)
            it('', function()
                local name, ext = path.win32.private.parseNameAndExt('.foo.bar.baz.')
                assert.are.equal('.foo.bar.baz', name)
                assert.are.equal('.', ext)
            end)
        end)
    end)
end)
