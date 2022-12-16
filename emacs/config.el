(custom-set-variables
'(custom-enabled-themes '(wombat)))

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(package-initialize)
;(package-refresh-contents)

(unless (package-installed-p 'use-package)
(package-install 'use-package))
(setq use-package-always-ensure t)

;(use-package evil
;:init
;(evil-mode)
;)

(use-package helm
)

(use-package whichkey
)

(use-package vterm
)

(delete-selection-mode t)
(global-display-line-numbers-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
