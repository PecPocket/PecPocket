#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import ClubConvertor, ClubConvertorSchema, club_convertors_schema, Clubs, ClubSchema,  db, ma

signupclubsblue = Blueprint("signupclubsblue", __name__)


# returns all students who are part of a particular club
@signupclubsblue.route("/club/<Club_code>", methods=['GET'])
def students_in_club(Club_code):
    search = "%{}%".format(Club_code)
    results = Clubs.query.filter(Clubs.Club_codes.like(search)).all()

    students_of_club = []
    for kids in results:
        students_of_club.append(kids.SID)

    return jsonify({"Students": peeps})

#returns list of clubs which match the string searched for.
@signupclubsblue.route("/clubs/search", methods=["GET"])
def search_club():

    word = str(request.args['query'])
    search = "%{}%".format(word)
    club_list = ClubConvertor.query.filter(ClubConvertor.Club.like(search)).all()

    result = club_convertors_schema.dump(club_list)
    return jsonify(result)

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