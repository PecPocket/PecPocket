# #pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, PersonalSchema, db, ma, personals_schema, ClubConvertor
import json
from sqlalchemy import or_
import flask


pecsocialblue = Blueprint("pecsocialblue", __name__)

@pecsocialblue.route("/social", methods=["GET"])
def get_social():

    word = str(request.args['query'])
    search = "%{}%".format(word)

    check_in_club_convertor = []

    check_in_club_convertor = ClubConvertor.query.filter(ClubConvertor.Club.like(search)).all()

    len_club = len(check_in_club_convertor)

    search_club = "xx"
    all_personals = []

    if len_club == 0:
        # return jsonify({"code" : 10})
        all_personals = Personal.query.filter(or_(Personal.Name.like(search),Personal.SID.like(search))).all()

    else :
        for i in range(len_club):
            # return jsonify({"club" : check_in_club_convertor[i].Club_code} )
            search_club = "%{}%".format(check_in_club_convertor[i].Club_code)
            temp = Personal.query.filter(or_(Personal.Name.like(search),Personal.SID.like(search),Personal.Club_codes.like(search_club))).all()
            all_personals.extend(temp)
            # or_(Personal.Name.like(search),Personal.SID.like(search),

    # to remove duplicates
    all_personals = list(dict.fromkeys(all_personals))
    
    if len(all_personals) == 0:
        return jsonify({"code": 404})

    final_list = []

    for person in all_personals:
        sid = person.SID
        club_list = []
#         # response1 = jsonify({"random": 1})
        if person.Club_codes is not None:

            club_codes = person.Club_codes
            for i in range(0,len(club_codes),2):
                club_str = club_codes[i:i+2]

                # convert codes into names
                club_name = ClubConvertor.query.get(club_str).Club
                club_list.append(club_name)
        response1 = {"Name": person.Name, "SID": person.SID, "Branch":person.Branch, "Year": person.Year, "Semester": person.Semester, "Clubs": club_list, "Insta" : person.Insta}

        final_list.append(response1)

    return jsonify({"Students" : final_list})
















#     print(type(all_personals))



#     result = personals_schema.dump(all_personals)
#     return jsonify(result)

   