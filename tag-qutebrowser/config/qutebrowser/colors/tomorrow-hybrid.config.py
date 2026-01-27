# Scheme name: Tomorrow Hybrid
# Scheme author: Cantoraz Chou

## Read Xresources
import subprocess


def read_xresources(prefix):
    proc = subprocess.run(
        ["xrdb", "-query"], capture_output=True, check=True, text=True
    )
    lines = proc.stdout.splitlines()
    res = {
        k: v
        for (k, _, v) in (
            l.partition(":\t") for l in lines if l.startswith(prefix)  # noqa: E741
        )
    }
    return res


xresources = read_xresources("*")

bg = xresources["*background"]  # "#1d1f21"
bgL = xresources["*backgroundL"]  # "#282a2e"
bgXL = xresources["*backgroundXL"]  # "#373b41"
bgXXL = xresources["*backgroundXXL"]  # "#969896"
fgD = xresources["*foregroundD"]  # "#b4b7b4"
fg = xresources["*foreground"]  # "#c5c8c6"
fgL = xresources["*foregroundL"]  # "#e0e0e0"
fgXL = xresources["*foregroundXL"]  # "#ffffff"

# cursorColor = xresources["*cursorColor"]  # "#c5c8c6"

highlightColor = xresources["*highlightColor"]  # "#5294e2"
highlightTextColor = xresources["*highlightTextColor"]  # "#e0e0e0"

tintOnColor = xresources["*tintOnColor"]  # "#e0e0e0"
tintColor = xresources["*tintColor"]  # "#5e8d87"

black = xresources["*color0"]  # "#282a2e"
red = xresources["*color1"]  # "#a54242"
green = xresources["*color2"]  # "#8c9440"
yellow = xresources["*color3"]  # "#de935f"
blue = xresources["*color4"]  # "#5f819d"
magenta = xresources["*color5"]  # "#85678f"
cyan = xresources["*color6"]  # "#5e8d87"
white = xresources["*color7"]  # "#c5c8c6"

bright_black = xresources["*color8"]  # "#969896"
bright_red = xresources["*color9"]  # "#cc6666"
bright_green = xresources["*color10"]  # "#b5bd68""
bright_yellow = xresources["*color11"]  # "#f0c674"
bright_blue = xresources["*color12"]  # "#81a2be"
bright_magenta = xresources["*color13"]  # "#b294bb"
bright_cyan = xresources["*color14"]  # "#8abeb7"
bright_white = xresources["*color15"]  # "#ffffff"


# set qutebrowser colors

## Suppress lint errors
from qutebrowser.config.config import ConfigContainer  # noqa: E402

c: ConfigContainer = c  # noqa: F821 # pyright: ignore[reportUndefinedVariable]


# completion

# May be a single color to use for all columns
# or a list of three colors, one for each column.
c.colors.completion.fg = fg
c.colors.completion.odd.bg = bgL
c.colors.completion.even.bg = bg

c.colors.completion.category.fg = bright_yellow
c.colors.completion.category.bg = bg
c.colors.completion.category.border.top = bgXL
c.colors.completion.category.border.bottom = bgXL

c.colors.completion.item.selected.fg = fg
c.colors.completion.item.selected.bg = bgXL
c.colors.completion.item.selected.border.top = bgXL
c.colors.completion.item.selected.border.bottom = bgXL

c.colors.completion.match.fg = bright_red
c.colors.completion.item.selected.match.fg = bright_red

c.colors.completion.scrollbar.fg = fg
c.colors.completion.scrollbar.bg = bg

# contextmenu

# If set to None, the Qt default is used.
# c.colors.contextmenu.disabled.fg = backgroundXXL
# c.colors.contextmenu.disabled.bg = backgroundXL
# c.colors.contextmenu.menu.fg = foreground
# c.colors.contextmenu.menu.bg = backgroundXL
# c.colors.contextmenu.selected.fg = foreground
# c.colors.contextmenu.selected.bg = backgroundXL

