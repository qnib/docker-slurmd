# docker-slurmd

Slurm client within QNIBTerminal ecosystem.

## QNIBTerminal
QNIBTerminal comprises of a set of Docker images which are bundled together by consul to form a framework ontop of which a
datacenter service stack can be fired up.


## SLURM cluster

The minimal configuration of a SLURM cluster holds

- **qnib/consul**: To herd the cats
- **qnib/slurmctld**: Serving as SLURM Controler
- N x **qnib/slurmd**: SLURM compute nodes

## Startup

The repository holds a `docker-compose.yml` file which is everything one needs.

```
consul:
    image: qnib/consul
    ports:
     - "8500:8500"
    environment:
    - DC_NAME=qnib
    - ENABLE_SYSLOG=true
    - BOOTSTRAP_CONSUL=true
    - RUN_SERVER=true
    dns: 127.0.0.1
    hostname: consul
    privileged: true

slurmctld:
    image: qnib/slurmctld
    ports:
    - "6817:6817"
    links:
    - consul:consul
    environment:
    - DC_NAME=qnib
    volumes:
    - ${HOME}/shared/chome/:/chome/
    dns: 127.0.0.1
    hostname: slurmctld
    privileged: true

slurmd:
    image: qnib/slurmd
    links:
    - consul:consul
    - slurmctld:slurmctld
    environment:
    - DC_NAME=qnib
    volumes:
    - ${HOME}/shared/chome/:/chome/
    dns: 127.0.0.1
    privileged: true
```

### Stack start

```
$ docker-compose up -d
Recreating dockerslurmd_consul_1...
Recreating dockerslurmd_slurmctld_1...
Recreating dockerslurmd_slurmd_1...
```
Point a browser to `DOCKER_HOST:8500` to have a look at consuls web-ui. The service will settle and everything should be green after a couple of seconds (minutes).

### loggin run a job

```
$ docker exec -ti dockerslurmd_slurmctld_1 sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
qnib*        up   infinite      1   idle d833e248cb38
$ docker exec -ti dockerslurmd_slurmctld_1 srun hostname
d833e248cb38
```

## Scale up

One nice feature of compose is that it scales up parts of the stack for you.
```
$ docker-compose scale slurmd=5
Starting dockerslurmd_slurmd_2...
Starting dockerslurmd_slurmd_3...
Starting dockerslurmd_slurmd_4...
Starting dockerslurmd_slurmd_5...
$
```

After the slurm service has settled (takes some time, since my slurm-update is quite rough)

```
$ docker exec -ti dockerslurmd_slurmctld_1 sinfo
PARTITION AVAIL  TIMELIMIT  NODES  STATE NODELIST
qnib*        up   infinite      5   idle 4534f50de0fb,c3bcc3959927,e9d9d816eddb,ec6428b4c4c1,f30d5d1aafbe
$ docker exec -ti dockerslurmd_slurmctld_1 srun -N 4 hostname
c3bcc3959927
e9d9d816eddb
4534f50de0fb
ec6428b4c4c1
```
