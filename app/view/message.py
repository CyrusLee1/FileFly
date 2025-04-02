from flask import Blueprint

bp = Blueprint('message', __name__, url_prefix='/message')

@bp.route("/")
def index():
    return "index"

@bp.route("/all")
def all():
    return "all"
