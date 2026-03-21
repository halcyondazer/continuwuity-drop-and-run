# continuwuity drop-and-run
*a continuwuity compose config with generator and updater, includes MatrixRTC*  
![a Continuwuity drop-and-run rod, has the style of a Cobalt-60 Rod](logo.png)

> if you have any problems with this script, DM me on matrix (if possible) via https://matrix.to/#/@lukas:semda.eu or open an issue.
i will respond as fast as possible.  
i use this on my own server in production  
[News and Changes](NEWS.md)  
## Setup:

1. have a domain (yourdomain.tld)

2. open your ports if needed:
```
80/tcp             # http and wellknown
443/tcp            # https
443/udp            # websocket for livekit
8081/tcp           # jwt service
7880/tcp           # livekit / MatrixRCT
7881/tcp           # livekit / MatrixRCT
50100-50200/udp    # livekit / MatrixRCT
```
*a tutorial for popular firewalls might follow*

3. git clone this repo:
```bash
git clone https://github.com/halcyondazer/continuwuity-compose-caddy.git
```

4. install docker with compose: 
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

5. run the script:
```bash
sudo bash generate-config.sh yourdomain.tld
```
*it will ask if you want to start the server using compose (should just work if previous requirements are met)*

6. your configuration will be in a folder next to the folder containing the repo, it will look like `continuwuity-yourdomain.tld-1772130249` :
```
├── continuwuity-compose-caddy
│   ├── continuwuity-skeleton
│   │   ├── Caddyfile
│   │   ├── compose.yml
│   │   ├── continuwuity.toml
│   │   ├── jwt.env
│   │   └── livekit.yaml
│   ├── LICENSE
│   ├── README.md
│   └── setup.sh
└── continuwuity-yourdomain.tld
    ├── Caddyfile
    ├── compose.yml
    ├── continuwuity.toml
    ├── jwt.env
    └── livekit.yaml

```

## Backup & Updating
**Note: for configurations after the 05.03.2026 only**  

this makes a backup and creates a new config  
```bash
git pull
sudo bash update-config.sh yourdomain.tld
```

---

parts and ideas based on https://github.com/linkpy/c10y-livekit-docker-compose  
Thank you Kaesa, probably would still guess without your help  
trans right are human rights🏳️‍⚧️
