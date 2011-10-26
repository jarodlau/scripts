# gnome环境当开启flash全屏播放的时候禁用屏幕保护 

#!/bin/bash 

 
# cleanup any bad state we left behind if the user exited while flash was running
gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type bool true
 
turn_it_off=0
sleepcomputer0=`gconftool-2 -g /apps/gnome-power-manager/timeout/sleep_computer_ac`
sleepdisplay0=`gconftool-2 -g /apps/gnome-power-manager/timeout/sleep_display_ac`
 
# run loop forever
while true; do
  # interval between checks
  sleep 30
  SS_off=0
  # make id variable of window in focus
  current_window_id=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d" " -f5`
  # make pid array of every command with libflashplayer in full(-f) command
  for pid in `pgrep -f libflashplayer` ; do
    # check if window in focus is our libflashplayer
    if [ $pid == `xprop -id $current_window_id | grep PID | cut -d" " -f3` ]
      then SS_off=1
    fi
  done
 
# check to see if xine is being used
#  if pgrep xine > /dev/null; then
#    SS_off=1
#  fi
#
# check to see if current application is fullscreen
#  current_window_id=`xprop -root | grep "_NET_ACTIVE_WINDOW(WINDOW)" | cut -d" " -f5`
#  if xprop -id $current_window_id | grep "_NET_WM_STATE_FULLSCREEN" > /dev/null; then
#    SS_off=1
#  fi
 
  # read current state of screensaver
  ss_on=`gconftool-2 -g /apps/gnome-screensaver/idle_activation_enabled`
 
  # change state of screensaver as necessary
  if [ "$SS_off" = "1" ] && [ "$ss_on" = "true" ]; then
    gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type bool false
    gconftool-2 -s /apps/gnome-power-manager/timeout/sleep_computer_ac --type int 0
    gconftool-2 -s /apps/gnome-power-manager/timeout/sleep_display_ac --type int 0
    turn_it_off=1
  elif [ "$SS_off" = "0" ] && [ "$ss_on" = "false" ] && [ "$turn_it_off" = "1" ]; then
    gconftool-2 -s /apps/gnome-screensaver/idle_activation_enabled --type bool true
    gconftool-2 -s /apps/gnome-power-manager/timeout/sleep_computer_ac --type int $sleepcomputer0
    gconftool-2 -s /apps/gnome-power-manager/timeout/sleep_display_ac --type int $sleepdisplay0
    turn_it_off=0
  fi
done

 

#Reference: http://ubuntuforums.org/showthread.php?p=10832670#post10832670
