FROM debian:12

RUN apt-get update && apt-get install -y \
    qemu-kvm libvirt-daemon-system libvirt-clients virt-manager \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

COPY entrypoint /opt/entrypoint
RUN chmod +x /opt/entrypoint

ENTRYPOINT ["/opt/entrypoint"]
