import subprocess
import time
def list_windows():
    return [i.split(' ')[0] for i in subprocess.run(['wmctrl','-l'],check=True,capture_output=True).stdout.decode().splitlines()]
def main():
    windows=list_windows()
    subprocess.Popen(['setsid','alacritty','-o','window.opacity=0'])
    for _ in range(10):
        time.sleep(0.1)
        new_windows=[i for i in list_windows() if i not in windows]
        if len(new_windows)>0:break
    else:
        raise TimeoutError('No new window found')
    if len(new_windows)>2:
        raise Exception('More than 2 windows found')
    window,=new_windows
    subprocess.run(['qtile','cmd-obj','-o','window',str(int(window[2:],16)),'-f','enable_fullscreen'])
    subprocess.run(['qtile','cmd-obj','-o','window',str(int(window[2:],16)),'-f','static'])
    subprocess.run(['qtile','cmd-obj','-o','cmd','-f','reload_config'])
    for i in list_windows(): #HACK
        subprocess.run(['xdotool','windowstate','--add','FULLSCREEN',i])
        subprocess.run(['xdotool','windowstate','--remove','FULLSCREEN',i])
if __name__=='__main__':
    main()
