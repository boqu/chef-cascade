# Chef Cascade

Cascade chef integration

## Description

Chef Cascade is a minimally functional chef client, that downloads its chef artifacts via OS packages. It can be used standalone or with the rest of the cascade integration for a blown distributed chef solution without the need for a chef server.

## Notes

- This must be built against the ruby you are using for chef
- You will need to change the bin file ruby paths if you do not use the omnibus chef package as most sane folks do
- Have a look at the -r flag for specifying roles for a standalone experience
- You may also list your roles as an array in /etc/chef/roles.yml
- This is a barely functional implementation, it only offers the basics
- This is a transitional solution, as such I am not going to devote resources to pushing this much farther forward (see cascade roadmap for more details)
