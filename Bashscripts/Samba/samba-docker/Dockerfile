FROM ubuntu:22.04

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    samba samba-common-bin && \
    apt-get clean

COPY smb.conf /etc/samba/smb.conf
COPY init_users.sh /init_users.sh

RUN chmod +x /init_users.sh

# init users
RUN /init_users.sh

EXPOSE 137/udp 138/udp 139 445

RUN mkdir -p /var/log/samba && touch /var/log/samba/access.log

CMD ["/usr/sbin/smbd", "-F", "--no-process-group"]
