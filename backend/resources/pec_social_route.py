#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, PersonalSchema, Clubs, ClubSchema,  db, ma, personals_schema
import json

pecsocialblue = Blueprint("pecsocialblue", __name__)

@pecsocialblue.route("/social", methods=["GET"])
def get_social():

    word = str(request.args['query'])
    search = "%{}%".format(word)

    person = db.session.query(Personal.SID, Personal.Name, Personal.Branch, Personal.Year, Personal.Semester, Clubs.Club_codes).outerjoin(Clubs, Personal.SID == Clubs.personal_id).all()
    search = person.filter()
    result = personals_schema.dump(person)
    return jsonify(result)


# #Get Single personal
# @personalblue.route('/personal/<SID>', methods=['GET'])
# def get_super(SID):
#     single_personal = Personal.query.get(SID)
#     result = personal_schema.dump(single_personal)
#     return jsonify(result)