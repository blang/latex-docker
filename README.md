Latex docker container [![Docker hub](https://img.shields.io/docker/pulls/blang/latex.svg)](https://hub.docker.com/r/blang/latex/)
======================

This container helps compiling latex sources without the need to install all latex packages on your system.

Why should I use this container?
-----

- Easy setup, compile immediately after image download
- Preserves UID and GID of local user
- Use container like local command: `latexdockercmd.sh pdflatex main.tex`
- Multiple distributions like ubuntu's `texlive-full` to cover all needs

Versions
--------
All versions are based on Ubuntu: ([See all tags](https://hub.docker.com/r/blang/latex/))

- [blang/latex:ubuntu (:latest) - Dockerfile.ubuntu](Dockerfile.ubuntu) Ubuntu TexLive distribution: Old but stable, most needed package: texlive-full (3.9GB)
- [blang/latex:ctanbasic - Dockerfile.basic](Dockerfile.basic) CTAN TexLive Scheme-basic: Up-to-date, only basic packages, base for custom builds (500MB)
- [blang/latex:ctanfull - Dockerfile.full](Dockerfile.full) CTAN TexLive Scheme-full: Up-to-date, all packages (5.6GB)

If you need...
- ...the most-stuff-works-out-of-the-box package, try `blang/latex:ubuntu`. 
- ...the most recent version of everything, try `blang/latex:ctanfull`.
- ...a stable base for your custom texlive build, try `blang/latex:ctanbasic`

For stability, choose a more specific version tag ([See all tags](https://hub.docker.com/r/blang/latex/))

Quick Setup
-----------

Compile latex sources using docker:
```bash
# Change to your project
cd my_latex_project

# Download the command wrapper and make it executable
wget https://raw.githubusercontent.com/blang/latex-docker/master/latexdockercmd.sh
chmod +x dockercmd.sh

# Optional: Change the version (see above, default blang/latex:ubuntu)
edit ./dockercmd.sh

# Compile using pdflatex (docker will pull the image automatically)
./dockercmd.sh pdflatex main.tex

# Or use latexmk (best option)
./dockercmd.sh latexmk -cd -f -interaction=batchmode -pdf main.tex
# Cleanup: ./dockercmd.sh latexmk -c or -C

# Or make multiple passes (does not start container twice)
../dockercmd.sh /bin/sh -c "pdflatex main.tex && pdflatex main.tex"
```

Requirements
------------

First, add your local user to docker group (should already be the case):
```bash
sudo usermod -aG docker YOURUSERNAME
```

The `latexdockercmd.sh` will use your current user and group id to compile.


Daemon setup
------------

If you're working on source in latex, you might want to compile it multiple times and don't want to start a container each time.

```
cd my_latex_source

# Start a daemon container on this path, it accepts commands from latexdockerdaemoncmd.sh
latexdockerdaemon.sh

# Execute the command in the daemon container, only the daemon container is running
latexdockerdaemoncmd.sh pdflatex main.tex

# Stop the daemon
docker stop latex_daemon
```

Customize
---------

If software is missing, extend this base image with your own software:

Create a Dockerfile or download [Dockerfile.blueprint](Dockerfile.blueprint) for examples:
```
FROM blang/latex:ubuntu

# Minted + Pygments
RUN tlmgr install minted
```

Build your custom image:
```bash
docker build -t mycustomlateximg .
```

Edit `latexdockercmd.sh` to use your image `mycustomlateximg`.

Latex Make
-----------------

Clean build using `latexmk`:
```
mkdir compile
latexmk -cd -f -jobname=output -outdir=./compile -auxdir=./compile -interaction=batchmode -pdf ./main.tex
```

Use `latexmkrc` in your project root:
```
# Example: Make glossaries
add_cus_dep( 'glo', 'gls', 0, 'makeglo2gls' );
sub makeglo2gls {
    system("makeindex -s \"$_[0].ist\" -t \"$_[0].glg\" -o \"$_[0].gls\" \"$_[0].glo\"" );
}
```


CTAN Packages
-------------
A list of available ctan packages can be found here: [http://mirror.ctan.org/systems/texlive/tlnet/archive](http://mirror.ctan.org/systems/texlive/tlnet/archive)

Install texlive packages:
```
RUN tlmgr install minted
```

Contribution
------------

If the image is missing a package only specific for you, please don't open an issue or pull request but build your own image as described above.
If a critical package is missing or you have a recipe for missing packages in a common scenario, please create an issue / PR on [Dockerfile.blueprint](Dockerfile.blueprint).

License
-------

See [LICENSE](LICENSE) file.
