# embox-docs - markdown documentations for Embox 

For Arch Linux:
```
    $ sudo pacman -S pandoc texlive-langcyrillic texlive-latexextra
```

For Debian like:
```
    $ sudo apt-get install pandoc texlive-lang-cyrillic texlive-latex-extra lmodern cm-super
```

You can use pandoc to compile to pdf format. For example:

```
    $ make ru
    $ make en
    $ make
```

It appears some pdf files in the project directory in the result.
