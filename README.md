# Runner

### Build

```sh
docker build --build-arg RUNNER_VERSION=<runner version> --tag <imagename>:latest .
```

### Run

```sh
docker run -e GH_TOKEN='personal access token' -e GH_OWNER='owner' -e GH_REPOSITORY='repo' -d <imagename>:latest 
```
