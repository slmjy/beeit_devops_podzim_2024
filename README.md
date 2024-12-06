## Customized linux CLI

##### Pull the docker image from dockerhub

```bash
sudo docker pull tweber94/custom-linux-cli
```
##### Examples of usage

```bash
sudo docker run -it --rm tweber94/custom-linux-cli:latest -addContent -p "file.txt" -c "Blabla"
sudo docker run -it --rm tweber94/custom-linux-cli:latest -getIP
```