# downloads

c.colors.downloads.bar.bg = bg
c.colors.downloads.start.fg = bg
c.colors.downloads.start.bg = bright_blue
c.colors.downloads.stop.fg = bg
c.colors.downloads.stop.bg = bright_green
c.colors.downloads.error.fg = red

# hints

c.colors.hints.fg = bgL
c.colors.hints.bg = "#cc" + bright_yellow[1:]
c.colors.hints.match.fg = bright_red

# keyhint

c.colors.keyhint.fg = fg
c.colors.keyhint.suffix.fg = bright_yellow
c.colors.keyhint.bg = bgL

# messages

c.colors.messages.error.fg = fgL
c.colors.messages.error.bg = red
c.colors.messages.error.border = red

c.colors.messages.warning.fg = bg
c.colors.messages.warning.bg = yellow
c.colors.messages.warning.border = yellow

c.colors.messages.info.fg = fgL
c.colors.messages.info.bg = blue
c.colors.messages.info.border = blue

# prompts

c.colors.prompts.fg = fg
c.colors.prompts.bg = bgL
c.colors.prompts.border = f"1px solid {bgXXL}"
# Foreground color for the selected item in filename prompts.
c.colors.prompts.selected.fg = tintOnColor
# Background color for the selected item in filename prompts.
c.colors.prompts.selected.bg = tintColor

# statusbar

c.colors.statusbar.normal.fg = fg
c.colors.statusbar.normal.bg = bgL

c.colors.statusbar.insert.fg = bg
c.colors.statusbar.insert.bg = bright_blue

c.colors.statusbar.passthrough.fg = bg
c.colors.statusbar.passthrough.bg = bright_magenta

c.colors.statusbar.private.fg = fgL
c.colors.statusbar.private.bg = "indigo"

c.colors.statusbar.command.fg = fg
c.colors.statusbar.command.bg = bgL

c.colors.statusbar.command.private.fg = fgL
c.colors.statusbar.command.private.bg = "indigo"

c.colors.statusbar.caret.fg = bg
c.colors.statusbar.caret.bg = yellow
c.colors.statusbar.caret.selection.fg = fgL
c.colors.statusbar.caret.selection.bg = "sienna"

c.colors.statusbar.progress.bg = bright_blue

c.colors.statusbar.url.fg = fg
c.colors.statusbar.url.error.fg = red
c.colors.statusbar.url.hover.fg = bright_yellow
c.colors.statusbar.url.warn.fg = yellow
c.colors.statusbar.url.success.http.fg = bright_white
c.colors.statusbar.url.success.https.fg = "greenyellow"

# tabs

c.colors.tabs.bar.bg = bgXL
c.colors.tabs.indicator.start = bright_yellow
c.colors.tabs.indicator.stop = bright_green
c.colors.tabs.indicator.error = red

c.colors.tabs.odd.fg = fg
c.colors.tabs.odd.bg = bgL
c.colors.tabs.even.fg = fg
c.colors.tabs.even.bg = bg

c.colors.tabs.selected.odd.fg = tintOnColor  # fg
c.colors.tabs.selected.odd.bg = tintColor  # bgXL
c.colors.tabs.selected.even.fg = tintOnColor  # fg
c.colors.tabs.selected.even.bg = tintColor  # bgXL

c.colors.tabs.pinned.odd.fg = fg
c.colors.tabs.pinned.odd.bg = bgL
c.colors.tabs.pinned.even.fg = fg
c.colors.tabs.pinned.even.bg = bg

c.colors.tabs.pinned.selected.odd.fg = tintOnColor
c.colors.tabs.pinned.selected.odd.bg = tintColor
c.colors.tabs.pinned.selected.even.fg = tintOnColor
c.colors.tabs.pinned.selected.even.bg = tintColor

# webpage

# set to None to use the theme's color.
c.colors.webpage.bg = bgXL
