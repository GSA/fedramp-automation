# FedRAMP Automation Website

This subdirectory contains source code for the FedRAMP OSCAL GitHub Page (URL TBD). Below are instructions for building the site for local development if making any contributions to the documentation.

The website is built using the [Hugo](https://gohugo.io/) static site generator and the [United States Web Design System](https://designsystem.digital.gov/) (USWDS).

## Prerequisites

If using Docker:

- [Docker 20.10+](https://docs.docker.com/install/)

If not using Docker:

- macOS, Linux or Windows Subsystem for Linux (WSL) (model doc build scripts don't support Windows natively at this time)
- [Hugo](https://gohugo.io/)


## Using Hugo

[Hugo](https://gohugo.io/) is a popular open source static site generator. It is a general-purpose framework that builds pages when the content is created or updated.

Instructions for installing the Hugo CLI on your OS can be found [here](https://gohugo.io/getting-started/installing).

The website's visual styling is also backed by the U.S. Web Design System (USWDS) via an open source Hugo theme at https://github.com/usnistgov/hugo-uswds.

The USWDS framework is documented here: https://designsystem.digital.gov/.

### Building the site with LiveReload

Hugo provides built-in LiveReload which watches for any changes to the source content and automatically reloads the site when changes are detected.

1. Pull the currently used USWDS Hugo theme revision to your locally cloned copy of the OSCAL repo by executing the following command from within the folder of the git repo

 ```
git submodule update --init
```

2. Verify that Hugo is installed

```
hugo version
```
NOTE: The extended version of Hugo is required. The reported version should include the word "extended".

3. Navigate into the `docs/` directory

```
cd docs
```

4. Start the Hugo server

```
hugo server -v --debug --minify
```

alternatively, you may bind Hugo to a network adapter on your workstation using its assigned IP address

```
hugo server -v --debug --minify --bind [ipv4-address] -b http://[ipv4-address]:1313/fedramp-automation
```

5. Open your browser and navigate to `http://localhost:1313/fedramp-automation` to view the locally built site.

If you bound Hugo to an IP address, navigate to `http://[ipv4-address]:1313/fedramp-automation` either locally or with another device on the network.

Whenever you make any changes to the content with the Hugo server running, you'll notice that the site automatically updates itself to reflect those changes.


## Developing with Docker

Coming soon:  The site will be available as a Docker container.  

<!--
The website can also be developed and built using the included Docker resources.

Assuming you've [installed Docker](https://docs.docker.com/install/) and [Docker Compose](https://docs.docker.com/compose/install/) for your system, you can build and serve the site using Docker Compose as follows:

```
docker-compose build
docker-compose up
```

Once the site is running, it can be accessed at http://localhost:1313/fedramp-automation. 
-->
