import pulumi
import pulumi_yandex as yandex

# Создаём облачную сеть
network = yandex.VpcNetwork(
    "pulumi-wp-network",
    name="pulumi-wp-network",
)

# Создаём подсети в цикле (демонстрация возможностей языка программирования)
zones = {
    "a": "192.168.70.0/24",
    "b": "192.168.71.0/24",
}

subnets = {}
for zone_suffix, cidr in zones.items():
    subnets[zone_suffix] = yandex.VpcSubnet(
        f"pulumi-subnet-{zone_suffix}",
        name=f"pulumi-subnet-{zone_suffix}",
        zone=f"ru-central1-{zone_suffix}",
        network_id=network.id,
        v4_cidr_blocks=[cidr],
    )

# Экспортируем выходные параметры (аналог output в Terraform)
pulumi.export("network_id", network.id)
pulumi.export("subnet_a_id", subnets["a"].id)
pulumi.export("subnet_b_id", subnets["b"].id)
