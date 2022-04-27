## Tools
- Terraform (https://www.terraform.io/)

## Prerequisites
* Create Secret for Application database
  * Constraints: At least 8 printable ASCII characters. Can't contain any of the following: / (slash), '(single quote), "(double quote) and @ (at sign).
* Create Secret for Audit database
  * Constraints: At least 8 printable ASCII characters. Can't contain any of the following: / (slash), '(single quote), "(double quote) and @ (at sign).
* Create Secret for Report database
  * Constraints: At least 8 printable ASCII characters. Can't contain any of the following: / (slash), '(single quote), "(double quote) and @ (at sign).
* Import certificate into ACM
* Create ElasticsearchServiceLinkedRole using AWS CLI (use the command below):
      aws iam create-service-linked-role --aws-service-name es.amazonaws.com
* Create Secret for Elasticsearch
  * Constraints: Secret must have "username" and "password" keys.

## Deployment
Install dependencies:
```shell
terraform init
```
Deploy all environments:
```shell
terraform apply
```
Deploy stg:
```shell
terraform apply -target=module.stg
```
Deploy dev:
```shell
terraform apply -target=module.dev
```
Deploy rmd:
```shell
terraform apply -target=module.rmd
```