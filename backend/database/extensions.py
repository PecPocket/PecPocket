#pylint: disable-all

from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

db = SQLAlchemy()
ma = Marshmallow()

def initialize_db(app):
    db.init_app(app)
    ma.init_app(app)
    