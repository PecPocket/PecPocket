
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
    name = db.Column(db.String(100), )
    email = db.Column(db.String(100), )

    def __init__(self, SID, name, email):
        self.name = name
        self.SID = SID
        self.email = email
    
# Super Schema
class SuperSchema(ma.Schema):
    class Meta:
        fields = ("SID", "name", "email")


# Sign Up Table
class SignUp(db.Model):
    SID = db.Column(db.Integer, primary_key=True)
    password = db.Column(db.String(50), nullable=False)

    def __init__(self, SID, password):
        self.SID = SID
        self.password = password

class SignUpSchema(ma.Schema):
    class Meta:
        fields = ("SID", "password")


# Auth Table
class Auth(db.Model):
    SID = db.Column(db.Integer, primary_key=True)
    auth = db.Column(db.Integer, nullable=False)

    def __init__(self, SID, auth):
        self.SID = SID
        self.auth = auth

class AuthSchema(ma.Schema):
    class Meta:
        model = Auth


# Init Schema
super_schema = SuperSchema()
supers_schema = SuperSchema(many=True)

signup_schema = SignUpSchema()
signups_schema = SignUpSchema(many=True)

auth_schema = AuthSchema()

# Create a Super Row
@app.route('/super', methods=['POST'])
def add_super():
    SID = request.json['SID']
    name = request.json['name']
    email = request.json['email']

    new_super = Super(SID, name, email)

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
    name = request.json['name']
    email = request.json['email']

    single_super.SID = SID
    single_super.name = name
    single_super.email = email 

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
            # go ahead for password, valid user--> hasn't signed up
            return jsonify({'code':200})
        
# adding signup info to the table
@app.route('/signup', methods=['POST'])
def sign_up():
    SID = request.json['SID']
    password = request.json['password']

    # checking if already in sign up before proceeding
    sid_in_signup = SignUp.query.get(SID)
    if sid_in_signup:
        # already igned up 
        return jsonify({'code':402})

    hashed_pwd = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
    new_signup = SignUp(SID, hashed_pwd)

    db.session.add(new_signup)
    db.session.commit()

    auth_info = Auth.query.get(SID)
    if not auth_info:
        # normal user --> no secy or CR
        return jsonify({"code": 200, "auth": 0})

    
    else :
        # either a secy or a CR
        output = json.dumps(auth_info.auth)
        return jsonify({"code": 200, "auth": int(output)})

# GET All SignUp
@app.route('/signup', methods=['GET'])
def get_signups():
    all_signups = SignUp.query.all()
    result = signups_schema.dump(all_signups)
    return jsonify(result)


# change/update password
@app.route('/signup/<SID>', methods=['PUT'])
def update_password(SID):
    signup_info = SignUp.query.get(SID)

    SID = request.json['SID']
    password = request.json['password'] # new password

    # check if it exists in sign up table
    if not signup_info:
        # has not signed up yet
        return jsonify({'code':403})
    else:
        # check if new password is same as the old one
        if bcrypt.checkpw(password.encode('utf-8'), signup_info.password):
            # new password == old password 
            return jsonify({'code':301})
        else :
            # all good to update the password 
            hashed_pwd = bcrypt.hashpw(password.encode('utf-8'), bcrypt.gensalt())
            signup_info.SID = SID
            signup_info.password = hashed_pwd

            db.session.commit()

            return jsonify({'code' : 200})

# login
@app.route('/login', methods=['POST'])
def login():
    SID = request.json['SID']
    password = request.json['password']

    signup_info = SignUp.query.get(SID)

    if not signup_info:
        # not signed up
        return jsonify({'code':403})

    else :
        if bcrypt.checkpw(password.encode('utf-8'), signup_info.password):
            # correct sid and password
            auth_info = Auth.query.get(SID)
            if not auth_info:
                # normal user --> no secy or CR
                return jsonify({'code': 200, 'auth': 0})
            
            else :
                # either a secy or a CR
                output = json.dumps(auth_info.auth)
                return jsonify({'code': 200, 'auth': int(output)})
        else : 
            # correct sid, wrong password
            return jsonify({'code':404})

# delete from signup 
@app.route('/signup/<SID>', methods=['DELETE'])
def delete_signup(SID):
    signup_info = SignUp.query.get(SID)

    # check if the user exists in sign up 
    if not signup_info:
        # has not signed up yet
        return jsonify({'code':403})

    # ask for password for extra confirmation --> maybe

    db.session.delete(signup_info)
    db.session.commit()

    return jsonify({'code':200})

# Auth Table Management

# Enter data into Auth Table
@app.route('/auth', methods=['POST'])
def add_auth():
    SID = request.json['SID']
    auth = request.json['auth']

    # check if already exists in auth
    sid_in_auth = Auth.query.get(SID)
    if sid_in_auth:
        # authorization already granted
        return jsonify({'code':405})

    new_auth = Auth(SID, auth)

    db.session.add(new_auth)
    db.session.commit()

    return jsonify({'code':200})

# Update Auth
@app.route('/auth/<SID>', methods=['PUT'])
def update_auth(SID):
    auth_info = Auth.query.get(SID)

    SID = request.json['SID']
    auth = request.json['auth'] # new auth

    # check if auth already exists
    if not auth_info:
        # no authorization granted --> can't update
        return jsonify({'code': 406})

    auth_info.SID = SID
    auth_info.password = auth

    # check if auth is changed to 0 
    if auth == 0 :
        # then remove from db
        db.session.delete(auth_info)
        db.session.commit()
        return jsonify({'code':200})


    db.session.commit()

    return jsonify({'code':200})


# deleter from auth table
@app.route('/auth/<SID>', methods=['DELETE'])
def delete_auth(SID):
    auth_info = Auth.query.get(SID)

    # check if it even exists in auth 
    if not auth_info:
        # no authorization granted
        return jsonify({'code':406})

    db.session.delete(auth_info)
    db.session.commit()
    return jsonify({'code':200})



# Run server
if __name__ == '__main__':
    app.run(debug=True)




# STATUS CODES
# 200 --> OK
# 301 --> same password == old password
# 401 --> SID does not exist
# 402 --> already signed up
# 403 --> not signed up
# 404 --> correct sid, wrong password 
# 405 --> authorization already granted
# 406 --> no authorization granted 

# AUTH CODES
# 0 --> Normal User
# 1 --> CR
# 2 --> Secy of some club/society


# ERROR HANDLING
# 1. adding to sign up, check if already exists in sign up
# 2. to change update password, first check if it even exists in the sign up, and if yes, first check if the old password is the same as in sign up or not
# 3. to delete from sign up, check if it even exists in sign up, and also ask for password when deleting(not sure about that one)
# 4. to add in auth, check if already exists in auth
# 5. to update auth, first check if it even exists in auth, and if changed to 0, then delete from auth table
# 6. to delete auth, first check if it even exists in auth table

# THE ONE BELOW WILL BE USED

# user enters sid
# kauts sends sid to api '/signup/<SID>', GET
# we check if sid exists in super table, if yes, then check if sid is there in the sign up table
# if not, send kauts 200 message, ok 

# if does not exist in super return 401, "does not exist"
# if exists in super but also exists in sign up , send 402, "already exists"

# he'll let them make a password
# kauts will send us a POST request on /signup/<SID> with a body with the sid and password
# when saving into the signup table, we hash the password


