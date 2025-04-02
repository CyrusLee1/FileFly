
from .file import bp as file_bp
from .index import bp as index_bp
from .message import bp as message_bp


def init_bps(app):
    app.register_blueprint(file_bp)
    app.register_blueprint(index_bp)
    app.register_blueprint(message_bp)
    