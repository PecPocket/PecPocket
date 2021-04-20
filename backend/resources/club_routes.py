#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Clubs, ClubSchema, club_schema, ClubConvertor, db, ma

clubblue = Blueprint("clubblue", __name__)

#Create a Club Row (exclusively for us)
@clubblue.route('/club', methods=['POST'])
def add_club():
    SID = request.json['SID']
    Club_codes = request.json['Club_codes']

    new_club = Clubs(SID, Club_codes)

    db.session.add(new_club)
    db.session.commit()

    # returns the created json 
    return club_schema.jsonify(new_club)


# creating club row during signup 
@clubblue.route('/signupclub', methods=["POST"])
def clubs_add():
    SID = request.json['SID']
    club_list = request.json['Clubs'] # as a list

    if club_list is None :
        # empty list
        return jsonify({'code':200})

    club_string = ""
    for club in club_list:
        club_string += str(club)
    
    new_club = Clubs(SID, club_string)

    db.session.add(new_club)
    db.session.commit()

    return jsonify({"code" : 200})


# Update a Club Row
@clubblue.route('/club/<SID>', methods=['PUT'])
def update_club(SID):
    club_detail = Clubs.query.get(SID)

    SID = request.json['SID']
    Club_codes = request.json['Club_codes']

    if not club_detail :
        # student has no current clubs, make a POST request
        return jsonify({'code':501})

    if len(Club_codes) == 0 :
        db.session.delete(club_detail)
        db.session.commit()
        return jsonify({'code':200})

    club_detail.SID = SID
    club_detail.Club_codes = Club_codes

    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})


# GET a list of clubs for a particular SID
@clubblue.route('/club/<SID>', methods =['GET'])
def get_clubs(SID):
    club_detail = Clubs.query.get(SID)

    clubs_of_student = club_detail.Club_codes

    if not club_detail :
        # student has no club
        return jsonify({'code': 407})

    club_list = []
    for i in range(0,len(clubs_of_student),2):
        club_str = clubs_of_student[i:i+2]

        #convert names into codes
        club_name = ClubConvertor.query.get(club_str).Club
        club_list.append(club_name)

    return jsonify({'clubs' : club_list})
