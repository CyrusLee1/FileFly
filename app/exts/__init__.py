from flask import Flask
from .init_sqlalchemy import init_database, db

def init_exts(app: Flask):
    init_database(app)
