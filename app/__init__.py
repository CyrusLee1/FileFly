import os
from flask import Flask
from app.config import Config
from app.view import init_bps

def create_app(config_class=Config):
    app = Flask(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
    app.config.from_object(config_class)

    # 注册蓝图
    init_bps(app)

    return app