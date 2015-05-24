[![Build Status](https://travis-ci.org/stronglifters/surface.svg?branch=master)](https://travis-ci.org/stronglifters/surface)
[![Code Climate](https://codeclimate.com/github/stronglifters/surface/badges/gpa.svg)](https://codeclimate.com/github/stronglifters/surface)
[![Coverage Status](https://coveralls.io/repos/stronglifters/surface/badge.svg?branch=master)](https://coveralls.io/r/stronglifters/surface?branch=master)

## README

The easiest way to get up and running is to use [vagrant](https://www.vagrantup.com/).

Once you have vagrant installed you can run:

```bash
  $ vagrant up
```

The first time you run the above command it may take a while to get
things set up. After that you can ssh into your vagrant instance.

```bash
  $ vagrant ssh
  $ cd /vagrant
```

The last step is to run the application. From the vagrant ssh shell run:

```bash
  $ bin/foreman start
```

You should now have a fully running instance of the application. The
/vagrant folder in the VM is mounted to match your working directory on
your host machine. So you are free to use whatever editor you like.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
