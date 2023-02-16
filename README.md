# apex-tutorial
Tutorial examples for APEX (https://github.com/UO-OACISS/apex)

This repository contains a number of examples for demonstrating
 - APEX model support
 - APEX measurement support
 - APEX policy support

To build the tutorial examples, see the specific system examples,
or manually build with:

```
export APEX_ROOT=$HOME/src/apex/install
# Configure
cmake -B build
# Build
cmake --build build -j
# Test
ctest --test-dir build
```
