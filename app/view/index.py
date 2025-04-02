from flask import Blueprint, render_template

bp = Blueprint('index', __name__, url_prefix='/')

# 首页
@bp.get('/')
def index():
    return render_template('index.html')
