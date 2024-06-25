vim9script

import autoload '../autoload/zf.vim'

command -nargs=? -complete=dir ZfFind      zf.Find(empty(<q-args>) ? getcwd() : <q-args>, 'edit', '')
command -nargs=? -complete=dir ZfFindSplit zf.Find(empty(<q-args>) ? getcwd() : <q-args>, 'split', <q-mods>)

command -nargs=+ -complete=file ZfGrep      zf.Grep('buffer', '', <q-args>)
command -nargs=+ -complete=file ZfGrepSplit zf.Grep('sbuffer', <q-mods>, <q-args>)

command -bar -bang ZfBuffer      zf.Buffers('buffer', <bang>0, '')
command -bar -bang ZfBufferSplit zf.Buffers('sbuffer', <bang>0, <q-mods>)

command -bar -bang ZfMarks      zf.Marks(<bang>0)
command -bar -bang ZfMarksSplit zf.Marks(<bang>0, <q-mods>)

command -bar ZfOldfiles      zf.Oldfiles('edit', '')
command -bar ZfOldfilesSplit zf.Oldfiles('split', <q-mods>)

command -bar ZfArgs      zf.Arg('edit', false, '')
command -bar ZfArgsSplit zf.Arg('split', false, <q-mods>)

command -bar ZfLargs      zf.Arg('edit', true, '')
command -bar ZfLargsSplit zf.Arg('split', true, <q-mods>)

command -bar ZfTjump      zf.Tags('tjump', '')
command -bar ZfTjumpSplit zf.Tags('stjump', <q-mods>)

command -bar ZfHelp zf.Help('help', <q-mods>)
