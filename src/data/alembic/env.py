from alembic import context
from sqlalchemy import engine_from_config
from sqlalchemy import pool

from src.config import DB_URL
from src.data.models import Base

config = context.config

config.set_main_option("sqlalchemy.url", DB_URL)
target_metadata = Base.metadata


def run_migrations() -> None:
    connectable = engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)

        with context.begin_transaction():
            context.run_migrations()


run_migrations()
