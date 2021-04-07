
# pylint: disable=no-member

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
import os
import json


# Init app
app = Flask(__name__)
basedir = os.path.abspath(os.path.dirname(__file__))

# Database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'database/db.sqlite')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Init Database
db = SQLAlchemy(app)

# Init Marshmallow
ma = Marshmallow(app)

import super_routes, auth_routes
#import signup_routes

# Super Table
class Super(db.Model):
    SID = db.Column(db.Integer, primary_key = True)
    Name = db.Column(db.String(100),nullable=False )
    Email = db.Column(db.String(100),nullable=False )

    def __init__(self, SID, Name, Email):
        self.Name = Name
        self.SID = SID
        self.Email = Email
    
class SuperSchema(ma.Schema):
    class Meta:
        fields = ("SID", "Name", "Email")

# Auth Table
class Auth(db.Model):
    SID = db.Column(db.Integer, primary_key=True)
    Auth = db.Column(db.Integer, nullable=False)

    def __init__(self, SID, Auth):
        self.SID = SID
        self.Auth = Auth

class AuthSchema(ma.Schema):
    class Meta:
        model = Auth


# # Personal Table
# class Personal(db.Model):
#     SID = db.Column(db.Integer, primary_key=True)
#     Name = db.Column(db.String(100), nullable=False)
#     Branch = db.Column(db.String(25), nullable=False)
#     Year = db.Column(db.Integer, nullable=False)
#     Semester = db.Column(db.Integer, nullable=False)

#     def __init__(self, SID, Name, Branch, Year, Semester):
#         self.SID = SID
#         self.Name = Name
#         self.Branch = Branch
#         self.Year = Year
#         self.Semester = Semester

# class PersonalSchema(ma.Schema):
#     class Meta:
#         fields = ("SID", "Name", "Branch", "Year", "Semester")



# # Subject Table
# class Subject(db.Model):
#     Branch = db.Column(db.String(25), primary_key = True)
#     Semester = db.Column(db.Integer, primary_key = True)
#     Sub_codes = db.Column(db.String(100), nullable = False)
#     Elect_codes = db.Column(db.String(100))

#     def __init__(self, Branch, Semester, Sub_codes, Elect_codes):
#         self.Branch = Branch
#         self.Semester = Semester
#         self.Sub_codes = Sub_codes
#         self.Elect_codes = Elect_codes
    
# class SubjectSchema(ma.Schema):
#     class Meta:
#         fields = ("Branch", "Semester", "Sub_codes", "Elect_codes")



# # # Init Schema

# personal_schema = PersonalSchema()
# personals_schema = PersonalSchema(many=True)

# subject_schema = SubjectSchema()
# subjects_schema = SubjectSchema(many=True)



# Run server
if __name__ == '__main__':
    app.run(debug=True)




# STATUS CODES
# 200 --> OK
# 301 --> same Password == old Password
# 401 --> SID does not exist
# 402 --> already signed up
# 403 --> not signed up
# 404 --> correct sid, wrong Password 
# 405 --> Authorization already granted
# 406 --> no Authorization granted 

# Auth CODES
# 0 --> Normal User
# 1 --> CR
# 2 --> Secy of some club/society


# ERROR HANDLING
# 1. adding to sign up, check if already exists in sign up
# 2. to change update Password, first check if it even exists in the sign up, and if yes, first check if the old Password is the same as in sign up or not
# 3. to delete from sign up, check if it even exists in sign up, and also ask for Password when deleting(not sure about that one)
# 4. to add in Auth, check if already exists in Auth
# 5. to update Auth, first check if it even exists in Auth, and if changed to 0, then delete from Auth table
# 6. to delete Auth, first check if it even exists in Auth table

# THE ONE BELOW WILL BE USED

# user enters sid
# kauts sends sid to api '/signup/<SID>', GET
# we check if sid exists in super table, if yes, then check if sid is there in the sign up table
# if not, send kauts 200 message, ok 

# if does not exist in super return 401, "does not exist"
# if exists in super but also exists in sign up , send 402, "already exists"

# he'll let them make a Password
# kauts will send us a POST request on /signup/<SID> with a body with the sid and Password
# when saving into the signup table, we hash the Password


