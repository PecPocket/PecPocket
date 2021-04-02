
# pylint: disable=no-member

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
import os
import bcrypt
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
    
#Personal Table
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

#Subject Table
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

Auth_schema = AuthSchema()

personal_schema = PersonalSchema()
personals_schema = PersonalSchema(many=True)

subject_schema = SubjectSchema()
subjects_schema = SubjectSchema(many=True)

# Create a Super Row
@app.route('/super', methods=['POST'])
def add_super():
    SID = request.json['SID']
    Name = request.json['Name']
    Email = request.json['Email']

    new_super = Super(SID, Name, Email)

    db.session.add(new_super)
    db.session.commit()

    # returns the created json 
    return super_schema.jsonify(new_super)

# GET All Super
@app.route('/super', methods=['GET'])
def get_supers():
    all_supers = Super.query.all()
    result = supers_schema.dump(all_supers)
    return jsonify(result)

# GET Single Super
@app.route('/super/<SID>', methods=['GET'])
def get_super(SID):
    single_super = Super.query.get(SID)
    result = super_schema.dump(single_super)
    return jsonify(result)

# Update a Super Row
@app.route('/super/<SID>', methods=['PUT'])
def update_super(SID):
    single_super = Super.query.get(SID)

    SID = request.json['SID']
    Name = request.json['Name']
    Email = request.json['Email']

    single_super.SID = SID
    single_super.Name = Name
    single_super.Email = Email 

    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})

# Delete Super
@app.route('/super/<SID>', methods=['DELETE'])
def delete_super(SID):
    single_super = Super.query.get(SID)
    db.session.delete(single_super)
    db.session.commit()
    return jsonify({'code':200})

# Sign up routes

# Getting data from super
@app.route('/signup/<SID>', methods=['GET'])
def check_SID(SID):
    sid_in_super = Super.query.get(SID)
    # print(sid_in_super)

    if not sid_in_super:
        # does not exists in database
        return jsonify({'code':401})

    if sid_in_super:
        sid_in_signup = SignUp.query.get(SID)
        # print(sid_in_signup)
        if sid_in_signup:
            # already signed up
            return jsonify({'code':402})

        if not sid_in_signup:
            # go ahead for Password, valid user--> hasn't signed up
            return jsonify({'code':200})
        
# adding signup info to the table
@app.route('/signup', methods=['POST'])
def sign_up():
    SID = request.json['SID']
    Password = request.json['Password']

    # checking if already in sign up before proceeding
    sid_in_signup = SignUp.query.get(SID)
    if sid_in_signup:
        # already igned up 
        return jsonify({'code':402})

    hashed_pwd = bcrypt.hashpw(Password.encode('utf-8'), bcrypt.gensalt())
    new_signup = SignUp(SID, hashed_pwd)

    db.session.add(new_signup)
    db.session.commit()

    Auth_info = Auth.query.get(SID)
    if not Auth_info:
        # normal user --> no secy or CR
        return jsonify({"code": 200, "Auth": 0})

    
    else :
        # either a secy or a CR
        output = json.dumps(Auth_info.Auth)
        return jsonify({"code": 200, "Auth": int(output)})

# GET All SignUp
@app.route('/signup', methods=['GET'])
def get_signups():
    all_signups = SignUp.query.all()
    result = signups_schema.dump(all_signups)
    return jsonify(result)


# change/update Password
@app.route('/signup/<SID>', methods=['PUT'])
def update_Password(SID):
    signup_info = SignUp.query.get(SID)

    SID = request.json['SID']
    Password = request.json['Password'] # new Password

    # check if it exists in sign up table
    if not signup_info:
        # has not signed up yet
        return jsonify({'code':403})
    else:
        # check if new Password is same as the old one
        if bcrypt.checkpw(Password.encode('utf-8'), signup_info.Password):
            # new Password == old Password 
            return jsonify({'code':301})
        else :
            # all good to update the Password 
            hashed_pwd = bcrypt.hashpw(Password.encode('utf-8'), bcrypt.gensalt())
            signup_info.SID = SID
            signup_info.Password = hashed_pwd

            db.session.commit()

            return jsonify({'code' : 200})

# login
@app.route('/login', methods=['POST'])
def login():
    SID = request.json['SID']
    Password = request.json['Password']

    signup_info = SignUp.query.get(SID)

    if not signup_info:
        # not signed up
        return jsonify({'code':403})

    else :
        if bcrypt.checkpw(Password.encode('utf-8'), signup_info.Password):
            # correct sid and Password
            Auth_info = Auth.query.get(SID)
            if not Auth_info:
                # normal user --> no secy or CR
                return jsonify({'code': 200, 'Auth': 0})
            
            else :
                # either a secy or a CR
                output = json.dumps(Auth_info.Auth)
                return jsonify({'code': 200, 'Auth': int(output)})
        else : 
            # correct sid, wrong Password
            return jsonify({'code':404})

# delete from signup 
@app.route('/signup/<SID>', methods=['DELETE'])
def delete_signup(SID):
    signup_info = SignUp.query.get(SID)

    # check if the user exists in sign up 
    if not signup_info:
        # has not signed up yet
        return jsonify({'code':403})

    # ask for Password for extra confirmation --> maybe

    db.session.delete(signup_info)
    db.session.commit()

    return jsonify({'code':200})

# Auth Table Management

# Enter data into Auth Table
@app.route('/Auth', methods=['POST'])
def add_Auth():
    SID = request.json['SID']
    Auth = request.json['Auth']

    # check if already exists in Auth
    sid_in_Auth = Auth.query.get(SID)
    if sid_in_Auth:
        # Authorization already granted
        return jsonify({'code':405})

    new_Auth = Auth(SID, Auth)

    db.session.add(new_Auth)
    db.session.commit()

    return jsonify({'code':200})

# Update Auth
@app.route('/Auth/<SID>', methods=['PUT'])
def update_Auth(SID):
    Auth_info = Auth.query.get(SID)

    SID = request.json['SID']
    auth = request.json['Auth'] # new Auth

    # check if Auth already exists
    if not Auth_info:
        # no Authorization granted --> can't update
        return jsonify({'code': 406})

    Auth_info.SID = SID
    Auth_info.Password = auth

    # check if Auth is changed to 0 
    if Auth == 0 :
        # then remove from db
        db.session.delete(Auth_info)
        db.session.commit()
        return jsonify({'code':200})


    db.session.commit()

    return jsonify({'code':200})


# deleter from Auth table
@app.route('/Auth/<SID>', methods=['DELETE'])
def delete_Auth(SID):
    Auth_info = Auth.query.get(SID)

    # check if it even exists in Auth 
    if not Auth_info:
        # no Authorization granted
        return jsonify({'code':406})

    db.session.delete(Auth_info)
    db.session.commit()
    return jsonify({'code':200})



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


