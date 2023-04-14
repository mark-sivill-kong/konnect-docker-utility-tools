# konnect-docker-utility-tools
Kong Konnect and miscellaneous utility tooling in one Docker container. Includes example of converting OpenAPI specifications to Kong YAML configuration and then uploading into Kong Konnect.

## Tooling

* [deck](https://docs.konghq.com/deck/latest/)
* [inso](https://docs.insomnia.rest/inso-cli/install)
* [yq](https://mikefarah.gitbook.io/yq/)
* [jq](https://stedolan.github.io/jq/)
* [openapi-format](https://github.com/thim81/openapi-format)
* [kced](https://github.com/Kong/go-apiops)
* [curl](https://curl.se/)
* [wget](https://www.gnu.org/software/wget/)

## Get started

Copy this git repository to a local machine, for example

 ```git clone https://github.com/mark-sivill-kong/konnect-docker-utility-tools```

Build the docker container

```
cd konnect-docker-utility-tools
docker compose build
```

Start the container

```docker compose up```

Access the command line in the running container using [Docker Desktop](https://www.docker.com/products/docker-desktop/) or via the commmand line using

```docker ps```

to find the \<container-id\>, then the following command to access the docker container

```docker exec -it <container-id> /bin/sh```

Once inside the container the command line tools can be accessed, for example

```deck version```

## Included tooling

The tooling and associated versions that are installed can be found by running

```versions.sh```

## Additional scripts

### deck commands

Example deck commands can be found by running

```commands.sh```

### example custom script

Example pipeline that converts OpenAPI to Kong configuration and then uploads into Kong Konnect

```~/scripts/pipeline/run_pipeline.sh <OpenAPI-specification>```

Currently there are 2 OpenAPI specifications in the ```openapi-specs``` directory

* transport-for-london-1.5.yaml
* world-time-openapi.yaml

Running the pipeline using transport-for-london-1.5.yaml

```~/scripts/pipeline/run_pipeline.sh transport-for-london-1.5.yaml```

Additional OpenAPI specifications can optionally be added to the ```openapi-specs``` directory

To run the pipeline script ensure the following environment variables have been passed into the docker container

* KONNECT_ADDR - [Konnect Region specific API](https://docs.konghq.com/konnect/api/) for example [https://eu.api.konghq.com](https://eu.api.konghq.com) or [https://us.api.konghq.com](https://us.api.konghq.com)
* KONNECT_PAT - Konnect personal access token created within Konnect, found under user name
* KONNECT_RUNTIME_GROUP - runtime instance name where configuration is to be deployed

## Third party assets

The following OpenAPI specifciations are included in this repository which may have their own licensing terms

* transport-for-london-1.5.yaml dervived from [Transport for London Unified API](https://api.tfl.gov.uk/)
* world-time-openapi.yaml [WorldTimeAPI](http://worldtimeapi.org/)