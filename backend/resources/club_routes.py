#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, personal_schema, personals_schema, ClubConvertor, SignUp, db, ma

clubblue = Blueprint("clubblue", __name__)

#Create a Club Row 
@clubblue.route('/club', methods=['POST'])
def add_club():
    SID = request.json['SID']
    Club_list = request.json['Club_codes']  # club codes as a list

    personal_info = Personal.query.get(SID)

    if not personal_info :
        # sid not in personal --> not signed up
        return jsonify({'code':403})
    
    if len(personal_info.Club_codes) != 0:
        #sid already has clubs
        return jsonify({'code':407})

    if Club_list is None :
        # empty list
        return jsonify({'code':200})

    club_string = ""
    for club in Club_list:
        club_string += str(club)

    personal_info.Club_codes = club_string
    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})


# Update a Club Row
@clubblue.route('/club/<SID>', methods=['PUT'])
def update_club(SID):

    signup_check = SignUp.query.get(SID)

    SID = request.json["SID"]
    Club_list = request.json["Club_codes"] # as a list

    if not signup_check:
        #student not signed up
        return jsonify({'code': 403})

    personal_info = Personal.query.get(SID)

    if not personal_info.Club_codes :
        # student has no current clubs, make a POST request
        return jsonify({'code':501})

    if Club_list is None :
        personal_info.Club_codes = ""

        db.session.commit()
        return jsonify({'code':200})

    club_string = ""
    for club in Club_list:
        club_string += str(club)

    
    personal_info.Club_codes = club_string

    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})


# GET a list of clubs for a particular SID
@clubblue.route('/club/<SID>', methods =['GET'])
def get_clubs(SID):
    

    signup_check = SignUp.query.get(SID)

    if not signup_check:
        #student not signed up
        return jsonify({'code':403})

    personal_info = Personal.query.get(SID)

    clubs_of_student = personal_info.Club_codes

    if len(personal_info.Club_codes) == 0 :
        # student has no club
        return jsonify({'code': 407})

    club_list = []
    for i in range(0,len(clubs_of_student),2):
        club_str = clubs_of_student[i:i+2]

        #convert names into codes
        club_name = ClubConvertor.query.get(club_str).Club
        club_list.append(club_name)

    return jsonify({'clubs' : club_list})
