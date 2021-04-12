#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Authorization, AuthorizationSchema, authorization_schema
from database.extensions import db, ma

authblue = Blueprint("authblue", __name__)


# Enter data into Auth Table
@authblue.route('/auth', methods=['POST'])
def add_auth():
    SID = request.json['SID']
    Auth = request.json['Auth']

    # check if already exists in Auth
    sid_in_auth = Authorization.query.get(SID)
    if sid_in_auth:
        # Authorization already granted
        return jsonify({'code':405})

    new_auth = Authorization(SID, Auth)

    db.session.add(new_auth)
    db.session.commit()

    return jsonify({'code':200})

# GET Auth
@authblue.route('/auth/<SID>', methods=['GET'])
def get_auth(SID):
    auth_info = Authorization.query.get(SID)
    result = authorization_schema.dump(auth_info)
    return jsonify(result)

# Update Auth
@authblue.route('/auth/<SID>', methods=['PUT'])
def update_Auth(SID):
    auth_info = Authorization.query.get(SID)

    SID = request.json['SID']
    Auth = request.json['Auth'] # new Auth

    # check if Auth already exists
    if not auth_info:
        # no Authorization granted --> can't update
        return jsonify({'code': 406})

    auth_info.SID = SID
    auth_info.Auth = Auth

    # check if Auth is changed to 0 
    if Auth == 0 :
        # then remove from db
        db.session.delete(auth_info)
        db.session.commit()
        return jsonify({'code':200})


    db.session.commit()

    return jsonify({'code':200})


# deleter from Auth table
@authblue.route('/auth/<SID>', methods=['DELETE'])
def delete_Auth(SID):
    auth_info = Authorization.query.get(SID)

    # check if it even exists in Auth 
    if not auth_info:
        # no Authorization granted
        return jsonify({'code':406})

    db.session.delete(auth_info)
    db.session.commit()
    return jsonify({'code':200})
