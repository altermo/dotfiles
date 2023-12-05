from tempfile import NamedTemporaryFile
from ranger.ext.img_display import ImageDisplayer,register_image_displayer,KittyImageDisplayer
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
            image=image.resize((width*16,height*32))
            with NamedTemporaryFile(prefix='ranger_thumb_',suffix='.png',delete=True) as tmpf:
                image.save(tmpf,format='png',compress_level=0)
                run(['nvr','-c','lua require("small.kitty.image").render("%s",%d,%d,%d,%d,0)'%(tmpf.name,start_x+1,start_y+1,width,height)])
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
    class DisplayerChafa(ImageDisplayer):
        def draw(self,path,start_x,start_y,width,height):
            out=run(['chafa','-s','%sx%s'%(width,height),path],capture_output=True).stdout.decode()
            for n,i in enumerate(out.splitlines()):
                print('\x1b[%d;%dH%s'%(start_y+n,start_x,i),end='',flush=True)
        def clear(self,start_x,start_y,width,height):
            for n in range(height):
                print('\x1b[%d;%dH%s'%(start_y+n,start_x,' '*width),end='',flush=True)
