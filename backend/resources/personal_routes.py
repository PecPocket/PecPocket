#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, PersonalSchema, personal_schema, personals_schema
from database.extensions import db, ma

personalblue = Blueprint("personal", __name__)

#Create a Personal Row


#Update Personal
@personalblue.route("/personal/<SID>", methods=["PUT"])
def update_personal(SID):
    personal_info = Personal.query.get(SID)

    SID = request.json['SID']
    Name = request.json['Name']
    Branch = request.json['Branch']
    Year = request.json['Year']
    Semester = request.json['Semester']

    personal_info.Name = Name
    personal_info.SID = SID
    personal_info.Branch = Branch
    personal_info.Year = Year
    personal_info.Semester = Semester

    db.session.commit()

    #return for successful creation
    return jsonify({'code':200})

#Get all personal
@personalblue.route('/personal', methods=['GET'])
def get_personals():
    all_personals = Personal.query.all()
    result = personals_schema.dump(all_personals)
    return jsonify(result)

#Get Single personal
@personalblue.route('/personal/<SID>', methods=['GET'])
def get_super(SID):
    single_personal = Personal.query.get(SID)
    result = personal_schema.dump(single_personal)
    return jsonify(result)


