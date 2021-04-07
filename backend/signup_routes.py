# # pylint: disable=no-member
# from flask import Flask, request, jsonify
# from __main__ import app
# from main_backend import db
# from super_routes import Super
# from auth_routes import Auth
# import bcrypt
# import json
# from flask_marshmallow import Marshmallow

# # Init Marshmallow
# ma = Marshmallow(app)

# # Sign Up Table
# class SignUp(db.Model):
#     SID = db.Column(db.Integer, primary_key=True)
#     Password = db.Column(db.String(50), nullable=False)

#     def __init__(self, SID, Password):
#         self.SID = SID
#         self.Password = Password

# class SignUpSchema(ma.Schema):
#     class Meta:
#         fields = ("SID", "Password")


# # Init Schema
# signup_schema = SignUpSchema()
# signups_schema = SignUpSchema(many=True)

# app = Flask(__name__)

# # Getting data from super
# @app.route('/signup/<SID>', methods=['GET'])
# def check_SID(SID):
#     sid_in_super = Super.query.get(SID)
#     # print(sid_in_super)

#     if not sid_in_super:
#         # does not exists in database
#         return jsonify({'code':401})

#     if sid_in_super:
#         sid_in_signup = SignUp.query.get(SID)
#         # print(sid_in_signup)
#         if sid_in_signup:
#             # already signed up
#             return jsonify({'code':402})

#         if not sid_in_signup:
#             # go ahead for Password, valid user--> hasn't signed up
#             return jsonify({'code':200})
        
# # adding signup info to the table
# @app.route('/signup', methods=['POST'])
# def sign_up():
#     SID = request.json['SID']
#     Password = request.json['Password']

#     # checking if already in sign up before proceeding
#     sid_in_signup = SignUp.query.get(SID)
#     if sid_in_signup:
#         # already igned up 
#         return jsonify({'code':402})

#     hashed_pwd = bcrypt.hashpw(Password.encode('utf-8'), bcrypt.gensalt())
#     new_signup = SignUp(SID, hashed_pwd)

#     db.session.add(new_signup)
#     db.session.commit()

#     Auth_info = Auth.query.get(SID)
#     if not Auth_info:
#         # normal user --> no secy or CR
#         return jsonify({"code": 200, "Auth": 0})

    
#     else :
#         # either a secy or a CR
#         output = json.dumps(Auth_info.Auth)
#         return jsonify({"code": 200, "Auth": int(output)})

# # GET All SignUp
# @app.route('/signup', methods=['GET'])
# def get_signups():
#     all_signups = SignUp.query.all()
#     result = signups_schema.dump(all_signups)
#     return jsonify(result)


# # change/update Password
# @app.route('/signup/<SID>', methods=['PUT'])
# def update_Password(SID):
#     signup_info = SignUp.query.get(SID)

#     SID = request.json['SID']
#     Password = request.json['Password'] # new Password

#     # check if it exists in sign up table
#     if not signup_info:
#         # has not signed up yet
#         return jsonify({'code':403})
#     else:
#         # check if new Password is same as the old one
#         if bcrypt.checkpw(Password.encode('utf-8'), signup_info.Password):
#             # new Password == old Password 
#             return jsonify({'code':301})
#         else :
#             # all good to update the Password 
#             hashed_pwd = bcrypt.hashpw(Password.encode('utf-8'), bcrypt.gensalt())
#             signup_info.SID = SID
#             signup_info.Password = hashed_pwd

#             db.session.commit()

#             return jsonify({'code' : 200})

# # login
# @app.route('/login', methods=['POST'])
# def login():
#     SID = request.json['SID']
#     Password = request.json['Password']

#     signup_info = SignUp.query.get(SID)

#     if not signup_info:
#         # not signed up
#         return jsonify({'code':403})

#     else :
#         if bcrypt.checkpw(Password.encode('utf-8'), signup_info.Password):
#             # correct sid and Password
#             Auth_info = Auth.query.get(SID)
#             if not Auth_info:
#                 # normal user --> no secy or CR
#                 return jsonify({'code': 200, 'Auth': 0})
            
#             else :
#                 # either a secy or a CR
#                 output = json.dumps(Auth_info.Auth)
#                 return jsonify({'code': 200, 'Auth': int(output)})
#         else : 
#             # correct sid, wrong Password
#             return jsonify({'code':404})

# # delete from signup 
# @app.route('/signup/<SID>', methods=['DELETE'])
# def delete_signup(SID):
#     signup_info = SignUp.query.get(SID)

#     # check if the user exists in sign up 
#     if not signup_info:
#         # has not signed up yet
#         return jsonify({'code':403})

#     # ask for Password for extra confirmation --> maybe

#     db.session.delete(signup_info)
#     db.session.commit()

#     return jsonify({'code':200})
