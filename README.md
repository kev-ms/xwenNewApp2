# kic New App

- Click `Use this template` and create a new repo in your `personal GitHub account`
- Open a Codespace from your new repo
  - Wait for on-create and post-create to run
  - Exit your shell and start a new one
    - The shell starts before the *-create scripts are complete

## Verify Cluster

```bash

kic ns
kic pods

# if you get an error
kic cluster create
kic ns
kic pods

```

## Inner-Loop Quick Start

```bash

# create a new app from the dotnet web api template
# You can use any app name that conforms to a dotnet namespace
# - PascalCase
# - alpha only
# - <= 20 chars
kic new dotnet webapi MyApp

# this is important as the CLI is "context aware"
# todo - set default CLI context
cd myapp

```

## Check the K8s Cluster

- the K8s cluster is running `inside` your Codespace

```bash

# check the key services
kic check all

## todo - check webv error

```

## View the services in your browser

- Click on the `PORTS` tab in the CLI window
  - Open `App(30080)` in browser
    - Right click or click the `open in browser` icon
    - Test the swagger
- todo - add url file

## Prometheus Dashboard

- Custom Prometheus metrics are included in the template
- From the `PORTS` tab, open `Prometheus (30000)`
  - From the query window, enter `myapp`
    - This will filter to your custom app metrics
  - From the query window, enter `webv`
    - This will filter to the WebValidate metrics

## Run Automated Tests

```bash

# run a load test in the background
kic test load &

# run an integration test (or two or five)
kic test integration

```

## Grafana Dashboard

- Basic Grafana dashboards are included in the app template
- From the `PORTS` tab, open `Grafana (32000)`
  - Login
    - admin
    - cse-labs
  - Click on `General / Home` at the top of the screen
    - Select `Application Dashboard`
    - Notice the spike from the load test and the errors (by design) from the integration test
    - Load and Integration tests also run as part of `kic new`
  - Click on `General / Application Dashboard` at the top of the screen
    - Select `dotnet Dashboard`

## Reset your K8s Cluster

- After you're done experimenting

```bash

kic cluster create

```

## Remove MyApp

```bash

cd "$REPO_BASE"
rm -rf myapp
