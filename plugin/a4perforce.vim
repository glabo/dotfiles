"
" a4perforce.vim - Vim7 plugin script for perforce commands
" Author: Senthil Krishnamurthy
" Last updated: Feb 27 2012
"
" The following ex commands can be used to interact with perforce
"
"   AAncestry - Get the ancestory for the specified file
"   AAnnotate - Get the revisions for the specified file
"   ADiff - Show the diff for the current file
"   AEdit - Checkout the specified file
"   AFilelog - Show the change history for the specified file
"   AFstat - Get stat for the specified file
"   AOpened - List all the checked out files in the current workspace
"   AProjectDiff - Show the diff for the current project
"   ARevert - Uncheckout the specified file
"   AWs - Display the current project name
"
" Most of the above commands take a filename argument.  If the filename
" is not supplied, then the current file will be used for the operation.
"

" Has this already been loaded?
if exists("loaded_a4perforce")
    finish
endif
let loaded_a4perforce=1

" Syntax color the output from various commands
function! A4PERFORCEOutputSyntax()
    "echo "XXX: a4perforce syntax"
    syntax clear
    if matchstr(bufname(""), 'A4DIFF') != ""
        set filetype=diff
    endif
    syntax match OutputFile "^//.*#"me=e-1
    highlight link OutputFile DiffLine
endfunction

function! A4GetFilename(line_text)
    let path = matchstr(a:line_text, '[^#]\+')
    let items = split(path, '/')
    let filename = items[1] . '/' . join(items[3:], '/')
    return filename
endfunction

" Process one of the command output lines
function! A4PERFORCEProcessCmdOutputLine(line_text)
    echo a:line_text
    if matchstr(a:line_text, '^//src/[^#]\+#\d\+') != ""
       let filename = A4GetFilename(a:line_text)
       let linenumber = 1
    elseif matchstr(a:line_text, '^--- //src') != ""
       let items = split(a:line_text)
       let filename = A4GetFilename(items[1])
       let linenumber = 1
    elseif matchstr(a:line_text, '^+++ src') != ""
       let path = split(a:line_text)
       let items = split(path[1], '/')
       let filename = items[1] . '/' . join(items[2:], '/')
       let linenumber = 1
    else
       let lnum = search('@@', 'bn')
       if lnum == 0
            return []
       endif
       let prev_line = getline(lnum)
       let ranges = split(prev_line)
       let linenumber = matchstr(ranges[2], '\d\+', 1)
       let lnum = search('---', 'bn')
       let line = getline(lnum)
       let items = split(line)
       let filename = A4GetFilename(items[1])
    endif
    return [filename, linenumber]
endfunction

" Edit the following settings to change the command used to get the
" differences between the file in the current project and that in the perforce
" repository.

" The 'diff_file_cmd' is used to get the differences for a file
let s:diff_file_cmd = 'a4 diff'
" The 'diff_proj_cmd' is used to get the differences for the entire project
let s:diff_proj_cmd = "a4 project diff"
" The patch program to use patch files
let s:patch_cmd = "patch"

"----------------------- Do not edit after this line -------------------
" Checkout a file
function! s:A4_edit(...)

    let fname = (a:0 == 0) ? expand("%") : a:1

    if !IsValidFileName(fname)
        return
    endif

    echo "Opening " . fname . " for edit ..."

    " Run the command and get the output
    let cmd = "a4 edit " . fname
    let cmd_output = system(cmd)

    echo "File " . fname . " opened for edit"

    " Re-edit the current file, if the current file is checked out.
    " Fail, if the file is already modified
    if fname == expand("%")
        edit
    endif
endfunction

" Uncheckout the current file
function! s:A4_revert(...)

    let fname = (a:0 == 0) ? expand("%") : a:1

    if !IsValidFileName(fname)
        return
    endif

    echo "Reverting " . fname . " ..."

    let cmd = "a4 revert " . fname
    let cmd_output = system(cmd)

    if IsCmdError(cmd_output)
        return
    endif

    echo "File " . fname . " reverted"

    " Re-edit the current file
    " Fail, if the file is already modified
    edit
