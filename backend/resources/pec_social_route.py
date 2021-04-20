#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, PersonalSchema, Clubs, ClubSchema,  db, ma, personals_schema, clubs_schema, ClubConvertor
import json
from sqlalchemy import or_


pecsocialblue = Blueprint("pecsocialblue", __name__)

@pecsocialblue.route("/social", methods=["GET"])
def get_social():

    word = str(request.args['query'])
    search = "%{}%".format(word)

    all_personals = Personal.query.filter(or_(Personal.Name.like(search),Personal.SID.like(search) )).all()

    if len(all_personals) == 0:
        return jsonify({"code": 404})

    

    for person in all_personals:
        sid = person.SID
        club_list = []
        club_search = Clubs.query.get(sid)
        # response1 = jsonify({"random": 1})
        if club_search:

            club_codes = club_search.Club_codes
            for i in range(0,len(club_codes),2):
                club_str = club_codes[i:i+2]

                #convert codes into names
                club_name = ClubConvertor.query.get(club_str).Club
                club_list.append(club_name)
        response1 = jsonify({"Name": person.Name, "SID": person.SID, "Branch":person.Branch, "Year": person.Year, "Semester": person.Semester, "Clubs": club_list})

        return response1
        # club_search = clubs_schema.dump(club_search)
        # return jsonify(club_search)














    print(type(all_personals))



    result = personals_schema.dump(all_personals)
    return jsonify(result)

   