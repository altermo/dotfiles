;theme
(load-theme 'wombat t)

;disable some features
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;(require 'package)
;(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
;(package-initialize)
;(package-refresh-contents)

;(unless (package-installed-p 'use-package)
;(package-install 'use-package))
;(setq use-package-always-ensure t)

;(use-package evil
;:init
;(evil-mode)
;)

;(use-package helm
;)
;
;(use-package whichkey
;)
;
;(use-package vterm
;)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(avy evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
