## CosmosHub Infrastructure

## Overview
![Cosmos Infrastructure](https://github.com/samuelarogbonlo/zKevm-Nodes-poc/assets/47984109/51976943-4c36-4f30-84d2-124f1ca9ed0b)

This project involves bootstraping and exposing a new Cosmos node using Ansible and Terraform. It allows for building the reauired binary from source, node initialization and of course the bianry can be updated if required.

Also, the setup has a feature to retrieve the latest block height synced by the node and reportted using a prometheus endpoint. It also achieves the following majorly:

**- Idempotency:** This means that after the initial setup, no re-running will interfere with node operations
**- Configurability:** Many variables are configurable like the token, ssh-key fingerprint, persistent peers, seeds and much more.
**- Resiliency:** The cosmos node and the prometheus exporter runs as a systemd service and will restart after crashing.

### Prerequisites
- Ansible
- Make
- Terraform

### Installation
- Clone this repository with `git clone https://github.com/samuelarogbonlo/cosmos-infra.git`
- Create a file called `terraform.tfvars` in the main terraform directory and use this format to populate the file
```
digitalocean_token = ""
ssh_keys = ["ssh-key-fingerprint"]
```
- Check [here](https://services.lavenderfive.com/mainnet/cosmoshub/snapshot) for the latest snapshot link to be used in the `<snapshot ID>` variable in `sync_from_snapshot.yml` task
- Naviagate to the `cosmos-infra` directory and run `make`. This will provision the Infrastructure, dynamically send the IP address to ansible and then run the cosmos installation.
- Once the setup completes it's building and the node is syncing, you can check the retrieved block height by checking `http://<server_ip>:8000/metrics` on the public browser of your local machine. Alternatively, you can run `curl http://localhost:8000/metrics` on your cosmos node host machine terminal.

> **_Note_**
> - Remember you can use any cloud of choice and make the Infrastructure as Code changes to accomodate your cloud and server specifications.

## Author
- Samuel Arogbonlo - [GitHub](https://github.com/samuelarogbonlo)

## License
The MIT License (http://www.opensource.org/licenses/mit-license.php)