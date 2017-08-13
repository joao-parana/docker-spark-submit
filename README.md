# docker-spark-submit

## Docker image to run Spark applications

Performs the following tasks:
1. Get the source code from the SCM repository
1. Build the application
1. Submit the application to the Spark cluster

At present, only Git is supported for SCM and only Sbt is supported for build. Both `git` and `sbt` commands are expected in the PATH.
When building, sbt first tries to invoke `assembly` task (to build a fat jar) and falls back to `package` task.

Run example:
```
docker run \
  -ti \
  --rm \
  -p 5000-5010:5000-5010 \
  -e SCM_URL="https://github.com/mylogin/project.git" \
  -e SPARK_MASTER="spark://my.master.com:7077" \
  -e SPARK_DRIVER_HOST="192.168.1.2" \
  -e MAIN_CLASS="Main" \
  tashoyan/docker-spark-submit:spark-2.2.0
```

## Important command line arguments

`-p 5000-5010:5000-5010`

You have to publish this range of network ports. Spark driver program and Spark executors use these ports for communication.

`-e SPARK_DRIVER_HOST="host.machine.address"`

You have to specify here the network address of the host machine where the container will be running. Spark cluster nodes
should be able to resolve this address. This is necessary for communication between executors and the driver program.

## Command line arguments

Command line arguments are passed via environment variables for `docker` command: `-e VAR="value"`. Here is the full list:

| Name | Mandatory? | Meaning | Default value |
| ---- |:----------:| ------- | ------------- |
| SCM_URL | Yes | URL to get source code from. | N/A |
| SCM_BRANCH | No | SCM branch to checkout. | master |
| PROJECT_SUBDIR | No | A relative directory to the root of the SCM working copy. If specified, then build will be executed in this directory, rather than in the root directory. | N/A |
| SKIP_TESTS | No | Skip tests during the build. | Empty, don't skip. |
| SPARK_MASTER | No | Spark master URL | local[*] |
| SPARK_DRIVER_HOST | Yes | Value of the `spark.driver.host` configuration parameter. Must be set to the network address of the machine hosting the container. Must be accessible from Spark nodes. | N/A |
| MAIN_CLASS | Yes | Main class of the application to run. | N/A |
| http_proxy, https_proxy | No | Specify when running behind a proxy | Empty, no proxy |

## Working with data

If your Spark program requires some data for processing, you can add the data to the container by specifying a volume:

```
docker run \
  -ti \
  --rm \
  -v /data:/data \
  -p 5000-5010:5000-5010 \
  -e SCM_URL="https://github.com/mylogin/project.git" \
  -e SPARK_MASTER="spark://my.master.com:7077" \
  -e SPARK_DRIVER_HOST="192.168.1.2" \
  -e MAIN_CLASS="Main" \
  tashoyan/docker-spark-submit:spark-2.2.0
```

## Available image tags

Image tags correspond to Spark versions. Choose the tag based on the version of your Spark cluster.
The following tags are available:
* spark-2.2.0
* spark-2.1.1

## Building the image

Build the image:
```
docker build \
  -t tashoyan/docker-spark-submit:spark-2.2.0 \
  -f Dockerfile.spark-2.2.0 \
  .
```
When building on a machine behind proxy, specify `http_proxy` environment variable:
```
docker build \
  --build-arg http_proxy=http://my.proxy.com:8080 \
  -t tashoyan/docker-spark-submit:spark-2.2.0 \
  -f Dockerfile.spark-2.2.0 \
  .
```
