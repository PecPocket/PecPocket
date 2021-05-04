#pylint: disable-all

# from .extensions import db, ma
from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
from sqlalchemy.orm import backref

db = SQLAlchemy()
ma = Marshmallow()



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

# Sign Up Table
class SignUp(db.Model):
    SID = db.Column(db.Integer, primary_key=True)
    Password = db.Column(db.String(50), nullable=False)

    def __init__(self, SID, Password):
        self.SID = SID
        self.Password = Password

class SignUpSchema(ma.Schema):
    class Meta:
        fields = ("SID", "Password")


# Authorization Table
class Authorization(db.Model):
    SID = db.Column(db.Integer, primary_key=True)
    Auth = db.Column(db.Integer, nullable=False)
    Domain = db.Column(db.String(50), nullable=False)

    def __init__(self, SID, Auth, Domain):
        self.SID = SID
        self.Auth = Auth
        self.Domain = Domain

class AuthorizationSchema(ma.Schema):
    class Meta:
        fields = ("SID", "Auth", "Domain")


# Sub convertor
class SubConvertor(db.Model):
    # __searchable__ = ['Sub_code', 'Subject']
    Sub_code = db.Column(db.String(100), primary_key=True, nullable=False)
    Subject = db.Column(db.String(50), nullable=False)

    def __init__(self, Sub_code, Subject):
        self.Sub_code = Sub_code
        self.Subject = Subject

class SubConvertorSchema(ma.Schema):
    class Meta:
        fields = ("Sub_code", "Subject")


class Personal(db.Model):
    SID = db.Column(db.Integer, primary_key=True)
    Name = db.Column(db.String(100), nullable=False)
    Branch = db.Column(db.String(25), nullable=False)
    Year = db.Column(db.Integer, nullable=False)
    Semester = db.Column(db.Integer, nullable=False)
    Club_codes = db.Column(db.String(50))
    Insta = db.Column(db.String(50))
    Avatar = db.Column(db.String(100))

    def __init__(self, SID, Name, Branch, Year, Semester, Club_codes, Insta, Avatar):
        self.SID = SID
        self.Name = Name
        self.Branch = Branch
        self.Year = Year
        self.Semester = Semester
        self.Club_codes = Club_codes
        self.Insta = Insta
        self.Avatar = Avatar

class PersonalSchema(ma.Schema):
    class Meta:
        fields = ("SID", "Name", "Branch", "Year", "Semester", "Club_codes", "Insta", "Avatar")


# Club convertor
class ClubConvertor(db.Model):
    Club_code = db.Column(db.String(100), primary_key=True)
    Club = db.Column(db.String(50), nullable=False)

    def __init__(self, Club_code, Club):
        self.Club_code = Club_code
        self.Club = Club

class ClubConvertorSchema(ma.Schema):
    class Meta:
        fields = ("Club_code", "Club")


# Notifications 
class Notifications(db.Model):
    Noti_id = db.Column(db.Integer, primary_key=True)
    Topic = db.Column(db.String(50), nullable=False)
    Description = db.Column(db.Text)
    Date = db.Column(db.Date)
    Time = db.Column(db.Time)
    Students = db.relationship('StudentNoti',  cascade = "all,delete", backref = backref('Noti_content'))

    def __init__(self, Noti_id, Topic, Description, Date, Time):
        self.Noti_id = Noti_id
        self.Topic = Topic
        self.Description = Description
        self.Date = Date
        self.Time = Time

class NotificationsSchema(ma.Schema):
    class Meta:
        fields = ("Noti_id", "Topic", "Description", "Date", "Time")


# Student Notifications
class StudentNoti(db.Model):
    SID = db.Column(db.Integer, primary_key=True)
    Noti_id = db.Column(db.Integer, db.ForeignKey('notifications.Noti_id'), primary_key=True, nullable=False)

    def __init__(self, SID, Noti_id):
        self.SID = SID
        self.Noti_id = Noti_id

class StudentNotiSchema(ma.Schema):
    class Meta:
        fields = ("SID", "Noti_id")


# Init Schema
super_schema = SuperSchema()
supers_schema = SuperSchema(many=True)

signup_schema = SignUpSchema()
signups_schema = SignUpSchema(many=True)

authorization_schema = AuthorizationSchema()

personal_schema = PersonalSchema()
personals_schema = PersonalSchema(many=True)
        
sub_convertor_schema = SubConvertorSchema()
sub_convertors_schema = SubConvertorSchema(many=True)

club_convertor_schema = ClubConvertorSchema()
club_convertors_schema = ClubConvertorSchema(many=True)

noti_schema = NotificationsSchema()
notis_schema = NotificationsSchema(many=True)

studentnoti_schema = StudentNotiSchema()
studentnotis_schema = StudentNotiSchema(many=True)


def db_initialiser(app):
    db.init_app(app)
    ma.init_app(app)
    with app.app_context():
        #pass
        # db.drop_all()
        db.create_all()
        #pass

        



