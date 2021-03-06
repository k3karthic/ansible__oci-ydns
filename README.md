# Ansible — Dynamic DNS using YDNS

This playbook creates a bash script from the following fork. The script sends the public IP of an instance on Oracle Cloud to [YDNS](https://ydns.io/). A [Cron](https://en.wikipedia.org/wiki/Cron) job runs the script once every hour.
* GitHub: [github.com/k3karthic/bash-updater](https://github.com/k3karthic/bash-updater)
* Codeberg: [codeberg.org/k3karthic/bash-updater](https://codeberg.org/k3karthic/bash-updater)

**Assumption:** Instance deployed using either one of the Terraform scripts below,
* terraform__oci-instance-1
	* GitHub: [github.com/k3karthic/terraform__oci-instance-1](https://github.com/k3karthic/terraform__oci-instance-1)
	* Codeberg: [codeberg.org/k3karthic/terraform__oci-instance-1](https://codeberg.org/k3karthic/terraform__oci-instance-1)
* terraform__oci-instance-2
	* GitHub: [github.com/k3karthic/terraform__oci-instance-2](https://github.com/k3karthic/terraform__oci-instance-2)
	* Codeberg: [codeberg.org/k3karthic/terraform__oci-instance-2](https://codeberg.org/k3karthic/terraform__oci-instance-2)

## Code Mirrors

* GitHub: [github.com/k3karthic/ansible__oci-ydns](https://github.com/k3karthic/ansible__oci-ydns/)
* Codeberg: [codeberg.org/k3karthic/ansible__oci-ydns](https://codeberg.org/k3karthic/ansible__oci-ydns)

## Requirements

Install the following before running the playbook,
```
pip install oci
ansible-galaxy collection install oracle.oci
```

## Dynamic Inventory

The Oracle [Ansible Inventory Plugin](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/ansibleinventoryintro.htm) populates public Ubuntu instances.

All target Ubuntu instances must have the freeform tag `ydns_host: <hostname>`.

## Configuration

1. Update `inventory/oracle.oci.yml`,
    1. Specify the region where you have deployed your server on Oracle Cloud. List of regions are at [docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm).
    1. Configure the authentication as per the [Oracle Guide](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm#SDK_and_CLI_Configuration_File)
1. Set username and ssh authentication in `inventory/group_vars/`
2. Set username and password for YDNS in `inventory/group_vars/ydns.yml`. Use `inventory/group_vars/ydns.yml.sample` as a reference.

To use more than a single SSH keypair (with passphrases), use ssh-agent to store them.

Run the following command to start `ssh-agent`,
```
$ eval "$(ssh-agent -s)"
```

Add each keypair using the following command,
```
$ ssh-add <path to keypair>
```

## Deployment

Run the playbook using the following command,
```
./bin/apply.sh
```

## Encryption

Encrypt sensitive files (SSH private keys) before saving them. `.gitignore` must contain the unencrypted file paths.

Use the following command to decrypt the files after cloning the repository,

```
$ ./bin/decrypt.sh
```

Use the following command after running terraform to update the encrypted files,

```
$ ./bin/encrypt.sh <gpg key id>
```
