# rc

## pre-commit 
After clone 
````bash
pre-commit install --install-hooks -t pre-commit -t post-commit -t pre-push
````

## docker auto build

### Private repos
```bash
ssh-keygen -t rsa -C "rc@docker.com" -f ~/.ssh/rc.docker
ssh-keygen -t ed25519 -C "rc@docker.com"
```
* enter public key in repository.
* enter SSH_PRIVATE in environment docker hub 

