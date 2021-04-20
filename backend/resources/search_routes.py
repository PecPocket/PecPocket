#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import SubConvertor, SubConvertorSchema, sub_convertor_schema, sub_convertors_schema, db, ma

from sqlalchemy import or_

searchblue = Blueprint("searchblue", __name__)


#sending all subjects that have been searched for during sign up using query
@searchblue.route('/subject/search', methods=["GET"])
def search_sub():

    word = str(request.args['query'])
    search = "%{}%".format(word)
    subject_list = SubConvertor.query.filter(or_(SubConvertor.Sub_code.like(search),SubConvertor.Subject.like(search) ))

    result = sub_convertors_schema.dump(subject_list)
    return jsonify(result)


#returns list of clubs which match the string searched for.
@searchblue.route("/club/search", methods=["GET"])
def search_club():
    word = str(request.args['query'])
    search = "%{}%".format(word)
    club_list = ClubConvertor.query.filter(ClubConvertor.Club.like(search)).all()

    result = club_convertors_schema.dump(club_list)
    return jsonify(result)