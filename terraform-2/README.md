# Реализация проброса Public IP через EIP к Instance
## VPC Network
![](https://dev.1c-bitrix.ru/images/hl-projects/clouds/tmp/vpc.png)
### EIP к instance
Для того чтобы прицепить надо поднять:
- `resource "aws_eip"` - привязываем instance к внешнему IP
- `resource "aws_internet_gateway"` - GW для VPC
- `resource "aws_route_table"` - прописываем маршруты subnet<>GW
