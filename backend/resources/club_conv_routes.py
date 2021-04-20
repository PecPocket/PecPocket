#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import ClubConvertor, ClubConvertorSchema, club_convertor_schema, club_convertors_schema, db, ma

club_convblue = Blueprint("club_convblue", __name__)

# GET All ClubConvertor
@club_convblue.route('/clubconvertor', methods=['GET'])
def get_club_convs():
    all_club_conv = ClubConvertor.query.all()
    result = club_convertors_schema.dump(all_club_conv)
    return jsonify(result)


# GET Single ClubConvertor
@club_convblue.route('/clubconvertor/<Club_code>', methods=['GET'])
def get_club_conv(Club_code):
    club_conv_detail = ClubConvertor.query.get(Club_code)
    result = club_convertor_schema.dump(club_conv_detail)
    return jsonify(result)

#Create a ClubConvertor Row
@club_convblue.route('/clubconvertor', methods=['POST'])
def add_club_conv():
    Club_code = request.json['Club_code']
    Club = request.json['Club']

    new_club_conv = ClubConvertor(Club_code, Club)

    db.session.add(new_club_conv)
    db.session.commit()

    # returns the created json 
    return club_convertor_schema.jsonify(new_club_conv)


# Update a ClubConvertor Row
@club_convblue.route('/clubconvertor/<Club_code>', methods=['PUT'])
def update_club_conv(Club_code):
    club_conv_detail = ClubConvertor.query.get(Club_code)

    Club_code = request.json['Club_code']
    Club = request.json['Club']

    club_conv_detail.Club_code = Club_code
    club_conv_detail.Club = Club

    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})


# Delete ClubConvertor
@club_convblue.route('/clubconvertor/<Club_code>', methods=['DELETE'])
def delete_club_conv(Club_code):
    club_conv_detail = ClubConvertor.query.get(Club_code)
    db.session.delete(club_conv_detail)
    db.session.commit()
    return jsonify({'code':200})


