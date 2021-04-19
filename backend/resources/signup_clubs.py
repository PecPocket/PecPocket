#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import ClubConvertor, ClubConvertorSchema, club_convertors_schema, Clubs, ClubSchema,  db, ma

signupclubsblue = Blueprint("signupclubsblue", __name__)

@signupclubsblue.route('/clubs', methods=["POST"])
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







# @sub_convblue.route('/subconvertor/search', methods=['GET'])
# def search_sub():

#     word = str((request.args['query']))
#     searched = SubConvertor.query.whoosh_search(word).all()

#     sub_list = []

#     for line in searched:
#         sub_list.append(line.Sub_code)
    
#     return jsonify({'subjects': sub_list})

#     # result = sub_convertor_schema.dump(searched)
#     # return jsonify(result)
#     # return jsonify({"query": word})