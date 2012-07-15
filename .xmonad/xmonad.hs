import XMonad
import XMonad.Layout.SimpleFloat
import XMonad.Layout.Circle
import XMonad.Prompt
import XMonad.Prompt.Ssh
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.FadeInactive
import XMonad.Util.Run(spawnPipe)
import XMonad.Util.EZConfig(additionalKeys)
import System.IO
import XMonad.Actions.GridSelect

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

main = do
    xmproc <- spawnPipe "xmobar"
    xmonad $ defaultConfig
        { borderWidth   = 2
        , terminal      = "urxvtc"
        , normalBorderColor = "#cccccc"
        , focusedBorderColor = "#87af00"
        , manageHook = manageDocks <+> manageHook defaultConfig
        -- , layoutHook = avoidStruts $ layoutHook defaultLayouts
        , layoutHook = avoidStruts $ defaultLayouts
        , logHook = myLogHook >> (dynamicLogWithPP (xmobarPP
                        	{ ppOutput = hPutStrLn xmproc
                        	-- , ppTitle=xmobarColor "#0066cc" "" . shorten 50
                        	, ppTitle=xmobarColor "lightblue" ""
				, ppCurrent = xmobarColor "#d0d0d0" ""
				, ppHidden = xmobarColor "#444444" ""
                        	}))
        }
        `additionalKeys`
        [ ((mod1Mask, xK_g), goToSelected defaultGSConfig)
        , ((mod1Mask, xK_s), sshPrompt defaultXPConfig)
	-- , ((mod1Mask, xK_p), spawn "exe=`dmenu_run | dmenu -nb '#000000' -nf '#ffffff' -fn 'terminus-8' -b` && eval \"exec $exe\"")
	, ((mod1Mask, xK_p), spawn "lsx && dmenu_run -nb '#000000' -nf '#ffffff' -b")
        ]

-- Log Hook
myLogHook = fadeInactiveLogHook fadeAmount
	where fadeAmount = 0.7
