# Migrating EC2 instances to Kubernetes

## What is the project ?

## Set up

### Create key pair

- Run the following command. 

  ```shell
  aws ec2 create-key-pair \
    --key-name ec2-key-pair \
    --key-type rsa \
    --key-format pem \
    --query "KeyMaterial" \
    --output text > ~/.ssh/ec2-key-pair.pem
  ```

- Confirm the private key file. 

  ```shell
  ls ~/.ssh | grep ec2-key-pair
  ```

- Change the private key file privileges.

  ```shell
  chmod 400 ~/.ssh/ec2-key-pair.pem
  ```
