#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, PersonalSchema, Clubs, ClubSchema,  db, ma, personal_schema

pecsocialblue = Blueprint("pecsocialblue", __name__)

@pecsocialblue.route("/social", methods=["GET"])
def get_social():

    person = db.session.query(Personal, Clubs).outerjoin(Personal, Clubs.SID == Personal.SID)
    result = personal_schema.dump(person)
    return jsonify(result)


# #Get Single personal
# @personalblue.route('/personal/<SID>', methods=['GET'])
# def get_super(SID):
#     single_personal = Personal.query.get(SID)
#     result = personal_schema.dump(single_personal)
#     return jsonify(result)