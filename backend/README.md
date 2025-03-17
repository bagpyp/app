# Python Starter Project

This project is a minimal FastAPI template designed to help you quickly bootstrap a new Python project with Docker, automated database migrations, and a robust testing setup. It uses Poetry for dependency management and `python-dotenv` for environment configuration.

---

## Features

- **Dockerized Database Services**: Spin up Postgres containers for development and testing using Docker Compose.
  - **Development Database (`db`)**:
    - Runs on port **5432**
    - Uses the environment variables (`POSTGRES_DB`, `POSTGRES_USER`, `POSTGRES_PASSWORD`)
    - Persists data in the Docker volume `data`
  - **Test Database (`db-test`)**:
    - Runs on port **5431** (mapped to container’s port 5432)
    - Uses the same credentials but is isolated via the Docker volume `test_data`
- **Dependency Management**: Uses [Poetry](https://python-poetry.org/) for managing project dependencies and packaging.
- **Environment Configuration**: Loads settings from `.env` and `.env.test` using [python-dotenv](https://github.com/theskumar/python-dotenv).
- **Automatic Database Migrations**: Integrates [Alembic](https://alembic.sqlalchemy.org/) to manage and run migrations automatically on app startup.
- **FastAPI Starter App**: A simple FastAPI application that exposes a `/health` endpoint to verify the application and database connection.
- **Testing Setup**: Uses [pytest](https://pytest.org/) with fixtures that override the database connection, ensuring tests run on an isolated test database.

---

## Project Structure

```plaintext
app/
├── src/
│   ├── config.py             # Loads environment variables and constructs the DB URL
│   ├── main.py               # FastAPI application entry point (includes migration run on startup)
│   ├── api/
│   │   └── main.py           # API router with the /health endpoint
│   ├── data/
│   │   ├── main.py           # Database session management and connection helpers
│   │   ├── models.py         # SQLAlchemy models (e.g., User)
│   │   └── alembic/          # Alembic migration scripts directory
├── .env                      # Environment variables for development
├── .env.test                 # Environment variables for testing
├── docker-compose.yml        # Docker Compose file for spinning up Postgres services
├── pyproject.toml            # Poetry configuration
├── README.md                 # This file
├── test/
│   ├── conftest.py           # Test fixtures overriding DB connections
│   └── test_config.py        # Sample test for the environment setup endpoint
```

---

## Prerequisites

- **Homebrew, Python & Poetry**: These are handled during setup in [the root level README](../docs/README.md)
- **Docker & Docker Compose**: Required to run the Postgres services that the application relies on
  ```shell
  brew install --cask docker
  ```
  To start the database server, make sure your Docker engine is running, then run:
  ```bash
  docker-compose up -d
  ```
  🚨 If you're using PyCharm, run this using the preloaded configuration, `db` 
---

## Running the Application

1. **Install Dependencies**

   Use Poetry to install the project dependencies (must be in .venv to use some features of this template)

   ```bash
   poetry config virtualenvs.in-project true && poetry install
   ```
    
   This will create a virtual environment with its own isolated python interpreter.  Regardless of what IDE you're using, you must set your python interpreter to the one that was just created.  It should be in `.venv/bin/python`, but to be certain you have the correct absolute path, copy it to your clipboard with the following command:

   ```bash
   poetry env info --executable |pbcopy
   ```

3. **Start the Application**

   Activate the Poetry shell and run the app:

   ```bash
   poetry run python src/main.py
   ```
   🚨 If you're using PyCharm, run this using the preloaded configuration, `backend`

---

## Running Tests

The project uses `pytest` to run tests with an isolated test database. To execute the tests, run:

```bash
poetry run pytest
```
🚨 If you're using PyCharm, run this using the preloaded configuration, `pytest` 


During testing:
- The `conftest.py` file overrides the database dependency so that tests use the test database (configured via `.env.test`).
- The test database schema is dropped and recreated for each test function, ensuring test isolation.

---

## How Migrations Work

Database migrations are managed with Alembic:

- **Configuration**:  
  The `alembic.ini` file (in the project root) points to the migration scripts in `src/data/alembic`.

- **Migration Scripts**:  
  The migration scripts (like `2025_03_15_1049-f5301436a15e_initial.py`) define schema changes such as creating tables and indexes. For example, the initial migration creates a `user` table with indexes on `id`, `name`, and `email`.

- **Automatic Execution on Startup**:  
  When the FastAPI app starts, it runs a lifespan event that executes:
  
  ```python
  command.upgrade(alembic_cfg, "head")
  ```
  
  This command applies all pending migrations to ensure the database schema is up to date.

- **Creating New Migrations**:  
  Whenever changes to your ORM classes require changes to the underlying databse, alembic will generate the scripts for making those changes (and reverting them), the scripts themselves are what we're referring to as _a migration_.
  To generate a new migration _after modifying your SQLAlchemy models_, use:
  
  ```bash
  alembic revision --autogenerate -m "your migration message"
  ```
  
  Then, either restart the app (which will run the migrations automatically) or manually run:
  
  ```bash
  alembic upgrade head
  ```

---

## Customizing the Starter App

- **Extend Your Application**:  
  Modify `src/api/main.py` and `src/main.py` to add your application logic and additional endpoints.
- **Add New Dependencies**:  
  Use `poetry add <package>` to include new libraries.
- **Code Formatting**:  
  The PyCharm settings to format-on-save with Black are saved in version control
  If you're using VS Code, run Black to format your code:
  
  ```bash
  poetry run black src/
  ```

---

## Author

Created by Bagpyp  
[Email Me](mailto:rtc@bagpyp.net)

---

## License

This project is open source. Add a license as needed.
