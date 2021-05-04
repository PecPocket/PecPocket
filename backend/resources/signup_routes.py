#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Super, SignUp, signup_schema, signups_schema, SignUpSchema, SuperSchema, Authorization, Personal, db, ma
from datetime import datetime
import bcrypt
import json

signblue = Blueprint("signblue", __name__)

# Getting data from super
@signblue.route('/signup/<SID>', methods=['GET'])
def check_SID(SID):
    sid_in_super = Super.query.get(SID)
    # print(sid_in_super)

    if not sid_in_super:
        # does not exists in database
        return jsonify({'code':401})

    if sid_in_super:
        sid_in_signup = SignUp.query.get(SID)
        # print(sid_in_signup)
        if sid_in_signup:
            # already signed up
            return jsonify({'code':402})

        if not sid_in_signup:
            # go ahead for Password, valid user--> hasn't signed up
            return jsonify({'code':200})

# branch dict
branch_dict = {1:'Aerospace Engineering', 2:'Civil Engineering', 3:'Computer Science Engineering', 4:'Electrical Engineering', 
5:'Electronics & Communication Engineering', 7: 'Mechanical Engineering', 
8: 'Materials & Metallurgical Engineering', 9:'Production & Industrial Engineering'}

# get branch
def getBranch(SID):
    branch_code = str(SID)[4]
    branch_name = branch_dict[int(branch_code)]
    return branch_name

# get year
def getYear(SID):
    presentTime = datetime.now()
    # current year --> yy format
    thisyear = presentTime.year%100 
    # current month 
    thismonth = presentTime.month
    # the admission year of the student 
    admyear = int(str(SID)[0:2])

    # year in degree 
    currentyear = thisyear-admyear if thismonth<7 else thisyear-admyear+1
    if currentyear > 4:
        return -1

    return currentyear

# get semester
def getSemester(currentyear):
    presentTime = datetime.now()
    thismonth = presentTime.month
    sem = currentyear*2 if thismonth<7 else currentyear*2-1
    if sem > 8:
        return -1
    return sem

# adding signup info to the table
@signblue.route('/signup', methods=['POST'])
def sign_up():
    SID = request.json['SID']
    Password = request.json['Password']

    # checking if already in sign up before proceeding
    sid_in_signup = SignUp.query.get(SID)
    if sid_in_signup:
        # already signed up 
        return jsonify({'code':402})

    hashed_pwd = bcrypt.hashpw(Password.encode('utf-8'), bcrypt.gensalt())
    new_signup = SignUp(SID, hashed_pwd)

    # get name from super 
    super_details = Super.query.get(SID)

    if not super_details:
        return jsonify({'code':401})

    Name = super_details.Name

    # get branch name
    Branch = getBranch(SID)

    # get year
    Year = getYear(SID)

    # get semester
    Semester = getSemester(Year)

    # ADD TO PERSONAL TABLE
    db.session.add(Personal(SID, Name, Branch, Year, Semester, "","-"))
    db.session.commit()

    db.session.add(new_signup)
    db.session.commit()
    

    auth_info = Authorization.query.get(SID)
    if not auth_info:
        # normal user --> no secy or CR
        return jsonify({"code": 200, "Auth": 0})

    
    else :
        # either a secy or a CR
        output = json.dumps(auth_info.Auth)
        return jsonify({"code": 200, "Auth": int(output)})

# GET All SignUp
@signblue.route('/signup', methods=['GET'])
def get_signups():
    all_signups = SignUp.query.all()
    result = signups_schema.dump(all_signups)
    return jsonify(result)


# change/update Password
@signblue.route('/signup/<SID>', methods=['PUT'])
def update_Password(SID):
    signup_info = SignUp.query.get(SID)

    SID = request.json['SID']
    Password = request.json['Password'] # new Password

    # check if it exists in sign up table
    if not signup_info:
        # has not signed up yet
        return jsonify({'code':403})
    else:
        # check if new Password is same as the old one
        if bcrypt.checkpw(Password.encode('utf-8'), signup_info.Password):
            # new Password == old Password 
            return jsonify({'code':301})
        else :
            # all good to update the Password 
            hashed_pwd = bcrypt.hashpw(Password.encode('utf-8'), bcrypt.gensalt())
            signup_info.SID = SID
            signup_info.Password = hashed_pwd

            db.session.commit()

            return jsonify({'code' : 200})

# login
@signblue.route('/login', methods=['POST'])
def login():
    SID = request.json['SID']
    Password = request.json['Password']

    signup_info = SignUp.query.get(SID)

    if not signup_info:
        # not signed up
        return jsonify({'code':403})

    else :
        if bcrypt.checkpw(Password.encode('utf-8'), signup_info.Password):
            # correct sid and Password
            auth_info = Authorization.query.get(SID)
            if not auth_info:
                # normal user --> no secy or CR
                return jsonify({'code': 200, 'Auth': 0})
            
            else :
                # either a secy or a CR
                output = json.dumps(auth_info.Auth)
                return jsonify({'code': 200, 'Auth': int(output)})
        else : 
            # correct sid, wrong Password
            return jsonify({'code':404})

# # delete from signup 
@signblue.route('/signup/<SID>', methods=['DELETE'])
def delete_signup(SID):
    signup_info = SignUp.query.get(SID)

    # check if the user exists in sign up 
    if not signup_info:
        # has not signed up yet
        return jsonify({'code':403})

    # ask for Password for extra confirmation --> maybe

    db.session.delete(signup_info)
    db.session.commit()

    return jsonify({'code':200})
