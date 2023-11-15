from ranger.ext.img_display import ImageDisplayer,register_image_displayer
from subprocess import Popen
@register_image_displayer("kitty_nvim")
class Displayer(ImageDisplayer):
    def draw(self,path,start_x,start_y,width,height):
        if height*2>width:height=width//2
        if width>height*2:width=height*2
        Popen(['nvr','-c','lua require("small.kitty.image").render("%s",%d,%d,%d,%d)'%(path,start_x,start_y,width,height)])
    def clear(self,*_):
        Popen(['nvr','-c','lua require("small.kitty.image").clear()'])
