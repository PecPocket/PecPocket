#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, db, ma
# from database.extensions import db, ma


stulistblue = Blueprint("stulistblue", __name__)

#to GET a list of all students from class of CR
@stulistblue.route("/cr/<SID>", methods=['GET'])
def same_class(SID):
    cr = Personal.query.get(SID)
    branch = cr.Branch
    semester = cr.Semester
    student_list = Personal.query.filter_by(Branch=branch, Semester=semester).all()

    students_in_class = []

    for students in student_list:
        students_in_class.append(students.SID)

    return jsonify({"Students":students_in_class})


# returns all students who are part of a particular club
@stulistblue.route("/club/<Club_code>", methods=['GET'])
def students_in_club(Club_code):
    search = "%{}%".format(Club_code)
    results = Clubs.query.filter(Clubs.Club_codes.like(search)).all()

    students_of_club = []
    for students in results:
        students_of_club.append(students.SID)

    return jsonify({"Students": students_of_club})



