#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Personal, PersonalSchema, personal_schema, personals_schema, ClubConvertor, db, ma

personalblue = Blueprint("personal", __name__)

def update_credentials():
    all_personal = Personal.query.all()

    for person in all_personal:
        sid = person.SID

        admyear = int(str(sid)[0:2])
        currentyear = thisyear-admyear if thismonth<5 else thisyear-admyear+1
        sem = currentyear*2 if thismonth<5 else currentyear*2-1

        person.Semester = sem
        person.Year = currentyear

        db.session.commit()

    return


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
    Avatar = request.json['Avatar']

    personal_info.Name = Name
    personal_info.SID = SID
    personal_info.Branch = Branch
    personal_info.Year = Year
    personal_info.Semester = Semester
    personal_info.Club_codes = Club_codes
    personal_info.Insta = Insta
    personal_info.Avatar = Avatar

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


# Get personal data during view profile 
@personalblue.route('/viewprofile/<SID>', methods=["GET"])
def get_profile(SID):

    person = Personal.query.get(SID)

    if not person:
        return jsonify({"code": 404})
    
    sid = person.SID
    club_list = []
    if person.Club_codes is not None:

        club_codes = person.Club_codes
        for i in range(0,len(club_codes),2):
            club_str = club_codes[i:i+2]

            # convert codes into names
            club_name = ClubConvertor.query.get(club_str).Club
            club_list.append(club_name)
    response = jsonify({"Name": person.Name, "SID": person.SID, "Branch":person.Branch, "Year": person.Year, "Semester": person.Semester, "Clubs": club_list, "Insta" : person.Insta, "Avatar" : person.Avatar})

    return response


# @personalblue.route('/avatar', methods=['POST'])
# def add_avatar():
#     sid = request.json['SID']
#     avatar = request.json['Avatar']

#     personal_info = Personal.query.get(sid)

#     if not personal_info :
#         # not signed up
#         return jsonify({'code':404})

#     personal_info.Avatar = str(avatar)
#     db.session.commit()

#     return jsonify({'code': 200})


@personalblue.route('/avatar', methods=['PUT'])
def update_avatar():
    sid = request.json['SID']
    avatar = request.json['Avatar']

    personal_info = Personal.query.get(sid)

    if not personal_info :
        # not signed up
        return jsonify({'code':404})

    personal_info.Avatar = avatar
    db.session.commit()

    return jsonify({'code': 200})


@personalblue.route('/personal/delete/<SID>', methods=['DELETE'])
def delete_personal(SID):
    personal_info = Personal.query.get(SID)

    db.session.delete(personal_info)
    db.session.commit()

    return jsonify({'code':200})









