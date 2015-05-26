# Chef Cascade

Cascade chef integration

## Description

Chef Cascade is a minimally functional chef client, that downloads it's chef artifacts via operating system packages. It can be used standalone or with the rest of the cascade integration for a blown distributed chef solution without the need for a chef server.

## Notes

- This must be built against the ruby you are using for chef
- You will need to change the bin file ruby paths if you do not use the omnibus chef package as most sane folks do
- Have a look at the -r flag for specifying roles for a standalone experience
- You can also list your roles as an array in /etc/chef/roles.yml
- This is a barely functional implementation, it pretty much only offers the basics
- I don't really plan on pushing forward with this as I am more interested in embedding mruby in cascade and implementing the resources I require in golang
