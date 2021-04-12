#pylint: disable-all

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow

db = SQLAlchemy()
ma = Marshmallow()

def initialize_db(app):
    db.init_app(app)
    ma.init_app(app)
    with app.app_context():
        db.create_all()
    