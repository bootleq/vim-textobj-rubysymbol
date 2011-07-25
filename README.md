vim-textobj-rubysymbol
======================

Text object for manipulating ruby _symbol_ variables.  
Depends on [textobj-user plugin][textobj-user] by [Kana][].

Usage
=====

With default key mappings, use `da:` to *delete a symbol(:)*, eg. `:example`.

`di:` to *delete inner symbol*, which is the `example` part without colon.

Status
======
Developing, experimental.

TODO
----
- Support symbol with quotes, eg. `:"foo bar"`.
- Add document.


Requirements
============
[textobj-user plugin][textobj-user] by [Kana][].


[Kana]: http://whileimautomaton.net/
[textobj-user]: https://github.com/kana/vim-textobj-user
