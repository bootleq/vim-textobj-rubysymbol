vim-textobj-rubysymbol
======================

Text objects for manipulating ruby _symbol_ variables.  
Depends on [textobj-user plugin][textobj-user] by [Kana][].


Usage
=====

With default key mappings, use `da:` to *delete a symbol(:)*, e.g. `:example`.

`di:` to *delete inner symbol*, which is the `example` part without colon.

Also `ci:`, `vi:` for change, select commands.


Status
======
Under Development, experimental.


TODO
----
- Support more forms of symbol.
- Test case.


Requirements
============
[textobj-user plugin][textobj-user] by [Kana][].


[Kana]: http://whileimautomaton.net/
[textobj-user]: https://github.com/kana/vim-textobj-user
