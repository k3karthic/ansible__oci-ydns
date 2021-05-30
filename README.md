# Ansible - Dynamic DNS using YDNS

The Ansible playbook in this repository installs and periodically runs a [bash script](https://github.com/k3karthic/bash-updater) which sends the public IP to [YDNS](https://ydns.io/) which is a free dynamic DNS service. 

The playbook assumes the instance runs in Oracle Cloud using the terraform scripts below,
* [https://github.com/k3karthic/terraform__oci-instance-1](https://github.com/k3karthic/terraform__oci-instance-1).
* [https://github.com/k3karthic/terraform__oci-instance-2](https://github.com/k3karthic/terraform__oci-instance-2).

## Requirements

Install the following Ansible modules before running the playbook,
```
pip install oci
ansible-galaxy collection install oracle.oci
```

## Dynamic Inventory

This playbook uses the Oracle [Ansible Inventory Plugin](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/ansibleinventoryintro.htm) to populate public Ubuntu instances dynamically.

Public instances with a YDNS hostname are assumed to have a freeform tag `ydns_host: <hostname>`.

## Playbook Configuration

1. Modify `inventory/oracle.oci.yml`,
    1. specify the region where you have deployed your server on Oracle Cloud.
    1. Configure the authentication as per the [Oracle Guide](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/sdkconfig.htm#SDK_and_CLI_Configuration_File).
1. Set username and ssh authentication in `inventory/group_vars/`.
2. Set username and password for YDNS in `inventory/group_vars/ydns.yml` using the sample `inventory/group_vars/ydns.yml.sample`.

If you are using mutliple SSH key pairs, use the following command to add them to ssh-agent before running the playbook.
```
eval "$(ssh-agent -s)"
ssh-add <path to keypair>
```

## Deployment

Run the playbook using the following command,
```
./bin/apply.sh
```

## Encryption

Sensitive files like the SSH private keys are encrypted before being stored in the repository.

You must add the unencrypted file paths to `.gitignore`.

Use the following command to decrypt the files after cloning the repository,

```
./bin/decrypt.sh
```

Use the following command after running terraform to update the encrypted files,

```
./bin/encrypt.sh <gpg key id>
```
