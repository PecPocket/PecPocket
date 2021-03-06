#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Signup, SignUpSchema,  Personal, PersonalSchema,  Authorization, AuthorizationSchema, signup_schema, personal_schema, authorization_schema, db, ma

deleteblue = Blueprint("deleteblue", __name__)

#---> might have to reconfirm the password for signup account first.

#deleting account from various tables
@deleteblue.route("/delete/<SID>", methods=['DELETE'])
def delete_account(SID):
    
    signup_delete = Signup.query.get(SID)

    # check if the user exists in sign up 
    if not signup_delete:
        return jsonify({'code':403})

    #deleting from SignUp
    db.session.delete(signup_delete)
    db.session.commit()

    #delete from personal
    personal_delete = Personal.query.get(SID)
    db.session.delete(personal_delete)
    db.session.commit()

    #deleting from auth (if there)
    auth_delete = Authorization.query.get(SID)
    if auth_delete:
        db.session.delete(auth_delete)
        db.session.commit()

    return jsonify({"code":200})



