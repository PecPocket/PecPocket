#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, PersonalSchema, personal_schema, personals_schema, db, ma

personalblue = Blueprint("personal", __name__)

#Update Personal
@personalblue.route("/personal/<SID>", methods=["PUT"])
def update_personal(SID):
    personal_info = Personal.query.get(SID)

    if not personal_info :
        # not signed up
        return jsonify({'code': 403})

    SID = request.json['SID']
    Name = request.json['Name']
    Branch = request.json['Branch']
    Year = request.json['Year']
    Semester = request.json['Semester']
    Club_codes = request.json['Club_codes']
    Insta = request.json["Insta"]

    personal_info.Name = Name
    personal_info.SID = SID
    personal_info.Branch = Branch
    personal_info.Year = Year
    personal_info.Semester = Semester
    personal_info.Club_codes = Club_codes
    personal_info.Insta = Insta

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

# Add instagram handle to personal
@personalblue.route('/insta/<SID>', methods=["PUT"])
def add_insta(SID):
    single_insta = Personal.query.get(SID)

    SID = request.json["SID"]
    insta = request.json["Insta"]

    if not single_insta:
        return jsonify({"code": 404})

    single_insta.Insta = insta

    db.session.commit()

    return jsonify({"code": 200})








