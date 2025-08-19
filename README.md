# Migrating EC2 instances to Kubernetes

## What is the project ?

## Set up

### Create key pair

- Run the following command.  

  ```shell
  aws ec2 create-key-pair \                                                                                                                                                                   1 х │ 23s │ 16:54:28 
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

## Run Terraform commands

- Create S3 bucket for Terraform state

  ```shell
  aws s3api create-bucket \
    --bucket yinoue-terraform-statefile \
     --region ap-northeast-1 \
     --create-bucket-configuration LocationConstraint=ap-northeast-1
  ```

- First init: Run `terraform init` with `--backend-config` option.  

  ```shell
  terraform init -backend-config=".tfbackend"
  ```

- n times init: Run `terraform init` with `-backend-config` and `-reconfigure` options.  

  ```shell
  terraform init -reconfigure -backend-config=".tfbackend"
  ```

- Provisioning: Run `terraform plan/apply` with `-var-file` option.  
  - Plan  

    ```shell
    terraform plan -var-file="terraform.tfvars"
    ```

  - Apply

    ```shell
    terraform apply -var-file="terraform.tfvars"
    ```