config=vars()["config"]
c=vars()["c"]
config.load_autoconfig(False)
c.statusbar.show='in-mode'
c.tabs.show='switching'
c.colors.webpage.darkmode.enabled=True # TODO
c.colors.webpage.darkmode.algorithm='lightness-cielab' # TODO
c.colors.webpage.preferred_color_scheme='dark' # TODO
c.scrolling.smooth=True
config.bind('<Alt-x>','set-cmd-text :')
config.bind('<Alt-s>','fake-key <Backspace>',mode='insert')
config.bind('<Alt-d>','fake-key <Ctrl-Backspace>',mode='insert')
