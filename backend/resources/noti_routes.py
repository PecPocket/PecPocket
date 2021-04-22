# #pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Notifications, NotificationsSchema, StudentNoti, StudentNotiSchema, noti_schema, notis_schema, studentnoti_schema, studentnotis_schema, Authorization,Personal, StudentNoti,  db, ma

from datetime import datetime

notiblue = Blueprint("notiblue", __name__)

# # @notiblue.route('/noti', methods=['POST'])
# # def add_noti():
# #     Noti_id = request.json['Noti_id']
# #     Topic = request.json['Topic']
# #     Description = request.json['Description']
# #     Date = request.json['Date']
# #     Time = request.json['Time']

# #     new_date = datetime.strptime(Date, '%d-%m-%Y').date()
# #     new_time = datetime.strptime(Time, '%H:%M').time()

# #     new_noti = Notifications(Noti_id, Topic, Description, new_date, new_time)

# #     db.session.add(new_noti)
# #     db.session.commit()

# #     return noti_schema.jsonify(new_noti)


# # @notiblue.route('/studentnoti', methods=['POST'])
# # def add_studentnoti():
# #     Noti_id = request.json['Noti_id']
# #     ID = request.json['ID']
# #     SID = request.json['SID']

# #     relevant_noti = Notifications.query.filter_by(Noti_id=Noti_id).first()

# #     if not relevant_noti :
# #         # no notification for this id in notifications table
# #         return jsonify({'cdoe': 505})

# #     new_studentnoti = StudentNoti(ID, SID, relevant_noti)

# #     db.session.add(new_studentnoti)
# #     db.session.commit()

# #     return jsonify({'code':200})


# # @notiblue.route('/deletenotis/<Noti_id>', methods=['DELETE'])
# # def delete_notis(Noti_id):
# #     noti_info = Notifications.query.get(Noti_id)

# #     db.session.delete(noti_info)
# #     db.session.commit()

# #     return jsonify({'code':200})



# # for testing purposes 

# @notiblue.route('/deletestunotis/<ID>', methods=['DELETE'])
# def delete_studentnotis(ID):
#     noti_info = StudentNoti.query.get(ID)

#     db.session.delete(noti_info)
#     db.session.commit()

#     return jsonify({'code':200})

flag = 0

@notiblue.route('/noti/<SID>', methods=['POST'])
def add_noti(SID):

    auth_check = Authorization.query.get(SID)

    if not auth_check:
        # sid does not have authorization
        return jsonify({"code" : 404})
    
    # to check if CR or Seccy
    code = auth_check.Auth

    #getting student list
    student_list = []

    if code == 1 : 

        cr = Personal.query.get(SID)
        branch = cr.Branch
        semester = cr.Semester
        student_list = Personal.query.filter_by(Branch=branch, Semester=semester).all()


        for students in student_list:
            student_list.append(students.SID)

    elif code == 2:
        club =auth_check.Domain

        search = "%{}%".format(club)
        club_check = ClubConvertor.query.get(Club_code)
        results = Personal.query.filter(Personal.Club_codes.like(search)).all()

        if not club_check:
            return jsonify({"code": 401})

        if not results:
            #no students in that club
            return jsonify({"code": 403})

        for students in results:
            student_list.append(students.SID)
            

    #deleting if flag is 200 (yet to be done) (date time ka stuff)


    #making the Noti_id
    a = True
    while(a):
        checker = Notifications.query.filter(Notifications.Noti_id == flag).first()

        if checker:
            flag = (flag+1)%200
        else:
            a = False


    Noti_id = flag
    Topic = request.json['Topic']
    Description = request.json['Description']
    Date = request.json['Date']
    Time = request.json['Time']

    new_date = datetime.strptime(Date, '%d-%m-%Y').date()
    new_time = datetime.strptime(Time, '%H:%M').time()

    # saving the noti in Notifications Table
    new_noti = Notifications(Noti_id, Topic, Description, new_date, new_time)
    db.session.add(new_noti)
    db.session.commit()


    # saving data into StudentNoti for all sids in list
    for i in student_list:
        new_studentnoti = StudentNoti(i, Noti_id)
        db.session.add(new_studentnoti)
        db.session.commit()

    return jsonify({"code" : 200})


    
    




