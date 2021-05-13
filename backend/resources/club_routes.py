#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, personal_schema, personals_schema, ClubConvertor, Signup, db, ma

clubblue = Blueprint("clubblue", __name__)

#Create a Club Row 
@clubblue.route('/club', methods=['POST'])
def add_club():
    SID = request.json['SID']
    Club_string = request.json['Club_codes']  # club codes as a string "010203.."

    personal_info = Personal.query.get(SID)

    if not personal_info :
        # sid not in personal --> not signed up
        return jsonify({'code':403})
    
    if personal_info.Club_codes:
        #sid already has clubs
        return jsonify({'code':407})

    if not Club_string:
        # empty list
        return jsonify({'code':200})


    personal_info.Club_codes = Club_string
    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})


# Update a Club Row
@clubblue.route('/club/<SID>', methods=['PUT'])
def update_club(SID):

    SID = request.json['SID']
    Club_string = request.json['Club_codes']  # club codes as a string "010203.."

    personal_info = Personal.query.get(SID)

    if not personal_info :
        # sid not in personal --> not signed up
        return jsonify({'code':403})
    
    # if personal_info.Club_codes:
    #     #sid already has clubs
    #     return jsonify({'code':407})

    if not Club_string:
        # empty list
        personal_info.Club_codes = ""
        db.session.commit()
        return jsonify({'code':200})


    personal_info.Club_codes = Club_string
    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})


# GET a list of clubs for a particular SID
@clubblue.route('/club/<SID>', methods =['GET'])
def get_clubs(SID):
    

    signup_check = Signup.query.get(SID)

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
