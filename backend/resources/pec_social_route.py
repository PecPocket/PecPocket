#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, PersonalSchema, Clubs, ClubSchema,  db, ma, personals_schema, clubs_schema, pec_socials_schema
import json
from sqlalchemy import or_
from sqlalchemy.orm import relationship


pecsocialblue = Blueprint("pecsocialblue", __name__)

@pecsocialblue.route("/social", methods=["GET"])
def get_social():

    word = str(request.args['query'])
    search = "%{}%".format(word)

    # person = Personal.query.join(Clubs).filter(or_(Personal.Name.like(search),Personal.Name.like(search) )).all()
    # result = personals_schema.dump(person)
    # return jsonify(result)

    people = db.session.query(Personal.SID, Personal.Name, Personal.Year, Personal.Branch, Personal.Semester, Clubs.Club_codes).outerjoin(Clubs, Personal.SID == Clubs.personal_id).filter(or_(Personal.Name.like(search),Personal.SID.like(search) )).all()

    for person in people:
        clubs = []
        club_string = person.Club_codes
        i=0
        while i<len(club_string):
            clubs.append(club_string[i:i+2])
            i+=1
        person.Club_codes = clubs 
    # result = pec_socials_schema.dump(people)
    # return jsonify(result)
    # name = ""
    # year = 0 
    # seme = 0 
    # branch = ""
    # sid = ""
    # clubs = ""
    # print(people)
   
#    name = people[0].Name
    # print(type(people.Club_codes))
    # return jsonify({"type": 1})

    

# #Get Single personal
# @personalblue.route('/personal/<SID>', methods=['GET'])
# def get_super(SID):
#     single_personal = Personal.query.get(SID)
#     result = personal_schema.dump(single_personal)
#     return jsonify(result)