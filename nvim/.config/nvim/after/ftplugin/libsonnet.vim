if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
    au! BufRead,BufNewFile *.libsonnet setfiletype jsonnet
augroup END
