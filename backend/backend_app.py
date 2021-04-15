#pylint: disable-all

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from database.extensions import initialize_db
# import flask_whooshalchemy 
import os
from resources.super_routes import superblue
from resources.signup_routes import signblue
from resources.auth_routes import authblue
# from resources.subject_routes import subjectblue
from resources.club_routes import clubblue
from resources.sub_conv_routes import sub_convblue
from resources.club_conv_routes import club_convblue
# from resources.back_elect_routes import back_electblue 
from resources.personal_routes import personalblue
from resources.delete_account import deleteblue
from resources.signup_clubs import signupclubsblue
from resources.same_class import sameyearblue
from database.models import SubConvertor

app = Flask(__name__)

basedir = os.path.abspath(os.path.dirname(__file__))

# Database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'database/db.sqlite')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True
# app.config['WHOOSH_BASE'] = 'whoosh'

initialize_db(app)

# flask_whooshalchemy.whoosh_index(app, SubConvertor)


app.register_blueprint(superblue)
app.register_blueprint(signblue)
app.register_blueprint(authblue)
# app.register_blueprint(subjectblue)
app.register_blueprint(clubblue)
app.register_blueprint(sub_convblue)
app.register_blueprint(club_convblue)
# app.register_blueprint(back_electblue)
app.register_blueprint(personalblue)
app.register_blueprint(deleteblue)
app.register_blueprint(signupclubsblue)
app.register_blueprint(sameyearblue)

app.run(debug=True)

