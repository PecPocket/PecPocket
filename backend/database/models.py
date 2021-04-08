#pylint: disable-all

from .extensions import db, ma
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow


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

# # Sign Up Table
class SignUp(db.Model):
    SID = db.Column(db.Integer, primary_key=True)
    Password = db.Column(db.String(50), nullable=False)

    def __init__(self, SID, Password):
        self.SID = SID
        self.Password = Password

class SignUpSchema(ma.Schema):
    class Meta:
        fields = ("SID", "Password")

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

class Personal(db.Model):
    SID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String(100), nullable=False)
    Branch = db.Column(db.String(25), nullable=False)
    Year = db.Column(db.Integer, nullable=False)
    Semester = db.Column(db.Integer, nullable=False)

    def __init__(self, SID, Name, Branch, Year, Semester):
        self.SID = SID
        self.Name = Name
        self.Branch = Branch
        self.Year = Year
        self.Semester = Semester

class PersonalSchema(ma.Schema):
    class Meta:
        fields = ("SID", "Name", "Branch", "Year", "Semester")



# Subject Table
class Subject(db.Model):
    Branch = db.Column(db.String(25), primary_key = True)
    Semester = db.Column(db.Integer, primary_key = True)
    Sub_codes = db.Column(db.String(100), nullable = False)
    Elect_codes = db.Column(db.String(100))

    def __init__(self, Branch, Semester, Sub_codes, Elect_codes):
        self.Branch = Branch
        self.Semester = Semester
        self.Sub_codes = Sub_codes
        self.Elect_codes = Elect_codes
    
class SubjectSchema(ma.Schema):
    class Meta:
        fields = ("Branch", "Semester", "Sub_codes", "Elect_codes")



# Init Schema
super_schema = SuperSchema()
supers_schema = SuperSchema(many=True)

signup_schema = SignUpSchema()
signups_schema = SignUpSchema(many=True)

auth_schema = AuthSchema()

personal_schema = PersonalSchema()
personals_schema = PersonalSchema(many=True)

subject_schema = SubjectSchema()
subjects_schema = SubjectSchema(many=True)

        

