#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Clubs, ClubSchema, club_schema, db, ma

clubblue = Blueprint("clubblue", __name__)

#Create a Club Row (exclusively for us)
@clubblue.route('/club', methods=['POST'])
def add_club():
    SID = request.json['SID']
    Club_codes = request.json['Club_codes']

    new_club = Clubs(SID, Club_codes, SID)

    db.session.add(new_club)
    db.session.commit()

    # returns the created json 
    return club_schema.jsonify(new_club)


# creating club row during signup 
@clubblue.route('/signupclub', methods=["POST"])
def clubs_add():
    SID = request.json['SID']
    club_list = request.json['Clubs']

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

