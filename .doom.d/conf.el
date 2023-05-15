(beacon-mode 1)
(global-auto-revert-mode 1)
(setq global-auto-revert-non-file-buffers t)

(add-hook 'vterm-mode-hook (lambda ()
    (define-key vterm-mode-map (kbd "<escape>") #'(lambda (interactive) (vterm-send-key "<escape>")))
    ))
