from tempfile import NamedTemporaryFile
from ranger.ext.img_display import ImageDisplayer,W3MImageDisplayer,register_image_displayer,KittyImageDisplayer
from subprocess import run
import os
import PIL.Image
if 'NVIM' in os.environ:
    @register_image_displayer('image')
    class DisplayerNvim(ImageDisplayer):
        def draw(self,path,start_x,start_y,width,height):
            image=PIL.Image.open(path)
            iwidth,iheight=image.width,image.height
            ration=iheight/iwidth
            if height*2>width*ration:height=int(width*ration//2)
            if width*ration>height*2:width=int(height*2/ration)
            image=image.resize((width*8,height*8))
            with NamedTemporaryFile(prefix='ranger_thumb_',suffix='.png',delete=True) as tmpf:
                image.save(tmpf,format='png',compress_level=0)
                run(['nvr','-c','lua require("small.kitty.image").render("%s",%d,%d,%d,%d)'%(tmpf.name,start_x+1,start_y+1,width,height)])
        def clear(self,*_):
            run(['nvr','-c','lua require("small.kitty.image").clear()'])
        def quit(self,*_):
            run(['nvr','-c','lua require("small.kitty.image").clear()'])
elif 'kitty' in os.environ['TERM']:
    @register_image_displayer('image')
    class DisplayerKitty(KittyImageDisplayer):
        ...
else:
    @register_image_displayer('image')
    class DisplayerW3M(W3MImageDisplayer):
        ...
