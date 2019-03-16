#!/bin/bash
#
# Copyright (c) 2015- azu
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Test if pull request
if [ "$TRAVIS_PULL_REQUEST" = "false" ] || [ -z "$TRAVIS_PULL_REQUEST" ]; then
  echo 'not pull request.'
  exit 0
fi

# Fetch other branch
if [ "$TRAVIS" == "true" ]; then
  git checkout $TRAVIS_BRANCH
  git pull origin $TRAVIS_BRANCH

  git checkout $TRAVIS_PULL_REQUEST_BRANCH
fi

# Install saddler
# https://github.com/packsaddle/ruby-saddler
# Need secret env: `GITHUB_ACCESS_TOKEN=xxx`
gem install --no-document checkstyle_filter-git saddler saddler-reporter-github

# filter files and lint
echo "${TRAVIS_BRANCH}...HEAD"
echo "textlint -> review_comments"
git diff --name-only --diff-filter=ACMR ${TRAVIS_BRANCH} \
| grep -a '.*.md$' \
| xargs $(yarn bin)/textlint -f checkstyle \
| checkstyle_filter-git diff ${TRAVIS_BRANCH} \
| saddler report \
    --require saddler/reporter/github \
    --reporter Saddler::Reporter::Github::PullRequestReviewComment
