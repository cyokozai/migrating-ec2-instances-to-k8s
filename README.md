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

## Run Terraform commands

- Comment out the backend.tf file and `terraform.backend.s3` in main.tf file.  
- Run `terraform init`.  
- Run `terraform apply -var-file="terraform.tfvars"`.  
- Create S3 bucket for Terraform state

  ```shell
  aws s3api create-bucket \
    --bucket yinoue-terraform-statefile \
     --region ap-northeast-1 \
     --create-bucket-configuration LocationConstraint=ap-northeast-1
  ```

- Recomment out the backend.tf file and `terraform.backend.s3` in main.tf file and comment out `terraform.backend.local` in main.tf file.  
- Second times init: Run `terraform init` with `-reconfigure` options.  

  ```shell
  terraform init -reconfigure
  ```

  - Result
  
    ```shell
    terraform init -reconfigure
    Initializing the backend...
    Do you want to copy existing state to the new backend?

      Enter a value: yes

    Terraform has been successfully initialized!
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
