# User Guide

This repository contains testing and development golang utility functions.

### Callers and GetCaller

The `GetCaller()` function provides details of the Caller's Function Name and source file/line number. This
can be used to include the function name in log output. The `Callers()` function will return details of the
caller's caller and their caller as far up the stack as is requested and available. This can be used in
debugging output.




