{ config, pkgs, ... }:
{
	home.packages = with pkgs; [
		emacs
		emacsPackages.doom
		ripgrep
		fd
	];

	home.file.".doom.d/init.el".text = ''
;; -*- lexical-binding: t; -*-
(doom! :input
       :completion
       (vertico +icons)
       :ui
       doom
       doom-dashboard
       modeline
       :editor
       (evil +everywhere)
       :emacs
       dired
       :tools
       magit
       :lang
       emacs-lisp
       (json +lsp)
       (latex +latexmk +lsp)
       (markdown +grip)
       (org +roam2)
       :config
       (default +bindings +smartparens))
'';

	home.file.".doom.d/config.el".text = ''
;; -*- lexical-binding: t; -*-
(setq user-full-name "Atrin Hojjat"
      user-mail-address "atrin.hojjat@gmail.com")

(setq doom-theme 'doom-one
      doom-font (font-spec :family "Fira Code" :size 14))
'';

	home.file.".doom.d/packages.el".text = ''
;; -*- lexical-binding: t; -*-
(package! auctex)
;; Add packages here
'';
}
