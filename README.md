# Stellar Core Docker image

[![Docker Pulls](https://img.shields.io/docker/pulls/satoshipay/stellar-core.svg)](https://hub.docker.com/r/satoshipay/stellar-core/)

## Docker Hub

The Docker images are published at [satoshipay/stellar-core](https://hub.docker.com/r/satoshipay/stellar-core/)
and come in multiple flavors that are available as tags:

 * Vanilla: just Stellar Core, example tags are `10.0.0` or `latest`.
 * AWS: comes with AWS CLI installed, example tags are `10.0.0-aws` or `latest-aws`.
 * Google Cloud: comes with Google Cloud SDK installed, example tags are `10.0.0-gcloud` or `latest-gcloud`.
   A Service Account is automatically configured if a key is provided via `GCLOUD_SERVICE_ACCOUNT_KEY`.
 * Azure: comes with Azure CLI installed, example tags are `latest-azure`.
   Required environment variables:
     - AZURE_STORAGE_ACCOUNT=<storage_account_name>
     - AZURE_STORAGE_KEY=<storage_account_key>

## Configuration

The container can be fully configured via environment variables, see below.

There is also an [example Docker Compose config](docker-compose.example.yml) – just run
`docker-compose -f docker-compose.example.yml up` to get a functional node.
**Make sure to use a new `NODE_SEED` if you intend to run this in production!**

### Create node seed

If you don't have a node seed yet you can create one by running
```
docker run --rm -it --entrypoint '' satoshipay/stellar-core stellar-core gen-seed
```
Use the *Secret seed* **only** for the `NODE_SEED` env variable and tell other nodes
your *Public* key.

### Environment variables

All Stellar Core config options can be set via environment variables. Here we list the
ones you probably want to set:

* `NODE_SEED`: your secret seed, see above.

* `NETWORK_PASSPHRASE`: default is `Public Global Stellar Network ; September 2015` which
  is the public production network; use `Test SDF Network ; September 2015` for the testnet.

* `DATABASE`: default is `sqlite3://stellar.db` which you should definitely change for production,
   e.g., `postgresql://dbname=stellar user=postgres host=postgres` or
   `postgresql://dbname=stellar user=postgres password=DATABASE_PASSWORD host=postgres`
   (see `DATABASE_PASSWORD`).

* `DATABASE_PASSWORD`: if provided, the string `DATABASE_PASSWORD` in the `DATABASE`
   variable is replace with its value. This is useful for providing passwords separately,
   e.g., via secrets in Kubernetes.

* `KNOWN_PEERS`: comma-separated list of peers (`ip:port`) to connect to when
   below *TARGET_PEER_CONNECTIONS*, e.g.,
   `core-live-a.stellar.org:11625,core-live-b.stellar.org:11625,core-live-c.stellar.org:11625`.

* `HISTORY`: JSON of the following form:
   ```
   {
     "h1": {
       "get": "curl -sf http://history.stellar.org/prd/core-live/core_live_001/{0} -o {1}"
     }
   }
   ```

* `INITIALIZE_DB` (default `true`): if set to `true` initializes the database if it hasn't
  been initialized before. Note: detecting whether the database has already been initialized
  is done via checking a file in the `/data` volume so the database will be re-initialized
  when the volume is recreated.

* `INITIALIZE_HISTORY_ARCHIVES`: if set to `true` the history archives with a `put` command
  will be initialized if they haven't been initialized yet. Note: detecting whether
  an archive has already been initialized is done via checking a file in the `/data` volume
  so the archive will be re-initialized when the volume is recreated.

* `NODE_NAMES`: comma-separated list of nodes with names (e.g., for using them in `QUORUM_SET`), for example:
   ```
   GCGB2S2KGYARPVIA37HYZXVRM2YZUEXA6S33ZU5BUDC6THSB62LZSTYH  sdf_watcher1,GCM6QMP3DLRPTAZW2UZPCPX2LF3SXWXKPMP3GKFZBDSF3QZGV2G5QSTK  sdf_watcher2,GABMKJM6I25XI4K7U6XWMULOUQIQ27BCTMLS6BYYSOWKTBUXVRJSXHYQ  sdf_watcher3

   ```

* `QUORUM_SET`: JSON of the following form:
   ```
   [
     {
       "validators": [
         "GDQWITFJLZ5HT6JCOXYEVV5VFD6FTLAKJAUDKHAV3HKYGVJWA2DPYSQV you_can_add",
         "GANLKVE4WOTE75MJS6FQ73CL65TSPYYMFZKC4VDEZ45LGQRCATGAIGIA human_readable"
        ]
     },
     {
       "path": "1",
       "threshold_percent": 67,
       "validators": [
         "$self",
         "GDXJAZZJ3H5MJGR6PDQX3JHRREAVYNCVM7FJYGLZJKEHQV2ZXEUO5SX2 some_name"
       ]
     }
   ]
   ```
