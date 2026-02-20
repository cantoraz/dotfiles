#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail
if [[ "${TRACE-0}" == "1" ]]; then
    set -o xtrace
fi

if [[ "$#" -eq 3 ]]; then
    # INPUT_LINE_NUMBER is an integer representing which line should be
    # at the top of the screen.
    # Similarly CURSOR_LINE and CURSOR_COLUMN are the current cursor
    # position or 0 if there is no cursor, for example, when showing the
    # last command output.
    INPUT_LINE_NUMBER=${1:-1}
    CURSOR_LINE=${2:-1}
    CURSOR_COLUMN=${3:-1}
    POSITION_CURSOR="call setcursorcharpos($INPUT_LINE_NUMBER, 0)"
    # echon '$INPUT_LINE_NUMBER:$CURSOR_LINE,$CURSOR_COLUMN'
else
    TITLE='Kitty Scrollback History'
    printf '\e]2;%s\a' "$TITLE"

    # The special environment variable KITTY_PIPE_DATA is defined with
    # contents:
    # KITTY_PIPE_DATA={scrolled_by}:{cursor_x},{cursor_y}:{lines},{columns}
    # where scrolled_by is the number of lines kitty is currently
    # scrolled by, cursor_(x|y) is the position of the cursor on the
    # screen with (1,1) being the top left corner and {lines},{columns}
    # being the number of rows and columns of the screen.
    POSITION_CURSOR='let parts = split($KITTY_PIPE_DATA, "[:,]") | call setcursorcharpos(line("$") - parts[0] - parts[3] + 1, 0)'
fi

exec nvim \
    -i NONE \
    "+noremap <silent> q ZQ" \
    "+set nonumber norelativenumber clipboard+=unnamedplus laststatus=0 scrolloff=0 signcolumn=no" \
    "+autocmd VimEnter * lua require('lualine').hide({place={'winbar'}, unhide=false}); vim.o.laststatus=0" \
    "+autocmd TermEnter * stopinsert" \
    "+autocmd TermClose * $POSITION_CURSOR | normal! zt" \
    "+terminal sed <&63 -e 's/\x1b]8;;file:[^\]*[\]//g; s/$/\x1b[0m/g' && sleep 0.01 && printf '\e]2;'" \
    63<&0 </dev/null
