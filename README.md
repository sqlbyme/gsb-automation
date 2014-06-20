# gsb-automation scripting
### This ruby sciprt provides automation for recycling getsongbird.com web front end servers.

## Description

- The purpose of this script is to allow a Jenkins job to recycle the getsongbird.com web front end servers on a timed basis as well as on-demand.

## Dependencies
* You will need to setup an rvm environment running ruby-1.9.3-p194.
  * You will also need to create a gemset called `gsb-automation`
    * note: make sure you remember to issue `rvm use ruby-1.9.3-p194@gsb-automation --create` from the command line.
    * remember to create a .rvmrc file which contains one line: `rvm use ruby-1.9.3-p194@gsb-automation`

      
## Setup
1. Clone the Repo: Run `git clone git@github.com:sqlbyme/gsb-automation.git`
2. Install the dependencies
3. Run `gem install bundler`
4. Run `bundle install`
5. Run `bundle exec rake gsb`

## Tests
1. Run `RACK_ENV=test bundle exec rake spec`

## Jenkins Jobs
* The following Jenkins jobs are associated with this script:
  * gsb-nightly-deploy - nightly cron job to recycle all web front end servers
  * gsb-deploy-production - on-demand job to receyle web front end servers based on code revision to gsb-2.0 repo
  * gsb-automation-deploy - on-demand job to push changes made to this script to the jenkins server


## Branches

This repo consists of one branch, currently it is:
  1. checkin

#### Pushing
To push to each app you'll need to do the following:

##### polycom-directory-api:
      git remote add origin git@github.com:sqlbyme/gsb-automation.git
      git push origin checkin

## License

This application is released under the MIT license:

* http://www.opensource.org/licenses/MIT

The MIT License (MIT)

Copyright (c) 2014 Michael Edwards - sqlby.me

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
