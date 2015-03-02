# LFE Docs Site, v2

This repository holds the code and content for the second version of the LFE
Documentation site. It was originally forked from the
[repository](https://github.com/lfe/docs2) for the
[Github Developer site](https://developer.github.com/). They wrote a
[blog post](https://github.com/blog/1939-how-github-uses-github-to-document-github)
about their developer site which provides some insight into their process.


## Table of Contents

* [Background](#background-)
  * [Work Items](#work-items-)
  * [Migration Plan](#migration-plan-)
* [Contributing to the Docs](#contributing-to-the-docs-)
  * [Getting Set Up](#getting-set-up-)
  * [Organization](#organization-)
  * [Style Guide](#style-guide-)
    * [Terminal Blocks](#terminal-blocks-)
  * [Versioning Docs](#versioning-docs-)
* [Static Site Generator](#static-site-generator-)
  * [Setup](#setup-)
  * [Development](#development-)
  * [Deployment](#deployment-)


## Background [&#x219F;](#table-of-contents)

The LFE documentation site is due for an overhaul:
 * it's hard for new-comers to find what they need
 * it's missing crucial aspects like an officual tutorial
 * too much information is presented
 * the presentation is awkward and poorly organized

The existing LFE documentation site has limitations that ultimately prevent it from being what users need:
 * Jekyll doesn't have an out-of-the-box answer to API docs or large sites with complicated structures and contextual navigation menus
 * Jekyll doesn't offer a way of providing versioned content (e.g., API/release versions)
 * This is an opportunity to identify a project which has succeeded in this particular domain, and build upon their success -- [Github's developer site](https://developer.github.com/v3/) is a prime example of this sort of success.

### Work Items [&#x219F;](#table-of-contents)

The new site aims to address these points. The following tickets are actively being incorporated into the "docs2" work:
 * [Sketch out the IA for a docs site overhaul](https://github.com/lfe/docs/issues/49)
 * [Figure out versioning for docs](https://github.com/lfe/docs/issues/38)
 * [Identify good examples of API documentation](https://github.com/lfe/docs/issues/37)
 * [Re-style new docs2 site](https://github.com/lfe/docs/issues/50)
 * Related minor tickets:
   * [Add useful context at the top of the docs page](https://github.com/lfe/docs/issues/41)
   * [Update "Contributing" Section with New Dev On-Boarding](https://github.com/lfe/docs/issues/32)
   * [Add more resources in the "Erlang" section](https://github.com/lfe/docs/issues/26)
   * [Add style guide links in "Contributing" page](https://github.com/lfe/docs/issues/24)

### Migration Plan [&#x219F;](#table-of-contents)

Once the issues above are determined to be positively solved by this experimental work, we'll start transitioning content from the old docs to the new. When everything looks good, and folks are happy, we'll do the DNS dance.

## Contributing to the Docs [&#x219F;](#table-of-contents)

### Getting Set Up [&#x219F;](#table-of-contents)

See the section [Static Site Generator](#static-site-generator-) below.

### Organization [&#x219F;](#table-of-contents)

For now, see the issue [Sketch out the IA for a docs site overhaul](https://github.com/lfe/docs/issues/49).

### Style Guide [&#x219F;](#table-of-contents)

Not sure how to structure the docs?  Here's what the structure of the
API docs should look like:

    # Document Title

    * TOC
    {:toc}

    ## Section Name

    [introductory text]

    ### Subsection 1

    [detailed text]

    ### Subsection 2

    [detailed text]
    
    ...


**Note**: We're using [Kramdown Markdown extensions](http://kramdown.gettalong.org/syntax.html), such as definition lists.


#### Terminal Blocks [&#x219F;](#table-of-contents)

You can specify terminal blocks with `pre.terminal` elements.  (It'd be nice if
Markdown could do this more cleanly.)

```html
<pre class="terminal">
$ curl foobar
....
</pre>
```

### Versioning Docs [&#x219F;](#table-of-contents)

TBD


## Static Site Generator [&#x219F;](#table-of-contents)

### Setup [&#x219F;](#table-of-contents)

Ruby 1.9 is required to build the site:

```bash
$ brew update
$ curl -L https://get.rvm.io | bash -s stable
$ rvm install readline
$ rvm install 1.9.3 --with-readline-dir=${HOME:-~}/.rvm/usr
```

Then wait while ``rvm`` chews through your monthly energy budget, compiling the
needed bits. Once it installs, activate it with the following:

```bash
$ bash --login
$ rvm use 1.9.3
```

Once you have that crusty version of Ruby installed and
activated, update the activated gems and then get everything
else needed to generate the static site:

```sh
$ gem install rubygems-update
$ update_rubygems
$ gem update --system
$ bundle install
```

If you get the "libxml2 + nokogiri" issue, try this:

```sh
$ brew install libxml2
$ bundle config build.nokogiri \
    "--use-system-libraries --with-xml2-include=/usr/local/opt/libxml2/include/libxml2"
$ bundle install
```

You can see the available commands with nanoc:

```sh
$ bundle exec nanoc -h
```

Nanoc has [some nice documentation](http://nanoc.ws/docs/tutorial/) to get you
started.  Though if you're mainly concerned with editing or adding content, you
won't need to know much about nanoc.

[nanoc]: http://nanoc.ws/


### Development [&#x219F;](#table-of-contents)

Nanoc compiles the site into static files living in `./output`.  It's
smart enough not to try to compile unchanged files:

```sh
$ bundle exec nanoc compile
Loading site data...
Compiling site...
   identical  [0.00s]  output/css/960.css
   identical  [0.00s]  output/css/pygments.css
   identical  [0.00s]  output/css/reset.css
   identical  [0.00s]  output/css/styles.css
   identical  [0.00s]  output/css/uv_active4d.css
      update  [0.28s]  output/index.html
      update  [1.31s]  output/v3/gists/comments/index.html
      update  [1.92s]  output/v3/gists/index.html
      update  [0.25s]  output/v3/issues/comments/index.html
      update  [0.99s]  output/v3/issues/labels/index.html
      update  [0.49s]  output/v3/issues/milestones/index.html
      update  [0.50s]  output/v3/issues/index.html
      update  [0.05s]  output/v3/index.html

Site compiled in 5.81s.
```

You can setup whatever you want to view the files. If using the adsf
gem (as listed in the Gemfile), you can start Webrick:

```sh
$ bundle exec nanoc view
$ open http://localhost:3000
```

These two are so useful (and too long to type) that they are combined into a single ``make`` target, so you may simple do this:

```sh
$ make rebuild
```

nanoc does offer an "autocompile" feature, but it runs painfully slowly:

```sh
$ bundle exec nanoc autocompile
```

Since that also starts a web server, there's no need to run `nanoc view`.

### Deployment [&#x219F;](#table-of-contents)

```sh
$ bundle exec rake publish
```

