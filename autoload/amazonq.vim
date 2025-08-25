" Amazon Q autoload functions

function! amazonq#OpenChat()
    " Create a new buffer for Amazon Q chat
    let l:bufnr = bufnr('__AmazonQ_Chat__', 1)
    
    " Open in a new window
    execute 'botright vnew'
    execute 'buffer ' . l:bufnr
    
    " Set buffer options
    setlocal buftype=nofile
    setlocal bufhidden=hide
    setlocal noswapfile
    setlocal filetype=amazonq
    
    " Add welcome message
    call append(0, ['=== Amazon Q Chat ===', '', 'Type your question and press <Enter> to send', ''])
    
    " Set up key mappings for this buffer
    nnoremap <buffer> <CR> :call amazonq#SendMessage()<CR>
    inoremap <buffer> <CR> <Esc>:call amazonq#SendMessage()<CR>
endfunction

function! amazonq#AskQuestion()
    let l:question = input('Ask Amazon Q: ')
    if !empty(l:question)
        call amazonq#SendToAPI(l:question)
    endif
endfunction

function! amazonq#SendMessage()
    let l:line = getline('.')
    if !empty(l:line) && l:line !~ '^==='
        call amazonq#SendToAPI(l:line)
        call append(line('.'), '')
        normal! j
    endif
endfunction

" Store last response globally
let g:amazonq_last_response = ''

function! amazonq#SendToAPI(message)
    " Find the plugin directory more reliably
    let l:script_path = expand('<sfile>:p')
    let l:plugin_dir = fnamemodify(l:script_path, ':h:h')
    let l:python_script = l:plugin_dir . '/python/amazonq_client.py'
    
    " Debug info
    echo 'Script path: ' . l:script_path
    echo 'Plugin dir: ' . l:plugin_dir
    echo 'Python script: ' . l:python_script
    echo 'File exists: ' . filereadable(l:python_script)
    
    " Fallback: search in runtimepath
    if !filereadable(l:python_script)
        echo 'Searching in runtimepath...'
        for l:path in split(&runtimepath, ',')
            let l:candidate = l:path . '/python/amazonq_client.py'
            echo 'Checking: ' . l:candidate
            if filereadable(l:candidate)
                let l:python_script = l:candidate
                echo 'Found at: ' . l:python_script
                break
            endif
        endfor
    endif
    
    if !filereadable(l:python_script)
        echo 'Error: Python script not found at ' . l:python_script
        return
    endif
    
    " Show loading message
    if bufname('%') == '__AmazonQ_Chat__'
        call append(line('.'), ['Q: ' . a:message, 'A: Thinking...'])
        normal! G
        redraw
    endif
    
    " Build command based on OS and WSL setting
    if g:amazonq_use_wsl && has('win32')
        " Convert Windows path to WSL path
        let l:wsl_script = substitute(l:python_script, '\\', '/', 'g')
        let l:wsl_script = substitute(l:wsl_script, '^\([A-Za-z]\):', '/mnt/\L\1', '')
        let l:cmd = 'wsl ' . g:amazonq_python_path . ' "' . l:wsl_script . '" "' . escape(a:message, '"') . '"'
    else
        let l:cmd = g:amazonq_python_path . ' "' . l:python_script . '" "' . escape(a:message, '"') . '"'
    endif
    
    let l:response = system(l:cmd)
    let g:amazonq_last_response = l:response
    
    " Display response in current buffer
    if bufname('%') == '__AmazonQ_Chat__'
        " Replace the "Thinking..." line with actual response
        call setline(line('.'), 'A: ' . l:response)
        call append(line('.'), '')
        normal! G
    else
        echo 'Amazon Q: ' . l:response
    endif
endfunction

function! amazonq#GenerateFile(filename)
    let l:prompt = 'Generate code for file: ' . a:filename
    call amazonq#SendToAPI(l:prompt)
    
    " Auto-save response to file if it contains code
    if !empty(g:amazonq_last_response)
        call amazonq#SaveResponseToFile(a:filename, g:amazonq_last_response)
    endif
endfunction

function! amazonq#SaveLastResponse()
    if empty(g:amazonq_last_response)
        echo 'No response to save'
        return
    endif
    
    let l:filename = input('Save to file: ', '', 'file')
    if !empty(l:filename)
        call amazonq#SaveResponseToFile(l:filename, g:amazonq_last_response)
    endif
endfunction

function! amazonq#SaveResponseToFile(filename, content)
    try
        call writefile(split(a:content, '\n'), a:filename)
        echo 'Saved to: ' . a:filename
        
        " Open the file in a new buffer
        execute 'edit ' . a:filename
    catch
        echo 'Error saving file: ' . v:exception
    endtry
endfunction