endfunction

" List all the checked out files in VOB
function! s:A4_opened()
    echo "Getting a list of opened files in the current project ..."

    let bufname = "_VPLUGIN__._A4OPENED_.A4PERFORCE"
    let cmd = "a4 opened"

    let retval = RunCommand(cmd, bufname)
    if retval == -1
        call WarnMsg("No file opened for edit in this workspace")
        return
    endif
endfunction

function! s:A4_annotate(...)
    let fname = (a:0 == 0) ? expand("%") : a:1

    if !IsValidFileName(fname)
        return
    endif

    echo "Getting annotate for " . fname . " ..."

    " Run the command and get the output
    let cmd = "a4 annotate -i " . fname
    let cmd_output = system(cmd)

    " Command produced no output
    if cmd_output == ""
        return
    endif

    if IsCmdError(cmd_output)
        return
    endif

    " Creat a new window and add the output
    new

    silent 0put =cmd_output

    " Goto the first line
    go

    " Mark the buffer as a temporary buffer
    call MarkScratchBuffer()
endfunction

function! s:A4_filelog(...)
    let fname = (a:0 == 0) ? expand("%") : a:1

    if !IsValidFileName(fname)
        return
    endif

    echo "Getting filelog for " . fname . " ..."

    " Run the command and get the output
    let cmd = "a4 filelog -h " . fname . " | grep change "
    let cmd_output = system(cmd)

    " Command produced no output
    if cmd_output == ""
        return
    endif

    if IsCmdError(cmd_output)
        return
    endif

    " Creat a new window and add the output
    new

    silent 0put =cmd_output

    " Goto the first line
    go

    " Mark the buffer as a temporary buffer
    call MarkScratchBuffer()
endfunction

" Get the history for the current file
function! s:A4_ancestry(...)

    let fname = (a:0 == 0) ? expand("%") : a:1

    if !IsValidFileName(fname)
        return
    endif

    echo "Getting ancestry for " . fname . " ..."

    " Run the command and get the output
    let cmd = "a4 ancestry " . fname
    let cmd_output = system(cmd)

    " Command produced no output
    if cmd_output == ""
        return
    endif

    if IsCmdError(cmd_output)
        return
    endif

    " Creat a new window and add the output
    new

    silent 0put =cmd_output

    " Goto the first line
    go

    " Mark the buffer as a temporary buffer
    call MarkScratchBuffer()
endfunction

function! s:A4_fstat(...)

    let fname = (a:0 == 0) ? expand("%") : a:1

    if !IsValidFileName(fname)
        return
    endif

    echo "Getting fstat information for " . fname . " ..."

    " Run the command and get the output
    let cmd = "a4 fstat " . fname
    let cmd_output = system(cmd)

    " Command produced no output
    if cmd_output == ""
        return
    endif

    if IsCmdError(cmd_output)
        return
    endif

    echo cmd_output
endfunction

function! s:Ct_PatchExpr()
    " adds the -R flag to patch
    let cmd = s:patch_cmd . " -R -c -o " . v:fname_out . ' ' . v:fname_in
    let cmd = cmd . ' < ' . v:fname_diff
    call system(cmd)
endfunction

" Do a perforce diff on a file
" If no filename is supplied, do a diff on the current file
" Otherwise do a diff on the specified file
function! s:A4_vimdiff(...)

    if a:0 == 0
        let fname = expand("%")
    else
        let fname = a:1
        execute "new " .  fname
    endif

    if !IsValidFileName(fname)
        return
    endif

    let patchexpr = &patchexpr
    set patchexpr=s:Ct_PatchExpr()

    " Get the diff output in a temporary file
    let diff_file = tempname()
    let cmd = s:diff_file_cmd . ' ' . fname . ' > ' . diff_file

    echo "Getting the diff output for " . fname . " ..."
    let cmd_output = system(cmd)

    if IsCmdError(cmd_output)
        call delete(diff_file)
        let &patchexpr = patchexpr
        return
    endif

    if 0 == getfsize(diff_file) 
        " there are no differences
        exe 'echo "' . fname . ' is up to date"'
    else
        " Show the differences using Vim diff
        exe 'silent! vert diffpatch ' . diff_file
        let ofname = expand("%")
        execute "file __" . fname . ".prev__"
        setlocal nomodifiable
        execute "bwipeout " . ofname
    endif

    " Remove the temporary file
    call delete(diff_file)
    let &patchexpr = patchexpr
