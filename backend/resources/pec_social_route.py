#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, PersonalSchema, Clubs, ClubSchema,  db, ma, personals_schema, clubs_schema
import json
from sqlalchemy import or_
from sqlalchemy.orm import relationship

pecsocialblue = Blueprint("pecsocialblue", __name__)

@pecsocialblue.route("/social", methods=["GET"])
def get_social():

    word = str(request.args['query'])
    search = "%{}%".format(word)

    person = Personal.query.join(Clubs).filter(or_(Personal.Name.like(search),Personal.Name.like(search) )).all()
    result = personals_schema.dump(person)
    return jsonify(result)
    

# #Get Single personal
# @personalblue.route('/personal/<SID>', methods=['GET'])
# def get_super(SID):
#     single_personal = Personal.query.get(SID)
#     result = personal_schema.dump(single_personal)
#     return jsonify(result)