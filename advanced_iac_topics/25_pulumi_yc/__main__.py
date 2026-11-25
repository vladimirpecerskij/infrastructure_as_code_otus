import pulumi
import pulumi_yandex as yandex

network = yandex.VpcNetwork("pulumi-wp-net", name="pulumi-wp-net")

subnet = yandex.VpcSubnet(
    "pulumi-wp-subnet",
    name="pulumi-wp-subnet",
    zone="ru-central1-a",
    network_id=network.id,
    v4_cidr_blocks=["192.168.60.0/24"],
)

pulumi.export("network_id", network.id)
pulumi.export("subnet_id", subnet.id)
