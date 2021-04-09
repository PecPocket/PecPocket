#pylint: disable-all

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from database.extensions import initialize_db
import os
from resources.super_routes import superblue
from resources.signup_routes import signblue
from resources.auth_routes import authblue
from resources.subject_routes import subjectblue
from resources.club_routes import clubblue

app = Flask(__name__)

basedir = os.path.abspath(os.path.dirname(__file__))

# Database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'database/db.sqlite')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

initialize_db(app)
app.register_blueprint(superblue)
app.register_blueprint(signblue)
app.register_blueprint(authblue)
app.register_blueprint(subjectblue)
app.register_blueprint(clubblue)

app.run()