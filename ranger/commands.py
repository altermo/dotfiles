from ranger.ext.img_display import ImageDisplayer,W3MImageDisplayer,register_image_displayer,KittyImageDisplayer
from subprocess import Popen
import os
if 'NVIM' in os.environ:
    @register_image_displayer('image')
    class DisplayerNvim(ImageDisplayer):
        def draw(self,path,start_x,start_y,width,height):
            if height*2>width:height=width//2
            if width>height*2:width=height*2
            Popen(['nvr','-c','lua require("small.kitty.image").render("%s",%d,%d,%d,%d)'%(path,start_x,start_y,width,height)])
        def clear(self,*_):
            Popen(['nvr','-c','lua require("small.kitty.image").clear()'])
        def quit(self,*_):
            Popen(['nvr','-c','lua require("small.kitty.image").clear()'])
elif 'kitty' in os.environ['TERM']:
    @register_image_displayer('image')
    class DisplayerKitty(KittyImageDisplayer):
        ...
else:
    @register_image_displayer('image')
    class DisplayerW3M(W3MImageDisplayer):
        ...
