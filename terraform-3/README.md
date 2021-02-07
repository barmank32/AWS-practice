# Реализация проброса NAT GW
## VPC Network
![](https://docs.aws.amazon.com/vpc/latest/userguide/images/nat-gateway-diagram.png)
NAT GW тяжёлая сущность, похожая на отдельный instance<br>
ему необходим отдельный EIP
### NAT GW к instance
Для того чтобы поднять NAT GW в публичном subnet:
- `resource "aws_subnet"` - Публичный subnet с маршрутом в интернет
- `resource "aws_eip"` - отдельный EIP для NAT GW
- `resource "aws_route_table"` - прописываем маршруты subnet<>GW
Для того чтобы направить трафик приватных subnet:
- `resource "aws_route_table"` - прописать маршрут subnet<>NAT

