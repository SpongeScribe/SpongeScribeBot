    Copyright 2020 Drewry Pope
    This Source Code Form is subject to the terms of the Mozilla Public
    License, v. 2.0. If a copy of the MPL was not distributed with this
    file, You can obtain one at http://mozilla.org/MPL/2.0/.


----


# SpongeScribeBot
strangetext transcription
 - source: https://github.com/SpongeScribe/SpongeScribeBot#readme
 - bot: https://twitter.com/SpongeScribe
 - owner/author/contact: https://twitter.com/dezren39
 - code_of_conduct: https://github.com/SpongeScribe/SpongeScribeBot/blob/main/CODE_OF_CONDUCT.md
 - contributors: https://github.com/SpongeScribe/SpongeScribeBot/blob/main/CONTRIBUTORS.md
 - license: https://github.com/SpongeScribe/SpongeScribeBot/blob/main/LICENSE
 - license.NOTICE: https://github.com/SpongeScribe/SpongeScribeBot/blob/main/NOTICE.LICENSE.md
 - changelog: https://github.com/SpongeScribe/SpongeScribeBot/blob/main/CHANGELOG.md


----


# IMPORTANT NOTE:
Please note that this project is released with a
Contributor Code of Conduct, located in the root
directory of this project under the file name:

 - `CODE_OF_CONDUCT.md`

By participating in this project you agree to abide by its terms.

Thank you for your participation.

 - code_of_conduct: https://github.com/SpongeScribe/SpongeScribeBot/blob/main/CODE_OF_CONDUCT.md
 - contributors: https://github.com/SpongeScribe/SpongeScribeBot/blob/main/CONTRIBUTORS.md


----


## Source Code Form License Notice Attached Outside The Particular File

If it is not possible or desirable to put the notice in a particular file,
a License file named 'LICENSE' or 'LICENSE.md' or 'NOTICE.LICENSE.md' will
be present in each directory which has particular file(s) in that directory.

The License file will associate each particular file's name with the appropriate
Source Code Form License Notice and any relevant Copyright or other notices.

 - license: https://github.com/SpongeScribe/SpongeScribeBot/blob/main/LICENSE
 - license.NOTICE: https://github.com/SpongeScribe/SpongeScribeBot/blob/main/NOTICE.LICENSE.md


----


All scripts and calls expected to come from a `pwd` of the project root.
Scripts in `app/scripts` should be ran by docker.

If you ever find files aren't making it into docker, check: `.dockerignore` ALLOW LIST
If you ever find files aren't making it into git, check: `.gitignore` BLOCK LIST
If you ever find files aren't making it into `npm pack`, check: `app/.npmignore` BLOCK LIST

`.env` files are blocked from docker container images, but they can be brought in for dev environments with `docker` `--volume`, `docker-compose`, etc. 

To run `app/scripts` locally, run `scripts/etc/create-data-dirs-and-symlinks.sh`
If you add new `app/scripts`, you may need to rerun: `scripts/etc/append-symlinks-to-gitignore.sh`
To cleanup symlinks, run `scripts/etc/delete-symlinks.sh`

----

# TODO / NOTES

todo: rename data to dat

todo: lib vs dist
	src: (uncompiled)
	lib: compiled-node
	dist: compiled-browser
	https://2ality.com/2017/07/npm-packages-via-babel.html
	https://gist.github.com/ncochard/6cce17272a069fdb4ac92569d85508f4
	# Allow files and folders with a pattern starting with !
	!lib/**/*.js


check files count merge to one script

docker env script merge
docker mount-nomount merge

confirm docker, docker-compose, manual, sleep, twitter, random run, random1krun, drop N files, get N*M images


get twitter autoreply webhook going

post image
post image with alt text
post image with alt text as reply to webhook

.lower sponge text
ascii cursive sarcastric bold heavy
ascii strange/crypt text
ascii pictures with words
describe pictures with words
build general ai
humans.txt robots.txt website blog blog post static ? keybase auth? lets encrypt? security.txt


TODO + manual still: https://github.com/github-changelog-generator/github-changelog-generator
https://github.com/skywinder/gitlab-changelog-generator/blob/master/CHANGELOG.md
automate package.json npm pack, npm publish
automate version increase ticker
semver2.0


todo: update all scripts to reference `pwd`/scripts then remove the ln -s pwd . from build.sh
