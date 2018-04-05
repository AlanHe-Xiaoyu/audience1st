[![Maintainability](https://api.codeclimate.com/v1/badges/a99a88d28ad37a79dbf6/maintainability)](https://codeclimate.com/github/codeclimate/codeclimate/maintainability)
[![Build Status](https://travis-ci.org/armandofox/audience1st.svg?branch=master)](https://travis-ci.org/armandofox/audience1st)
[![Test Coverage](https://api.codeclimate.com/v1/badges/a99a88d28ad37a79dbf6/test_coverage)](https://codeclimate.com/github/codeclimate/codeclimate/test_coverage)

Audience1st was written by [Armando Fox](https://github.com/armandofox) with contributions from
[Xiao Fu](https://github.com/fxdawnn),
[Wayne Leung](https://github.com/WayneLeung12),
[Jason Lum](https://github.com/jayl109),
[Sanket Padmanabhan](https://github.com/sanketq),
[Andrew Sun](https://github.com/andrewsun98),
[Jack Wan](https://github.com/WanNJ)


# This information is for developers and deployers

Perhaps you intended to [learn about Audience1st features and/or have us install and host it for you](https://armandofox.github.io/audience1st/)?

You only need the information on this page if you are deploying and maintaining Audience1st yourself.  If so, this page assumes you are IT-savvy and provides the information needed to help you get this Rails 4/Ruby 2.3 app deployed.

# Deployment

This is a stock Rails 4 app, with the following exceptions/additions:

0. The task `Customer.notify_upcoming_birthdays` emails an administrator or boxoffice manager with information about customers whose birthdays are coming up soon.  The threshold for "soon" can be set in Admin > Options.

0. The task `EmailGoldstar.receive(STDIN.read)` should be invoked to consume incoming emails from Goldstar.  See the installation section on Goldstar integration, below.

# Multi-tenancy

**This is important.**  By default Audience1st can be setup as
multi-tenant using the `apartment` gem.  If you're just setting up ticketing
for a single venue, multi-tenancy probably creates more problems for you
than it solves.

To **disable** multi-tenancy:

1. Remove `gem 'apartment'` from the `Gemfile` before running `bundle
install`

2. Remove the file `config/initializers/apartment.rb`

3. Make sure your `config/application.yml` (see below) does **not**
contain any mention of `tenant_names`

# Required external integrations

You will need to create a file `config/application.yml` containing the following:

```yaml
session_secret: "30 or more random characters string"
tenant_names: venue1,venue2,venue3
```

The `tenant_names` should **only** be present if using multi-tenancy.
Each tenant name is assumed to correspond to a subdomain, so in the
exame above, the appropriate tenant would be chosen based on the URL
subdomain (`venue1.myticketing.com`, `venue2.myticketing.com`, etc.)
Without this line, the domain/subdomain are irrelevant and there is only
a single tenant.

**Note:** If you decide to use multi-tenancy but change the
tenant-selection scheme (see the `apartment` gem's documentation for
what this means), you'll also need to edit the before-suite logic in
`features/support/env.rb` and `spec/support/rails_helper.rb`.  Those
bits of code ensure that testing works properly with multi-tenancy
enabled, but they rely on the tenant name being the DNS subdomain.  If
you don't know what this means, you should probably ask for assistance
deploying this software. :-)

# First-time deployment

Deploy the app as you would a normal Rails app, including `rake
db:schema:load` (don't try running the migrations, as many of them use
syntax that is long deprecated).  Only portable SQL features are used,
and the schema has been tried with MySQL, Postgres, and SQLite.

Then run the task `rake db:seed` on the production database, which creates a few special users, including the administrative user `admin@audience1st.com` with password `admin`.

The app should now be up and running; login and change the administrator password.  Later you can designate other users as administrators.

# Integration with Goldstar™

See the documentation on how Goldstar integration is handled in the administrator UI.

The way Goldstar works is they send your organization an email containing both the will-call list as a human-readable attachment (spreadsheet or PDF) and a link to download an XML representation of the will-call list.

Thus there are two ways you can get Goldstar will-call info for each performance into Audience1st:

1. You manually download the appropriate XML file, then use the Import mechanism in the Audience1st GUI

2. You arrange to forward a copy of Goldstar's emails to Audience1st.  Audience1st will parse the email to find the download URL, download the XML list, and parse it itself.

To support scenario 2, you must be able to configure your email system so that email received in a particular mailbox is piped to a program.  Arrange for any Goldstar emails to be fed to the following command line:

`RAILS_ENV=production $APP_ROOT/script/runner 'EmailGoldstar.receive(STDIN.read)'`

Whenever an email is fed to this task, it will eventually generate a notification email to an address specified in Admin > Options notifying someone of what happened.  If the email was a valid Goldstar will-call list, the notification will usually say "XX customers added to will-call for date YY".  If it was not a valid Goldstar will-call list, the notification will say something like "It didn't look like a will-call list, so I ignored it."


