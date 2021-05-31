FROM centos:7

VOLUME [ "/sys/fs/cgroup" ] 

RUN yum -y update; yum clean all
RUN yum -y install systemd; yum clean all; \
(cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;

RUN set -x \
    && yum -y install wget \
    && wget https://packages.chef.io/files/stable/chef-server/14.4.4/el/7/chef-server-core-14.4.4-1.el7.x86_64.rpm \
    && rpm -Uvh chef-server-core-14.4.4-1.el7.x86_64.rpm \
    && rm chef-server-core-14.4.4-1.el7.x86_64.rpm \
    && yum -y remove wget

EXPOSE 443

COPY default.rb /opt/opscode/embedded/cookbooks/private-chef/attributes

ENTRYPOINT chef-server-ctl reconfigure --chef-license=accept \
           && chef-server-ctl user-create admin admin admin admin@example.com 'root' \
           && chef-server-ctl org-create neworg "New Org Inc." -a admin \
           && chef-server-ctl install chef-manage \
           && chef-server-ctl reconfigure \
           && chef-manage-ctl reconfigure

CMD ["/usr/sbin/init"]           