#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Notifications, NotificationsSchema, StudentNoti, StudentNotiSchema, noti_schema, notis_schema, studentnoti_schema, studentnotis_schema, db, ma

from datetime import datetime
import bcrypt
import json

notiblue = Blueprint("notiblue", __name__)

@notiblue.route('/noti', methods=['POST'])
def add_noti():
    Noti_id = request.json['Noti_id']
    Topic = request.json['Topic']
    Description = request.json['Description']
    Date = request.json['Date']
    Time = request.json['Time']

    new_date = datetime.strptime(Date, '%d-%m-%Y').date()
    new_time = datetime.strptime(Time, '%H:%M').time()

    new_noti = Notifications(Noti_id, Topic, Description, new_date, new_time)

    db.session.add(new_noti)
    db.session.commit()

    return noti_schema.jsonify(new_noti)


@notiblue.route('/studentnoti', methods=['POST'])
def add_studentnoti():
    Noti_id = request.json['Noti_id']
    ID = request.json['ID']
    SID = request.json['SID']

    relevant_noti = Notifications.query.filter_by(Noti_id=Noti_id).first()

    if not relevant_noti :
        # no notification for this id in notifications table
        return jsonify({'cdoe': 505})

    new_studentnoti = StudentNoti(ID, SID, relevant_noti)

    db.session.add(new_studentnoti)
    db.session.commit()

    return jsonify({'code':200})
    

@notiblue.route('/deletenotis/<Noti_id>', methods=['DELETE'])
def delete_notis(Noti_id):
    noti_info = Notifications.query.get(Noti_id)

    db.session.delete(noti_info)
    db.session.commit()

    return jsonify({'code':200})



# for testing purposes 

# @notiblue.route('/deletestunotis/<ID>', methods=['DELETE'])
# def delete_studentnotis(ID):
#     noti_info = StudentNoti.query.get(ID)

#     db.session.delete(noti_info)
#     db.session.commit()

#     return jsonify({'code':200})