## One Maths Vagrant Setup

As per the tutorial located here: https://gorails.com/guides/using-vagrant-for-rails-development

----

#### Step 1

Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
Install [Vagrant](http://www.vagrantup.com/downloads.html)

#### Step 2

Install plugins for Vagrant

`vagrant plugin install vagrant-vbguest`
`vagrant plugin install vagrant-librarian-chef-nochef`


#### Step 3

`cd /vagrant`
`sudo -u postgres createuser --interactive` // Create user called 'ubuntu'
`rails db:create`
`pg_restore -U ubuntu -d one_maths_development current_data.psql`
'rails db:migrate'

#### NOTE

When running the server route it to `0.0.0.0` so when you visit `localhost:3000` on your machine you can view the website live

`rails s -b0.0.0.0`

#### Extra

`vagrant box add package.box --name rails_box`
`vagrant init rails_box`
`vagrant up`
