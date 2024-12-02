import os

from dotenv import load_dotenv

root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

if os.getenv("ENV", "") == "test":
    load_dotenv(f"{root_dir}/.env.test")
else:
    load_dotenv()
