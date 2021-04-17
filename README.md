# Code Red

![Continuous Integration](https://github.com/floriandejonckheere/code-red/workflows/Continuous%20Integration/badge.svg)
![Continuous Deployment](https://github.com/floriandejonckheere/code-red/workflows/Continuous%20Deployment/badge.svg)

![Release](https://img.shields.io/github/v/release/floriandejonckheere/code-red?label=Latest%20release)
![Deployment](https://img.shields.io/github/deployments/floriandejonckheere/code-red/production?label=Deployment)

Code Red is a collaborative project management app, using a graph-based approach to task and resource management.

## Set up

Use the `bin/setup` script or run the following steps manually.

Set up the PostgreSQL database:

```
rails db:setup
```

Initialize database seeds:

```
rails database:seed             # Production and development seeds
rails database:seed:production  # Production seeds
rails database:seed:development # Development seeds
```

## Migrating

Run database migrations:

```
rails db:migrate
```

## Development

Use the `bin/update` script to update your development environment dependencies.

## Debugging

To debug the server component in your IDE, start the `debug` instead of the `app` container, and connect to `localhost:1234`.

## Testing

Seed the test database before running the test suite:

```
rails database:seed:production RAILS_ENV=test
```

Run the test suite:

```
rspec
```

## Secrets

### Repository secrets

Github secrets for continuous integration:

- `APP_EMAIL`

Github secrets for release:

- `DOCKER_TOKEN` (needed for [Github Container Registry](https://docs.github.com/en/packages/getting-started-with-github-container-registry/migrating-to-github-container-registry-for-docker-images))

### Environment secrets

Github secrets for continuous deployment (process):

- `DOCKER_TOKEN` (needed for [Github Container Registry](https://docs.github.com/en/packages/getting-started-with-github-container-registry/migrating-to-github-container-registry-for-docker-images))

Github secrets for continuous deployment (application):

- `SECRET_KEY_BASE`

- `APP_EMAIL`
- `APP_HOST`

- `SMTP_HOST`
- `SMTP_PORT`
- `SMTP_DOMAIN`
- `SMTP_USERNAME`
- `SMTP_PASSWORD`
- `SMTP_FROM`
- `SMTP_TO` (for deployment notifications)

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
