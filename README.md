This was a docker imaged used to just build rpms for Mageia, but since it has turned into a base image to build Unity-Linux. Though by every means still a work in progress, this image is what is used to build and test [mklivecd](https://github.com/unity-linux/mklivecd) with Travis-CI along with building various other packages by similiar means as well.


Directions
---
For now we just run SystemD in the container as a daemon and build from there, ie:
```
docker run --privileged=true -d -v "$(pwd):/builddir" -v "/dev:/dev" -v "/sys/fs/cgroup:/sys/fs/cgroup:ro" <container>
```

License
---
```
Copyright (c) 2017 Jeremiah Summers

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
