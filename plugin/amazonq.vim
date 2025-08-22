" Amazon Q Chat Plugin for Vim
if exists('g:loaded_amazonq')
    finish
endif
let g:loaded_amazonq = 1

" Configuration
let g:amazonq_python_path = get(g:, 'amazonq_python_path', 'python')
let g:amazonq_use_wsl = get(g:, 'amazonq_use_wsl', 0)

" Main command to open Amazon Q chat
command! AmazonQChat call amazonq#OpenChat()
command! AmazonQAsk call amazonq#AskQuestion()
command! -nargs=1 AmazonQGenerate call amazonq#GenerateFile(<f-args>)
command! AmazonQSaveResponse call amazonq#SaveLastResponse()

" Key mappings
nnoremap <leader>qq :AmazonQChat<CR>
nnoremap <leader>qa :AmazonQAsk<CR>
nnoremap <leader>qg :AmazonQGenerate<Space>
nnoremap <leader>qs :AmazonQSaveResponse<CR>