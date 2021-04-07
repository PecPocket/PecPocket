# pylint: disable=no-member
from flask import Flask, request, jsonify
from __main__ import app
from main_backend import Auth, AuthSchema, db
import json
# from flask_marshmallow import Marshmallow

# # Init Marshmallow
# ma = Marshmallow(app)

# # Auth Table
# class Auth(db.Model):
#     SID = db.Column(db.Integer, primary_key=True)
#     Auth = db.Column(db.Integer, nullable=False)

#     def __init__(self, SID, Auth):
#         self.SID = SID
#         self.Auth = Auth

# class AuthSchema(ma.Schema):
#     class Meta:
#         model = Auth


# Init Schema
Auth_schema = AuthSchema()

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

# GET Auth
@app.route('/Auth/<SID>', methods=['GET'])
def get_auth(SID):
    Auth_info = Auth.query.get(SID)
    result = Auth_schema.dump(Auth_info)
    return jsonify(result)

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