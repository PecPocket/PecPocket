#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import ClubConvertor, ClubConvertorSchema, club_convertors_schema, Clubs, ClubSchema
from database.extensions import db, ma

signupclubsblue = Blueprint("signupclubsblue", __name__)



    
@signupclubsblue.route("/signup/clubs", methods=["GET"])
def get_signup_clubs():
    signup_clubs = ClubConvertor.query.all()
    # result = club_convertors_schema.dump(signup_clubs)
    # return jsonify(result)

    final = []

    for clubs in signup_clubs:
        final.append(clubs.Club_code)
    
    return jsonify({"values": final})
        
@signupclubsblue.route("/club/<Club_code>", methods=['GET'])
def students_in_club(Club_code):
    search = "%{}%".format(Club_code)
    students = Clubs.query.filter(Clubs.Club_codes.like(search)).all()

    peeps = []
    for kids in students:
        peeps.append(kids.SID)

    return jsonify({"Students": peeps})


    