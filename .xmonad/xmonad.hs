import XMonad
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Circle
import XMonad.Layout.NoBorders
import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Hooks.ManageHelpers (isFullscreen, isDialog,  doFullFloat, doCenterFloat)
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Actions.GridSelect
import XMonad.Hooks.EwmhDesktops
import Graphics.X11.ExtraTypes.XF86

defaultLayouts = tiled ||| Mirror tiled ||| simpleFloat ||| Full ||| Circle
  where
     -- default tiling algorithm partitions the screen into two panes
        tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
        nmaster = 1

     -- Default proportion of screen occupied by master pane
        ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
        delta   = 3/100

-- mute = spawn (killosd ++ "amixer sset Master toggle | grep -w 'on\\|off' -o | head -n 1 | perl -e \"print 'Master: '; print <>;\" " ++ osdPipe 1)
-- volume s = spawn (killosd ++ "amixer set Master " ++ s ++ " | grep '[0-9]*%' -o | head -n 1 | sed -e 's/%//g' " ++ osdPipe 1)
volume s = spawn ("volnoti-show `amixer set Master unmute > /dev/null; amixer set Master " ++ s ++ " | grep '[0-9]*%' -o | head -n 1` " )
-- brightness s = spawn (killosd ++ osdbar 0.5 ++ "`xbacklight " ++ s ++ " ; xbacklight -get` " )
-- brightness s = spawn ("volnoti-show -b `xbacklight " ++ s ++ " ; xbacklight -get` " )
--volumeraise = spawn ("dvol raise")
--volumelower = spawn ("dvol lower")
mute = spawn ("`amixer set Master mute`; volnoti-show -m")

-- brightness_file = "/sys/class/backlight/intel_backlight/brightness"
-- current_brightness = "$(cat /sys/class/backlight/intel_backlight/brightness)"
--brightinc = spawn ("sudo bash -c \"echo `expr " ++ current_brightness ++ " + 1` > " ++ brightness_file ++ " \"")
-- brightinc = spawn ("sudo bash -c \"echo `expr " ++ current_brightness ++ " + 300` > " ++ brightness_file ++ " \"; volnoti-show -1 /usr/share/pixmaps/volnoti/brightness_off.svg -2 /usr/share/pixmaps/volnoti/brightness_low.svg -3 /usr/share/pixmaps/volnoti/brightness_medium.svg -4 /usr/share/pixmaps/volnoti/brightness_high.svg `expr $(echo \"scale=1;" ++ current_brightness ++ "/4648*100\" | bc)`")
--brightdec = spawn ("sudo bash -c \"echo `expr " ++ current_brightness ++ " - 1` > " ++ brightness_file ++ " \"; volnoti-show -1 /usr/share/pixmaps/volnoti/brightness_off.svg -2 /usr/share/pixmaps/volnoti/brightness_low.xvg -3 /usr/share/pixmaps/volnoti/brightness_medium.svg -4 /usr/share/pixmaps/volnoti/brightness_high.svg `expr $(echo \"scale=1;" ++ current_brightness ++ "/15*100\" | bc)`")
--brightdec = spawn ("sudo bash -c \"echo `expr " ++ current_brightness ++ " - 300` > " ++ brightness_file ++ " \"; volnoti-show `expr $(echo \"scale=1;" ++ current_brightness ++ "/4648*100\" | bc)`")
brightdec = spawn ("volnoti-show -s /usr/share/pixmaps/volnoti/display-brightness-symbolic.svg `xbacklight -dec 7; xbacklight`")
brightinc = spawn ("volnoti-show -s /usr/share/pixmaps/volnoti/display-brightness-symbolic.svg  `xbacklight -inc 7; xbacklight`")

      


main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ ewmh defaultConfig
        { modMask = mod4Mask
	, borderWidth   = 2
        , terminal      = "urxvtc"
	, handleEventHook = fullscreenEventHook
        , normalBorderColor = "#cccccc"
        , focusedBorderColor = "#87af00"
        -- , manageHook = manageDocks <+> manageHook defaultConfig
        , manageHook = ( isFullscreen --> doFullFloat ) <+> manageHook defaultConfig <+> manageDocks
        -- , layoutHook = avoidStruts $ layoutHook defaultLayouts
        , layoutHook = smartBorders $ avoidStruts $ defaultLayouts
        --, layoutHook = avoidStruts $ defaultLayouts
        , logHook = myLogHook >> (dynamicLogWithPP (xmobarPP
                        	{ ppOutput = hPutStrLn xmproc
                        	-- , ppTitle=xmobarColor "#0066cc" "" . shorten 50
                        	, ppTitle=xmobarColor "lightblue" ""
				, ppCurrent = xmobarColor "#d0d0d0" ""
				, ppHidden = xmobarColor "#444444" ""
                        	}))
        }
        `additionalKeys`
        [ ((mod4Mask, xK_g), goToSelected defaultGSConfig)
        , ((mod4Mask, xK_s), sshPrompt defaultXPConfig)
	-- , ((mod4Mask, xK_p), spawn "exe=`dmenu_run | dmenu -nb '#000000' -nf '#ffffff' -fn 'terminus-8' -b` && eval \"exec $exe\"")
	, ((mod4Mask, xK_p), spawn "dmenu_run -nb '#000000' -nf '#ffffff' -b")
        , ((0, xF86XK_AudioMute),         mute)
        , ((0, xF86XK_AudioRaiseVolume), volume "5%+")
        , ((0, xF86XK_AudioLowerVolume), volume "5%-")
	--, ((0, xF86XK_MonBrightnessUp), brightness "+ 10")
	    , ((0, xF86XK_MonBrightnessUp), brightinc)
	    , ((0, xF86XK_MonBrightnessDown), brightdec)
	    , ((0, xF86XK_Eject), spawn "volnoti-show -n -m -0 /usr/share/pixmaps/volnoti/media-eject-symbolic.svg")
        , ((0, xF86XK_Display), spawn "xset dpms force off")
      ]

-- Log Hook
myLogHook = fadeInactiveLogHook fadeAmount
	--where fadeAmount = 0.7
	where fadeAmount = 1.0
