#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Clubs, ClubSchema, club_schema, clubs_schema
from database.extensions import db, ma

clubblue = Blueprint("clubblue", __name__)

#Create a Subject Row
@clubblue.route('/club', methods=['POST'])
def add_club():
    SID = request.json['SID']
    Club_codes = request.json['Club_codes']

    new_club = Clubs(SID, Club_codes)

    db.session.add(new_club)
    db.session.commit()

    # returns the created json 
    return club_schema.jsonify(new_club)


# Update a Club Row
@clubblue.route('/club/<SID>', methods=['PUT'])
def update_club(SID):
    club_detail = Clubs.query.get(SID)

    SID = request.json['SID']
    Club_codes = request.json['Club_codes']

    club_detail.SID = SID
    club_detail.Club_codes = Club_codes

    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})


# Delete Club
@clubblue.route('/club/<SID>', methods=['DELETE'])
def delete_club(SID):
    club_detail = Clubs.query.get(SID)
    db.session.delete(club_detail)
    db.session.commit()
    return jsonify({'code':200})