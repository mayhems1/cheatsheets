# Configure vim

## For python
```bash
echo filetype plugin indent on >> ~/.vimrc

cat <<EOF > ~/.vim/ftplugin/python.vim
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4
setlocal textwidth=80
setlocal smarttab
setlocal expandtab
```
