#pylint: disable-all

from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from database.models import db_initialiser
import os
from resources.super_routes import superblue
from resources.signup_routes import signblue
from resources.auth_routes import authblue
from resources.club_routes import clubblue
from resources.sub_conv_routes import sub_convblue
from resources.club_conv_routes import club_convblue
from resources.personal_routes import personalblue, update_credentials
from resources.delete_account import deleteblue
from resources.fetch_student_list import stulistblue
from resources.pec_social_route import pecsocialblue
from resources.search_routes import searchblue
from resources.study_material_routes import studyblue, config
from resources.noti_routes import notiblue
from datetime import datetime



app = Flask(__name__)

basedir = os.path.abspath(os.path.dirname(__file__))

# Database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'database/db.sqlite')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = True


db_initialiser(app)
config(app)

present_time = datetime.now()
current_month = present_time.month
current_date = present_time.date

if current_month == 7 or current_month == 12 :
    if current_date > 15:
        update_credentials()


app.register_blueprint(superblue)
app.register_blueprint(signblue)
app.register_blueprint(authblue)
app.register_blueprint(clubblue)
app.register_blueprint(sub_convblue)
app.register_blueprint(club_convblue)
app.register_blueprint(personalblue)
app.register_blueprint(deleteblue)
app.register_blueprint(stulistblue)
app.register_blueprint(pecsocialblue)
app.register_blueprint(searchblue)
app.register_blueprint(studyblue)
app.register_blueprint(notiblue)

app.run(debug=True)

