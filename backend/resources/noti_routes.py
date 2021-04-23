# #pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Notifications, NotificationsSchema, StudentNoti, StudentNotiSchema, noti_schema, notis_schema, studentnoti_schema, studentnotis_schema, Authorization,Personal, StudentNoti,  db, ma

from datetime import datetime

notiblue = Blueprint("notiblue", __name__)

# @notiblue.route('/noti', methods=['POST'])
# def add_notif():
#     Noti_id = request.json['Noti_id']
#     Topic = request.json['Topic']
#     Description = request.json['Description']
#     Date = request.json['Date']
#     Time = request.json['Time']

#     new_date = datetime.strptime(Date, '%d-%m-%Y').date()
#     new_time = datetime.strptime(Time, '%H:%M').time()

#     new_noti = Notifications(Noti_id, Topic, Description, new_date, new_time)

#     db.session.add(new_noti)
#     db.session.commit()

#     return noti_schema.jsonify(new_noti)


# @notiblue.route('/studentnoti', methods=['POST'])
# def add_studentnoti():
#     Noti_id = request.json['Noti_id']
#     #ID = request.json['ID']
#     SID = request.json['SID']

#     relevant_noti = Notifications.query.filter_by(Noti_id=Noti_id).first()

#     if not relevant_noti :
#         # no notification for this id in notifications table
#         return jsonify({'cdoe': 505})

#     new_studentnoti = StudentNoti(SID, relevant_noti.Noti_id)

#     db.session.add(new_studentnoti)
#     db.session.commit()

#     return jsonify({'code':200})


# @notiblue.route('/deletenotis/<Noti_id>', methods=['DELETE'])
# def delete_notis(Noti_id):
#     noti_info = Notifications.query.get(Noti_id)

#     db.session.delete(noti_info)
#     db.session.commit()

#     return jsonify({'code':200})



# # for testing purposes 

# @notiblue.route('/deletestunotis/<ID>', methods=['DELETE'])
# def delete_studentnotis(ID):
#     noti_info = StudentNoti.query.get(ID)

#     db.session.delete(noti_info)
#     db.session.commit()

#     return jsonify({'code':200})

def delete_notis():
    current_date = datetime.now().date()
    current_time = datetime.now().time()

    for i in range(1,201,1):
        noti_info = Notifications.query.get(i)

        if not noti_info :
            # the noti doesnt exist
            return jsonify({'code': 405})

        date = noti_info.Date
        time = noti_info.Time

        # check if the today's date > noti date 
        if current_date > date :
            # delete noti
            db.session.delete(noti_info)
            db.session.commit()


        elif current_date == date :
            # same date but now check time 
            if current_time > time :
                # delete noti
                db.session.delete(noti_info)
                db.session.commit()

        # else don't delete the noti 
        return 

 
flag = 1

@notiblue.route('/noti/<SID>', methods=['POST'])
def add_noti(SID):
    auth_check = Authorization.query.get(SID)

    if not auth_check:
        # sid does not have authorization
        return jsonify({"code" : 404})
    
    # to check if CR or Seccy
    code = auth_check.Auth
    print(code)

    #getting student list
    student_list = []

    if code == 1 : 

        cr = Personal.query.get(SID)
        branch = cr.Branch
        semester = cr.Semester
        students = Personal.query.filter_by(Branch=branch, Semester=semester).all()

        for student in students:
            student_list.append(student.SID)

    elif code == 2:
        club =auth_check.Domain

        search = "%{}%".format(club)
        club_check = ClubConvertor.query.get(club)
        results = Personal.query.filter(Personal.Club_codes.like(search)).all()

        if not club_check:
            return jsonify({"code": 401})

        if not results:
            #no students in that club
            return jsonify({"code": 403})

        for students in results:
            student_list.append(students.SID)
            

    #deleting if flag is 200 (yet to be done) (date time ka stuff)
    global flag
    if flag == 499:
        delete_notis()


    #making the Noti_id
    a = True
    while(a):
        checker = Notifications.query.filter(Notifications.Noti_id == flag).first()

        if checker:
            if flag == 499:
                flag = 1

            else:
                flag = (flag+1)%500
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



@notiblue.route('/noti/<SID>', methods=['GET'])
def get_noti(SID):
    notis = StudentNoti.query.get(SID).all()

    if not notis :
        # no notifications for this SID
        return jsonify({'code':406})

    notis_list = []

    for noti in notis :
        noti_id = noti.Noti_id
        noti_info = Notifications.query.get(noti_id)

        if not noti_info :
            return jsonify({'code': 405})

        # check if this noti is expired or not
        current_date = datetime.now().date()
        current_time = datetime.now().time()
        date = noti_info.Date
        time = noti_info.Time

        # check if the today's date > noti date 
        if current_date > date :
            # delete noti
            db.session.delete(noti_info)
            db.session.commit()

        elif current_date == date :
            # same date but now check time 
            if current_time > time :
                # delete noti
                db.session.delete(noti_info)
                db.session.commit()


        # if not expired then store in a variable
        notis_list.append(noti_info)

        # delete this noti from student notifications table
        noti_to_delete = StudentNoti.query.filter_by(Noti_id = noti_id).first()
        db.session.delete(noti_to_delete)
        db.session.commit()


    # now if all the notis were expired and notis list is empty
    if notis_list is None :
        return jsonify({'code':406})


    # if all is fine return the notis list
    return jsonify({'Notifications' : notis_list})



    
    




