FROM centos:7

RUN set -x \
    && yum install wget -y \
    && wget https://packages.chef.io/files/stable/chef-server/14.4.4/el/7/chef-server-core-14.4.4-1.el7.x86_64.rpm \
    && rpm -Uvh chef-server-core-14.4.4-1.el7.x86_64.rpm \
    && rm chef-server-core-14.4.4-1.el7.x86_64.rpm \
    && yum remove wget -y 

EXPOSE 443

COPY default.rb /opt/opscode/embedded/cookbooks/private-chef/attributes

ENTRYPOINT chef-server-ctl reconfigure --chef-license=accept \
           && chef-server-ctl user-create admin admin admin admin@example.com 'root' \
           && chef-server-ctl org-create neworg "New Org Inc." -a admin \
           && chef-server-ctl install chef-manage \
           && chef-server-ctl reconfigure \
           && chef-manage-ctl reconfigure