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
    " Call Python backend
    let l:python_script = expand('<sfile>:p:h:h') . '/python/amazonq_client.py'
    let l:cmd = g:amazonq_python_path . ' "' . l:python_script . '" "' . escape(a:message, '"') . '"'
    
    let l:response = system(l:cmd)
    let g:amazonq_last_response = l:response
    
    " Display response in current buffer
    if bufname('%') == '__AmazonQ_Chat__'
        call append(line('.'), ['Q: ' . a:message, 'A: ' . l:response, ''])
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