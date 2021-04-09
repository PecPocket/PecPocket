#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import BackElectSub, BackElectSubSchema, back_elect_sub_schema, back_elect_subs_schema
from database.extensions import db, ma

back_electblue = Blueprint("back_electblue", __name__)

#Create a BackElectSub Row
@back_electblue.route('/backElect', methods=['POST'])
def add_back_elect():
    SID = request.json['SID']
    Sub_codes = request.json['Sub_codes']

    new_back_elect = BackElectSub(SID, Sub_codes)

    db.session.add(new_back_elect)
    db.session.commit()

    # returns the created json 
    return back_elect_sub_schema.jsonify(new_back_elect)


# Update a BackElectSub Row
@back_electblue.route('/backElect/<SID>', methods=['PUT'])
def update_subject(SID):
    back_elect_detail = BackElectSub.query.get(SID)

    SID = request.json['SID']
    Sub_codes = request.json['Sub_codes']

    subject_detail.SID = SID
    subject_detail.Sub_codes = Sub_codes

    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})


# Delete BackElectSub
@back_electblue.route('/backElect/<SID>', methods=['DELETE'])
def delete_back_elect(SID):
    back_elect_detail = BackElectSub.query.get(SID)
    db.session.delete(back_elect_detail)
    db.session.commit()
    return jsonify({'code':200})

