# DevOps Take-Home Assignment

You're provided with an app which will serve a single HTTP endpoint `/quotes` - returning a list of quotes.
You're tasked with implementing the infrastructure as code where the HTTP application will be served and a CI/CD pipeline for deploying new changes to it.

## Requirements

- The infrastructure should include at least one HTTP webserver and one PostgreSQL database. **All the infrastructure needed by the application should be coded in terraform.**
  - All webserver instance(s) should connect to the same DB.
  - **You don't need to provision resources.** You only need to provide the full output of the `terraform plan` command and the corresponding code.
  - The webserver(s) serving HTTP requests should be hosted on **Ubuntu Linux Virtual Machines and not in a managed service.** For the rest of the infrastructure **you can use any managed service you want** (Database, Load balancer etc.) or host things in Ubuntu VMs.
  - You can use the builtin django development server to serve the application - `python manage.py runserver`. You don't need to support HTTPS.
  - You can use resources from any cloud provider. If you wish to make DNS record changes you can do so using the reserved `example.com` domain.
- You should containerize the django application.
- The CI/CD Pipeline should deploy a version of the app **with minimal downtime to the clients.**
  - You don't need to implement any trigger for the CI/CD pipeline (e.g. when a commit is merged). You only need to deliver the pipeline code that can be run manually by you from a shell or in your chosen CI/CD tool.
  - You can code the Pipeline using any tool or platform you prefer.
- When developing the solution you should value simplicity, ease of reproducing the infrastructure and server configuration, and the scalability of the infrastructure and CI/CD code if in the future we need to scale the infrastructure vertically or horizontally to support more requests.
- You should include a short description of how your solution works, instructions on how to setup the infrastructure and CI/CD pipeline and any assumptions made during implementation that you think are relevant.

## Web Application

In the `app/` folder there is a django web application that implements:

- `/health` endpoint which returns an HTTP 200 status or a 500 status code, indicating the app's health status.
- `/quotes` endpoint that returns a list of quotes.

You can change the functionality of the `/health` endpoint.

**The application needs these environment variables to connect to a PostgreSQL Database** where the quotes are saved:

``` bash
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASSWORD=postgres
DB_NAME=postgres
```

You should supply these yourself to the app with the details of the DB provisioned by your terraform code.

### Run Instructions

These instructions assume you have pip and python 3.9+ installed and that are running Ubuntu 24.04.

1. `apt-get install -y libpq-dev python3-dev build-essential`
2. `cd app/`
3. `pip install -r requirements.txt`
4. `python manage.py migrate`
5. `python manage.py runserver`

## Submitting your solution

1. Create a branch named `solution` and push your changes to the branch.
2. Open a Pull Request in Github.

The PR should include the terraform code, configuration code, CI/CD code and any other code necessary to reproduce the entire system and pipeline.
