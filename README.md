docker-rpmbuilder is used to build RPMs in docker using
[mock](https://fedoraproject.org/wiki/Mock) with a CI tool such as Travis. It
will easily integrate with your build system if you keep your rpmbuild directory
in a VCS.


Directions
---
```
---
sudo: required
language: bash
services:
  - docker
before_install:
  - docker pull jmiahman/rpmbuilder
env:
  - MOCK_CONFIG="mageia-6-i386"
  - MOCK_CONFIG="mageia-6-x86_64"
script:
  - docker run -e MOCK_CONFIG="${MOCK_CONFIG}" -v "$(pwd):/rpmbuild" --privileged=true mmckinst/rpmbuilder
```

License
---
```
Copyright (c) 2016 Mark McKinstry

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
