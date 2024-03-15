#!/usr/bin/env bash

\rm -fr \
    .cache \
    .emacs.desktop .emacs.desktop.lock \
    .lsp* \
    .mc-lists.el \
    .persistent-scratch \
    abbrev_defs \
    async-bytecomp.log \
    auto-save-list \
    bm-repository \
    dired-history \
    eln-cache \
    elpa \
    my_settings.el \
    persp-confs \
    projectile-bookmarks.eld \
    recentf \
    recently.el\
    snippets \
    tramp \
    transient \
    undo \
    url

git checkout init.el

