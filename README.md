![Code Red](https://github.com/floriandejonckheere/code-red/raw/master/logo.png)

![Continuous Integration](https://github.com/floriandejonckheere/code-red/workflows/Continuous%20Integration/badge.svg)
![Continuous Deployment](https://github.com/floriandejonckheere/code-red/workflows/Continuous%20Deployment/badge.svg)

![Release](https://img.shields.io/github/v/release/floriandejonckheere/code-red?label=Latest%20release)
![Deployment](https://img.shields.io/github/deployments/floriandejonckheere/code-red/production?label=Deployment)

Code Red is a simple project management app, using a graph-based approach to task and resource management.
This app was built for the [Build on Redis Hackathon 2021](https://hackathons.redislabs.com/hackathons/build-on-redis-hackathon).

A demo server is publicly available at [https://codered.pm/](https://codered.pm/), the database resets to sample data every 15 minutes.

## What it does

Code Red is a simple app that allows you to manage and visualize your heavily interdependent project using a directed graph.

A project consists of a single graph, containing many tasks.
A task can be an idea, goal, epic, feature, simple task or bug.
It has a status as well: to do, in progress, in review or done.

Tasks can be linked to each other using a generic link (related to), or a specific relationship (blocked by, child of).

## How it works

![Architecture](https://github.com/floriandejonckheere/code-red/raw/master/architecture.png)

The application is conceived as a single Ruby on Rails monolith.
For persistence, the application stores its data both relationally and in a graph: the former using PostgreSQL, the latter in [RedisGraph](https://oss.redislabs.com/redisgraph/), a Redis module by RedisLabs.
Administrative data (such as users and projects) is stored relationally, while storage of tasks and the relationships between them is delegated to the graph storage.

The graph storage layer features a small custom built [DSL](#dsl), that translates method calls in the style of ActiveRecord into RedisGraph queries.

The web app is plain HTML sprinkled with some JavaScript (Stimulus for interactivity and [D3.js](https://d3js.org/)/[cola.js](https://ialab.it.monash.edu/webcola/) for graph visualization).
The HTML is rendered server-side before being sent to the client.
This means that instead of using JSON to transfer data between the server and client, HTML is sent and only the part of the DOM that changes, is replaced.
Please refer to [Turbo](https://turbo.hotwire.dev/) and [Stimulus](https://stimulus.hotwire.dev/) documentation for more information.

Graph data is fetched from a JSON endpoint using D3's JSON plugin.
In order to keep the application fast and snappy, [Hotwire](https://hotwire.dev/) is used as a framework.

Finally, the UI is built using [TailwindCSS](https://tailwindcss.com/), [Heroicons](https://heroicons.com/), [Collecticons](http://collecticons.io/) and [QuillJS](https://quilljs.com/) for the rich text editor.

## DSL

A small Domain Specific Language was built to accommodate and simplify graph persistence.
It aims at providing a small but robust interface that should feel familiar to developers used to ActiveRecord's API.
The main class implementing this construction can be found at [app/graph/dsl.rb](https://github.com/floriandejonckheere/code-red/blob/master/app/graph/dsl.rb).

Example of a query:

```ruby
query = graph
  .match(:n, from.class.name, id: from.id)
  .to(:r, type)
  .match(:m, to.class.name)
  .delete(:r)

query.to_cypher

# => "MATCH (n:Task {id: 'c9bc52a0-c436-499c-954c-da40e82f50b2'}) -[r:blocked_by]-> (m:Task) DELETE r"

query.execute

# => []
```

## Setup

First, ensure you have a working Docker environment.

Pull the images and start the containers:

```
docker-compose up -d
```

Compile the frontend code:

```
docker-compose run --rm app bin/webpack
```

Set up the PostgreSQL database:

```
docker-compose exec app rails db:setup
```

Load sample data into the PostgreSQL and Redis databases:

```
docker-compose exec app rails database:seed
```

The application should now be available at [http://localhost:3000](http://localhost:3000).

## Development

Use the `bin/update` script to update your development environment dependencies.

If you want to enable faster compilation of assets, run Webpack dev server in the same container as the Rails server:

```
docker-compose exec app bin/webpack-bin-server
```

## Debugging

To debug the server component in your IDE, start the `debug` instead of the `app` container, and connect to `localhost:1234`.

## Testing

Run the test suite:

```
rspec
```

## Secrets

### Repository secrets

Github secrets for release:

- `DOCKER_TOKEN` (needed for [Github Container Registry](https://docs.github.com/en/packages/getting-started-with-github-container-registry/migrating-to-github-container-registry-for-docker-images))

### Environment secrets

Github secrets for continuous deployment (process):

- `DOCKER_TOKEN` (needed for [Github Container Registry](https://docs.github.com/en/packages/getting-started-with-github-container-registry/migrating-to-github-container-registry-for-docker-images))
- `GANDIV5_API_KEY` (needed for Let's Encrypt integration)
- `SECRET_KEY_BASE`

- `SSH_HOST` (deployment host)
- `SSH_USER` (deployment user)
- `SSH_KEY` (private key)
- `SSH_HOST_KEY` (host public key)

## Releasing

Update the changelog and bump the version in `lib/code_red/version.rb`.
Create a tag for the version and push it to Github.
A Docker image will automatically be built and pushed to the registry.

```sh
nano lib/code_red/version.rb
git add lib/code_red/version.rb
git commit -m "Bump version to v1.0.0"
git tag v1.0.0
git push origin master
git push origin v1.0.0
```

## License

See [LICENSE.md](LICENSE.md).
