
# Upstream

Updates CocoaPods for all projects in the parent directory that reference current framework using its local path. If called with no arguments, the program uses current directory as the starting point to locate a Podfile. If used with a file change observer (ex. fswatch), it can accept a list of changed files. It will then travel up the directory structure until it finds a Podfile, using that directory as the starting point.

# Installation
To install, copy `upstream` binary to /usr/local/bin

# Standalone
Run `upstream` binary from repository root.
 
# Run script phase
 ```bash
if which upstream >/dev/null; then
    cd .. && upstream
fi
 ```

# Continuous monitoring using fswatch
 
Run `fswatch . -r | xargs -n1 upstream` from repository root.
