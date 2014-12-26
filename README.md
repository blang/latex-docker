Latex docker container
=====

This container helps compiling latex sources without the need to install all latex packages on your system.

Usage
-----
First, add your local user to docker group:
```bash
sudo usermod -aG docker YOURUSERNAME
```

Pull image:
```bash
docker pull blang/latex
```
or build:
```bash
docker build -t blang/latex .

```