endfunction

" Show the diff for the current file
function! s:A4_diff(...)

    let fname = (a:0 == 0) ? expand("%") : a:1

    let fdiff = fname
    if fname == "workspace"
        let fdiff = ""
    endif
    echo "Getting the diff output for " . fname . " ..."

    let cmd = s:diff_file_cmd . " " . fdiff
    let bufname = '_VPLUGIN__._A4DIFF_.A4PERFORCE'
    let retval = RunCommand(cmd, bufname)
    if retval == -1
        call WarnMsg(fname . " is up to date")
        return
    endif
endfunction

" Show the diff for the current project
function! s:A4_project_diff()

    let cmd = s:diff_proj_cmd

    echo "Getting the diff output for the current project ..."

    let cmd = s:diff_proj_cmd
    let bufname = '_VPLUGIN__._A4DIFF_.A4PERFORCE'
    let retval = RunCommand(cmd, bufname)
    if retval == -1
        call WarnMsg("Project is up to date")
        return
    endif
endfunction

"------------------- Command definitions ------------------------
" Checkout a file
command! -nargs=? -complete=file AEdit call s:A4_edit(<f-args>)

" Uncheckout a file
command! -nargs=? -complete=file ARevert call s:A4_revert(<f-args>)

" Get the description for the specified file
command!  -nargs=? -complete=file AAnnotate call s:A4_annotate(<f-args>)

" Get the description for the specified file
command!  -nargs=? -complete=file AFilelog call s:A4_filelog(<f-args>)

" Get the history of the specified file
command!  -nargs=? -complete=file AAncestry call s:A4_ancestry(<f-args>)

" Get the stat of the specified file
command!  -nargs=? -complete=file AFstat  call s:A4_fstat(<f-args>)

" List all the checked out files in the current project
command!  -nargs=0 AOpened  call s:A4_opened()

" Show the differences for the current file
command! -nargs=? -complete=file ADiff call s:A4_diff(<f-args>)

" Show the differences for the current project
command! -nargs=0 AProjectDiff call s:A4_project_diff()

" Show the current project
command!  -nargs=0 AWs echomsg system("basename $A4_CHROOT")

"------------------- Menu definitions ------------------------
" Perforce menu
"
" Add if menus support is available
if (has("gui_running") && &guioptions !~# "M")

    amenu <silent> <script> 100.310 &Perforce.&Edit<Tab>:AEdit        :AEdit<CR>
    amenu <silent> <script> 100.320 &Perforce.&Revert<Tab>:ARevert    :ARevert<CR>
    amenu 100.330 &Perforce.-SEP1-        :

    amenu <silent> <script> 100.340 &Perforce.&History<Tab>:AAncestry    :AAncestry<CR>
    amenu <silent> <script> 100.350 &Perforce.&Annotate<Tab>:AAnnotate  :AAnnotate<CR>
    amenu <silent> <script> 100.350 &Perforce.&Filelog<Tab>:AFilelog :AFilelog<CR>
    amenu <silent> <script> 100.360 &Perforce.F&stat<Tab>:AFstat :AFstat<CR>
    amenu 100.370 &Perforce.-SEP2-        :

    amenu <silent> <script> 100.390 &Perforce.&Diff\ File<Tab>:ADiff :ADiff<CR>
    amenu <silent> <script> 100.400 &Perforce.Diff\ &Project<Tab>:AProjectDiff   :AProjectDiff<CR>
    amenu 100.410 &Perforce.-SEP3-        :

    amenu <silent> <script> 100.420 &Perforce.Show\ Current\ &workspace<Tab>:AWs    :AWs<CR>
    amenu <silent> <script> 100.430 &Perforce.&List\ Opened\ Files<Tab>:AOpened :AOpened<CR>

endif

