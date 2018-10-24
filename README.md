
==== Upstream ====

Updates CocoaPods for all projects in the parent directory that reference this framework using its local path.


If called with no arguments, the program uses current directory as starting point to locate the Podfile.

If used with a file change observer (ex. fswatch), it can accept a list of changed files. It will then
travel up the directory structure until it finds a Podfile, using that directory as the starting point.
