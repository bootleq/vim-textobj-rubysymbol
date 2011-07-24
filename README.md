vim-textobj-rubysymbol
======================

Text object for manipulate ruby _symbol_ variables.
Depends on [textobj-user plugin][] by [Kana][].

Usage
=====

With default key mappings, use `das` to *delete a symbol*, eg. `:example`.

Use `dis` to *delete inner symbol*, which is, the `example` part without colon.

Status
======
Developing, experimental.

TODO
----
- Support symbol with quotes, eg. `:"foo bar"`.
- Add document.


Requirements
============
[textobj-user plugin][] by [Kana][].


[Kana]: http://whileimautomaton.net/
[textobj-user-plugin]: https://github.com/kana/vim-textobj-user
