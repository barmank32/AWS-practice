# AWS-practice

## AWS CLI
```
sudo apt-get install -y python-dev python-pip
sudo pip install awscli
aws --version
aws configure
```
https://riptutorial.com/ru/aws-cli
## AWS Terraform
https://linux-notes.org/rabota-s-aws-vpc-i-terraform-v-unix-linux/
https://hands-on.cloud/terraform-recipe-managing-aws-vpc-creating-public-subnet/
## VPC Network
![](https://dev.1c-bitrix.ru/images/hl-projects/clouds/tmp/vpc.png)
### EIP к instance
Для того чтобы прицепить надо поднять:
- `resource "aws_eip"` - привязываем instance к внешнему IP
- `resource "aws_internet_gateway"` - GW для VPC
- `resource "aws_route_table"` - прописываем маршруты subnet<>GW

