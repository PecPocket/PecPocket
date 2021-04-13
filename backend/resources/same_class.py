#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal
from database.extensions import db, ma


sameyearblue = Blueprint("sameyearblue", __name__)

@sameyearblue.route("/cr/<SID>", methods=['GET'])
def same_class(SID):
    cr = Personal.query.get(SID)
    branch = cr.Branch
    semester = cr.Semester
    mates = Personal.query.filter_by(Branch=branch, Semester=semester).all()

    kids = []

    for peeps in mates:
        kids.append(peeps.SID)

    return jsonify({"Students":kids})



